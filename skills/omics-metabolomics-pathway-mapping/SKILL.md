---
name: omics-metabolomics-pathway-mapping
description: 提供将代谢物映射至KEGG/Reactome并做富集拓扑分析的方法与调用指南；用于处理HMDB/KEGG代谢物ID或名称及变化值。
metadata:
  source_extensions:
    tool_type: r
    primary_tool: MetaboAnalystR
---

## Version Compatibility

Reference examples tested with: ReactomePA 1.46+, clusterProfiler 4.10+

Before using code patterns, verify installed versions match. If versions differ:
- R: `packageVersion('<pkg>')` then `?function_name` to verify parameters

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Metabolomics Pathway Mapping

## Codex 调用

- **选择**：请求涉及“将代谢物映射至KEGG/Reactome并做富集拓扑分析”时使用；显式调用 `$omics-metabolomics-pathway-mapping`。
- **输入**：HMDB/KEGG代谢物ID或名称及变化值。
- **预期产物**：ORA/QEA/拓扑结果、通路图和FDR表；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **环境核对**：`MetaboAnalystR`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Map my metabolites to pathways"** → Perform pathway enrichment and topology analysis using KEGG, Reactome, or MetaboAnalyst to interpret metabolomics results in biochemical context.
- R: `MetaboAnalystR::SetMetabolomeFilter()` → `PerformDetailMatch()` → pathway topology

## KEGG Pathway Enrichment

```r
library(MetaboAnalystR)

# Initialize MetaboAnalyst
mSet <- InitDataObjects('conc', 'pathora', FALSE)

# Set organism
mSet <- SetOrganism(mSet, 'hsa')  # Human

# Load metabolite list (HMDB IDs or compound names)
metabolites <- c('HMDB0000001', 'HMDB0000005', 'HMDB0000010')  # Example HMDB IDs
# Or use names: c('Glucose', 'Lactate', 'Pyruvate')

mSet <- Setup.MapData(mSet, metabolites)
mSet <- CrossReferencing(mSet, 'hmdb')  # Or 'name', 'kegg', 'pubchem'

# Pathway analysis
mSet <- SetKEGG.PathLib(mSet, 'hsa', 'current')
mSet <- SetMetabolomeFilter(mSet, FALSE)
mSet <- CalculateOraScore(mSet, 'rbc', 'hyperg')  # Over-representation

# Get results
pathway_results <- mSet$analSet$ora.mat
print(pathway_results)
```

## Quantitative Enrichment Analysis (QEA)

```r
# For continuous data (fold changes or concentrations)
mSet <- InitDataObjects('conc', 'pathqea', FALSE)
mSet <- SetOrganism(mSet, 'hsa')

# Load data with values
metabolite_data <- data.frame(
    compound = c('Glucose', 'Lactate', 'Pyruvate'),
    fc = c(1.5, 2.3, 0.7)  # Fold changes
)

mSet <- Setup.MapData(mSet, metabolite_data)
mSet <- CrossReferencing(mSet, 'name')

# QEA analysis
mSet <- SetKEGG.PathLib(mSet, 'hsa', 'current')
mSet <- CalculateQeaScore(mSet, 'rbc', 'gt')

# Results
qea_results <- mSet$analSet$qea.mat
```

## Topology-Based Analysis

```r
# Considers pathway structure (betweenness, degree)
mSet <- InitDataObjects('conc', 'pathinteg', FALSE)
mSet <- SetOrganism(mSet, 'hsa')

mSet <- Setup.MapData(mSet, metabolites)
mSet <- CrossReferencing(mSet, 'hmdb')

# Topology analysis
mSet <- SetKEGG.PathLib(mSet, 'hsa', 'current')
mSet <- SetMetabolomeFilter(mSet, FALSE)
mSet <- CalculateHyperScore(mSet)  # Combined ORA + topology

topo_results <- mSet$analSet$topo.mat
```

## Reactome Pathways

```r
library(ReactomePA)
library(clusterProfiler)

# Convert to Reactome IDs (if available)
reactome_ids <- c('R-HSA-70171', 'R-HSA-1428517')  # Example

# Enrichment
enriched <- enrichPathway(gene = reactome_ids, organism = 'human', pvalueCutoff = 0.05)
print(enriched)
```

