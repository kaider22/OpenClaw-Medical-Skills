---
name: drug-molecular-io
description: 提供读取、标准化并转换SMILES、SDF、MOL2、PDB结构的方法与调用指南；用于处理分子文件或SMILES及RDKit/Open Babel环境。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: RDKit
---

## Version Compatibility

Reference examples tested with: RDKit 2024.03+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Molecular I/O

## Codex 调用

- **选择**：请求涉及“读取、标准化并转换SMILES、SDF、MOL2、PDB结构”时使用；显式调用 `$drug-molecular-io`。
- **输入**：分子文件或SMILES及RDKit/Open Babel环境。
- **预期产物**：分子对象、标准化结构、转换文件和绘图；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`RDKit`、`openbabel`、`rdkit`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Load my chemical library into Python"** → Parse molecular file formats (SMILES, SDF, MOL2, PDB) into RDKit molecule objects for programmatic access, standardization, and format conversion.
- Python: `Chem.MolFromSmiles()`, `Chem.SDMolSupplier()` (RDKit)

Read, write, and convert molecular file formats with structure standardization.

## Supported Formats

| Format | Extension | Use Case |
|--------|-----------|----------|
| SMILES | .smi | Text representation, databases |
| SDF/MOL | .sdf, .mol | 3D structures, compound libraries |
| MOL2 | .mol2 | Docking, force field atoms |
| PDB | .pdb | Protein-ligand complexes |

## Reading Molecules

**Goal:** Load molecules from SMILES strings, SDF files, or SMILES files into RDKit molecule objects.

**Approach:** Use Chem.MolFromSmiles for individual SMILES, SDMolSupplier for multi-molecule SDF files, and file iteration for SMILES files, filtering out parse failures.

```python
from rdkit import Chem
from rdkit.Chem import AllChem

# From SMILES
mol = Chem.MolFromSmiles('CCO')

# From SDF file (single molecule)
mol = Chem.MolFromMolFile('molecule.mol')

# From SDF file (multiple molecules)
supplier = Chem.SDMolSupplier('library.sdf')
molecules = [mol for mol in supplier if mol is not None]
print(f'Loaded {len(molecules)} molecules')

# From SMILES file
with open('compounds.smi') as f:
    molecules = []
    for line in f:
        parts = line.strip().split()
        if parts:
            mol = Chem.MolFromSmiles(parts[0])
            if mol:
                mol.SetProp('_Name', parts[1] if len(parts) > 1 else '')
                molecules.append(mol)
```

## Writing Molecules

```python
from rdkit import Chem

# To SMILES
smiles = Chem.MolToSmiles(mol)  # Canonical SMILES
smiles_iso = Chem.MolToSmiles(mol, isomericSmiles=True)  # With stereochemistry

# To SDF file
writer = Chem.SDWriter('output.sdf')
for mol in molecules:
    writer.write(mol)
writer.close()

# To MOL block (string)
mol_block = Chem.MolToMolBlock(mol)
```

## Structure Standardization

**Goal:** Normalize molecular representations to a canonical form for consistent comparison and analysis.

**Approach:** Apply a multi-step pipeline: sanitize valences, normalize functional groups, neutralize charges, canonicalize tautomers, and strip salts using rdMolStandardize.

Use rdMolStandardize module (Python MolStandardize was removed Q1 2024).

```python
from rdkit import Chem
from rdkit.Chem.MolStandardize import rdMolStandardize

def standardize_molecule(mol):
    '''
    Full standardization pipeline.
    Order: Sanitize -> Normalize -> Neutralize -> Canonicalize tautomer -> Strip salts
    '''
    if mol is None:
        return None

    # Sanitize (assign valences, kekulize)
    try:
        Chem.SanitizeMol(mol)
    except Exception:
        return None

    # Normalize (standardize functional groups)
    normalizer = rdMolStandardize.Normalizer()
    mol = normalizer.normalize(mol)

    # Neutralize charges where possible
    uncharger = rdMolStandardize.Uncharger()
    mol = uncharger.uncharge(mol)

    # Canonicalize tautomers
    enumerator = rdMolStandardize.TautomerEnumerator()
    mol = enumerator.Canonicalize(mol)

    # Remove salts/fragments (keep largest)
    remover = rdMolStandardize.FragmentRemover()
    mol = remover.remove(mol)

    return mol

# Standardize a library
standardized = [standardize_molecule(m) for m in molecules]
standardized = [m for m in standardized if m is not None]
```

## Open Babel Conversion

For format conversions not supported by RDKit.

```python
# Open Babel 3.x import (not 'import pybel')
from openbabel import pybel

# Read MOL2 (better supported in Open Babel)
mols = list(pybel.readfile('mol2', 'ligands.mol2'))

# Convert to SDF
output = pybel.Outputfile('sdf', 'output.sdf', overwrite=True)
for mol in mols:
    output.write(mol)
output.close()

# Format conversion
for mol in pybel.readfile('pdb', 'complex.pdb'):
    mol.write('mol2', 'ligand.mol2', overwrite=True)
```

## Molecular Drawing

Use rdMolDraw2D (legacy Draw.MolToImage deprecated).

```python
from rdkit import Chem
from rdkit.Chem.Draw import rdMolDraw2D

def draw_molecule(mol, filename, size=(400, 300)):
    '''Draw molecule to PNG file.'''
    drawer = rdMolDraw2D.MolDraw2DCairo(size[0], size[1])
    drawer.DrawMolecule(mol)
    drawer.FinishDrawing()
    with open(filename, 'wb') as f:
        f.write(drawer.GetDrawingText())

# Draw with highlighting
def draw_with_substructure(mol, pattern, filename):
    '''Highlight substructure match.'''
    match = mol.GetSubstructMatch(Chem.MolFromSmarts(pattern))
    drawer = rdMolDraw2D.MolDraw2DCairo(400, 300)
    drawer.DrawMolecule(mol, highlightAtoms=match)
    drawer.FinishDrawing()
    with open(filename, 'wb') as f:
        f.write(drawer.GetDrawingText())
```

## Related Skills

- molecular-descriptors - Calculate properties after loading
- similarity-searching - Compare loaded molecules
- virtual-screening - Prepare ligands for docking