## KEGG Mapper (Direct API)

```r
library(KEGGREST)

# Get pathway information
pathway_info <- keggGet('hsa00010')  # Glycolysis

# Map compounds to pathways
kegg_ids <- c('C00031', 'C00186', 'C00022')  # Glucose, Lactate, Pyruvate

# Find pathways containing these compounds
find_pathways <- function(kegg_id) {
    pathways <- keggLink('pathway', kegg_id)
    return(pathways)
}

all_pathways <- lapply(kegg_ids, find_pathways)
```

## Pathway Visualization

```r
library(pathview)

# Visualize KEGG pathway with metabolite data
metabolite_data <- c('C00031' = 1.5, 'C00186' = 2.3, 'C00022' = 0.7)

pathview(cpd.data = metabolite_data,
         pathway.id = '00010',  # Glycolysis
         species = 'hsa',
         cpd.idtype = 'kegg',
         out.suffix = 'glycolysis_mapped')

# Output: hsa00010.glycolysis_mapped.png
```

## Network-Based Analysis

**Goal:** Visualize metabolite-pathway relationships as a bipartite network for identifying pathway crosstalk and hub metabolites.

**Approach:** Extract metabolite-pathway edges from enrichment results, build an igraph network, and annotate nodes by type for interactive visualization.

```r
library(igraph)

# Build metabolite-pathway network
build_network <- function(pathway_results) {
    edges <- data.frame()

    for (i in 1:nrow(pathway_results)) {
        pathway <- rownames(pathway_results)[i]
        metabolites <- strsplit(pathway_results$Metabolites[i], '; ')[[1]]

        for (met in metabolites) {
            edges <- rbind(edges, data.frame(from = met, to = pathway))
        }
    }

    g <- graph_from_data_frame(edges, directed = FALSE)

    # Add attributes
    V(g)$type <- ifelse(V(g)$name %in% edges$from, 'metabolite', 'pathway')

    return(g)
}

network <- build_network(pathway_results)
plot(network, vertex.size = ifelse(V(network)$type == 'pathway', 15, 5))
```

## Metabolite Set Enrichment

```r
# MSEA using predefined metabolite sets
mSet <- InitDataObjects('conc', 'msetora', FALSE)

# Use SMPDB (Small Molecule Pathway Database)
mSet <- SetMetaboliteFilter(mSet, FALSE)
mSet <- SetCurrentMsetLib(mSet, 'smpdb_pathway', 2)

mSet <- Setup.MapData(mSet, metabolites)
mSet <- CrossReferencing(mSet, 'hmdb')

mSet <- CalculateHyperScore(mSet)
msea_results <- mSet$analSet$ora.mat
```

## Combine with Gene Expression

```r
# Integrated pathway analysis (metabolites + genes)
library(IMPaLA)

# Prepare gene list
genes <- c('HK1', 'PFKM', 'ALDOA')  # Glycolysis enzymes

# Prepare metabolite list
metabolites <- c('HMDB0000122', 'HMDB0000190')  # Glucose, Lactate

# Joint pathway analysis
# (Use MetaboAnalyst joint pathway analysis or custom integration)
```

## Export Results

```r
# Format for publication
export_pathways <- function(results, output_file) {
    results_df <- as.data.frame(results)
    results_df$pathway <- rownames(results)

    # Select relevant columns
    results_df <- results_df[, c('pathway', 'Total', 'Expected', 'Hits',
                                   'Raw p', 'Holm adjust', 'FDR', 'Impact')]

    # Sort by FDR
    results_df <- results_df[order(results_df$FDR), ]

    write.csv(results_df, output_file, row.names = FALSE)
    return(results_df)
}

export_pathways(pathway_results, 'pathway_enrichment.csv')
```

## Related Skills

- metabolite-annotation - Identify metabolites first
- clinical-statistical-analysis - Get significant metabolites
- pathway-analysis/kegg-pathways - Similar enrichment concepts for genes
