# OpenClaw Medical Skills

<div align="center">

[![GitHub Stars](https://img.shields.io/github/stars/FreedomIntelligence/OpenClaw-Medical-Skills?style=for-the-badge&logo=github&color=gold)](https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/FreedomIntelligence/OpenClaw-Medical-Skills?style=for-the-badge&logo=github&color=blue)](https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills/network/members)
[![GitHub Issues](https://img.shields.io/github/issues/FreedomIntelligence/OpenClaw-Medical-Skills?style=for-the-badge&logo=github)](https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills/issues)
[![Skills Count](https://img.shields.io/badge/Skills-869-brightgreen?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZmlsbD0id2hpdGUiIGQ9Ik0xMiAyQzYuNDggMiAyIDYuNDggMiAxMnM0LjQ4IDEwIDEwIDEwIDEwLTQuNDggMTAtMTBTMTcuNTIgMiAxMiAyem0tMiAxNWwtNS01IDEuNDEtMS40MUwxMCAxNC4xN2w3LjU5LTcuNTlMMTkgOGwtOSA5eiIvPjwvc3ZnPg==)](https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills/tree/main/skills)
[![License](https://img.shields.io/badge/License-MIT-purple?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-OpenClaw%20%7C%20NanoClaw-orange?style=for-the-badge)](https://github.com/openclaw/openclaw)

**The largest open-source medical AI skill library for OpenClaw.**

*869 curated skills · Clinical · Genomics · Drug Discovery · Bioinformatics · Medical Devices*

[English](#) | [中文](README_zh.md)

</div>

---

## What Is This?

**OpenClaw Medical Skills** is a curated collection of **869 AI agent skills** covering the full spectrum of biomedical and clinical research. These skills are designed for [OpenClaw](https://github.com/openclaw/openclaw) / [NanoClaw](https://github.com/qwibitai/nanoclaw) — Claude-based personal AI assistant frameworks — and transform a general-purpose AI agent into a powerful medical and scientific research companion.

Each skill is a self-contained module (a `SKILL.md` file) that:
- Teaches the agent specialized domain knowledge and workflows
- Connects to real databases, APIs, and computational tools
- Produces structured, clinically or scientifically relevant outputs

> We benefit from the open-source community. The full collection of resources can be found here: [Awesome LLM Resources](https://github.com/WangRongsheng/awesome-LLM-resources?tab=readme-ov-file#%E6%8A%80%E8%83%BD-Skills)

### Why This Collection Matters

| Without Skills | With OpenClaw Medical Skills |
|---|---|
| Generic AI responses about medicine | Real PubMed / ClinicalTrials.gov / FDA queries |
| No bioinformatics capability | RNA-seq, scRNA-seq, GWAS, variant calling pipelines |
| No drug intelligence | ChEMBL, DrugBank, DDI prediction, pharmacovigilance |
| No clinical documentation | SOAP notes, discharge summaries, prior auth decisions |
| No genomics support | VCF annotation, ACMG classification, PRS calculation |
| No regulatory guidance | FDA, CE mark, IEC 62304, ISO 14971 compliance |

This collection aggregates skills from **12+ open-source skill repositories** spanning academic research tools, clinical workflows, regulatory frameworks, and cutting-edge AI-driven protein design — giving your AI agent capabilities comparable to a team of specialized research scientists.

---

## Installation

### Requirements

- [OpenClaw](https://github.com/openclaw/openclaw) installed and running, **or** [NanoClaw](https://github.com/qwibitai/nanoclaw) as an alternative
- Git (for cloning this repo)

---

### For OpenClaw Users

OpenClaw loads skills from two locations:

| Priority | Path | Scope |
|---|---|---|
| High | `<workspace>/skills/` | Per-workspace (recommended) |
| Low | `~/.openclaw/skills/` | Global, shared across all agents |

#### Method 1 — Clone and Copy (Recommended)

```bash
# Clone this repository (skills only — skips large data files)
git clone --depth=1 --no-checkout https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills.git
cd OpenClaw-Medical-Skills
git sparse-checkout init --cone
git sparse-checkout set skills
git checkout main

# Install to your workspace skills directory
cp -r skills/* <your-workspace>/skills/

# Or install globally (available to all agents)
cp -r skills/* ~/.openclaw/skills/
```

> **Note:** Some skills bundle large data files (databases, datasets). The
> sparse-checkout method above avoids downloading them. If you need the full
> repo including all data, install [Git LFS](https://git-lfs.com) first, then
> run `git clone https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills.git`.

Skills are picked up automatically on the next session. No restart needed.

#### Method 2 — OpenClaw CLI

If you use the [OpenClaw plugin registry](https://clawhub.com), you can search and install individual skills from there. For bulk install from this collection, Method 1 is faster.

```bash
openclaw plugins install <skill-slug>    # install a single skill
openclaw plugins update                  # update all installed skills
```

#### Method 3 — Configure Extra Directories

To point OpenClaw at a cloned copy of this repo permanently, add it to `~/.openclaw/openclaw.json`:

```json
{
  "plugins": {
    "local": ["/path/to/OpenClaw-Medical-Skills"]
  }
}
```

This mounts the entire collection without copying files.

#### Method 4 — Install Selected Skills Only

Pick skills relevant to your domain:

```bash
# Example: clinical + drug discovery stack
SKILLS=(
  "clinical-reports"
  "tooluniverse-drug-research"
  "tooluniverse-pharmacovigilance"
  "clinicaltrials-database"
  "biomedical-search"
  "tooluniverse-drug-drug-interaction"
)

for skill in "${SKILLS[@]}"; do
  cp -r OpenClaw-Medical-Skills/skills/$skill ~/.openclaw/skills/
done
```

---

### For NanoClaw Users

NanoClaw loads skills into agent containers at startup from `container/skills/`.

```bash
# Clone and copy into NanoClaw container skills directory
git clone https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills.git
cp -r OpenClaw-Medical-Skills/skills/* /path/to/nanoclaw/container/skills/

# Rebuild the container to apply
cd /path/to/nanoclaw
./container/build.sh
```

---

### Verification

After installation, ask your agent:

```
What medical and clinical skills do you have available?
```

Your agent should list the installed skills with their capabilities.

---

### For Codex CLI users

Clone the repository and start Codex from its root directory. Codex discovers the project skills through `.agents/skills/`; each entry points to its canonical folder under `skills/`.

```bash
git clone --branch codex/codex-native-skills https://github.com/kaider22/OpenClaw-Medical-Skills.git
cd OpenClaw-Medical-Skills
codex
```

In Codex, use `/skills` to browse available skills or invoke one by name, for example `$evidence-pubmed-api-search`. Discovery does not install external programs, databases, API credentials, or services required by individual skills. All 869 skills now have canonical names and task-specific Codex invocation instructions, including inputs, outputs, execution resources and missing prerequisites. Format and discovery checks do not establish functional validation of every research workflow.

See the [authoring standard](skill-authoring-standard.md), [complete name and invocation map](skill-migration.csv), and [migration verification report](codex-migration-report.md). The map retains previous names; source URLs retain upstream provenance.

---

## Skills Overview

| Category | Count | Highlights |
|---|---|---|
| General & Core | 10 | Browser/search, document tools, and developer workflow utilities |
| Medical & Clinical | 119 | Clinical reports, CDS, oncology, imaging, and healthcare AI |
| Scientific Databases | 43 | Genomics/protein/drug databases and biomedical knowledge retrieval |
| Bioinformatics (gptomics) | 239 | Variant analysis, sequencing QC, DE, pathways, single-cell, and epigenomics |
| Omics & Computational Biology | 59 | Single-cell/spatial, proteomics, cheminformatics, and protein design tools |
| ClawBio Pipelines | 21 | Orchestration pipelines for scRNA, GWAS, ancestry, and structural workflows |
| BioOS Extended Suite | 285 | Extended agent suite for oncology, immunology, clinical AI, and infrastructure |
| Data Science & Tools | 93 | Statistics, visualization, automation, simulation, and scientific tooling |
| **Total** | **869** | |

---

## Table of Contents

### General & Core
- [General Tools](#general-tools)

### Medical & Clinical
- [Medical Tools](#medical-tools)
- [Drug Safety & Chemical Biology](#drug-safety--chemical-biology)
- [Medical Imaging & Pathology](#medical-imaging--pathology)
- [Healthcare ML & Clinical AI](#healthcare-ml--clinical-ai)
- [Mental Health & Crisis Intervention](#mental-health--crisis-intervention)
- [Health & Wellness Analytics](#health--wellness-analytics)
- [Medical Device & Regulatory](#medical-device--regulatory)
- [Medical Device Software (meddev-agent-skills)](#medical-device--regulatory)

### Scientific Databases
- [Scientific Databases (Genomics & Variants)](#scientific-databases-genomics--variants)
- [Scientific Databases (Proteins, Pathways & Drugs)](#scientific-databases-proteins-pathways--drugs)
- [Cancer Genomics Databases](#cancer-genomics-databases)
- [Genomic & Molecular Databases](#genomic--molecular-databases)
- [Structural Biology & Drug Discovery](#structural-biology--drug-discovery)

### Bioinformatics (gptomics bio-* suite)
- [Bioinformatics Tools & Pipelines](#bioinformatics-tools--pipelines)
- [Bioinformatics — Clinical Databases & Variant Analysis](#bioinformatics--clinical-databases--variant-analysis)
- [Bioinformatics — Sequencing & Read QC](#bioinformatics--sequencing--read-qc)
- [Bioinformatics — Differential Expression & Transcriptomics](#bioinformatics--differential-expression--transcriptomics)
- [Bioinformatics — Pathway & Network Analysis](#bioinformatics--pathway--network-analysis)
- [Bioinformatics — Single-Cell & Spatial Omics](#bioinformatics--single-cell--spatial-omics)
- [Bioinformatics — Epigenomics & Chromatin](#bioinformatics--epigenomics--chromatin)
- [Bioinformatics — Metagenomics & Microbiome](#bioinformatics--metagenomics--microbiome)
- [Bioinformatics — Immunoinformatics & Flow Cytometry](#bioinformatics--immunoinformatics--flow-cytometry)
- [Bioinformatics — Multi-Omics Integration](#bioinformatics--multi-omics-integration)
- [Bioinformatics — Proteomics & Metabolomics](#bioinformatics--proteomics--metabolomics)
- [Bioinformatics — Structural Biology & Cheminformatics](#bioinformatics--structural-biology--cheminformatics)
- [Bioinformatics — Epidemiological & Causal Genomics](#bioinformatics--epidemiological--causal-genomics)

### Omics & Computational Biology
- [Single-Cell & Spatial Omics](#single-cell--spatial-omics)
- [Single-Cell & Trajectory Analysis](#single-cell--trajectory-analysis)
- [Proteomics & Mass Spectrometry](#proteomics--mass-spectrometry)
- [Cheminformatics & Drug Discovery](#cheminformatics--drug-discovery)
- [Protein Structure & Design](#protein-structure--design)
- [Phylogenetics & Network Analysis](#phylogenetics--network-analysis)

### ClawBio Pipelines
- [Bioinformatics Orchestration & Pipelines (ClawBio)](#bioinformatics-orchestration--pipelines-clawbio)
- [Genomics, Ancestry & Pharmacogenomics (ClawBio)](#genomics-ancestry--pharmacogenomics-clawbio)
- [Structural Biology & Literature (ClawBio)](#structural-biology--literature-clawbio)

### BioOS Extended Suite
- [BioOS Extended Bioinformatics Suite](#bioos-extended-bioinformatics-suite-mdbabumiamssmllms-universal-life-science-and-clinical-skills-)
- [Oncology & Precision Medicine Agents (BioOS)](#oncology--precision-medicine-agents-bioos)
- [Hematology & Blood Disorders (BioOS)](#hematology--blood-disorders-bioos)
- [Immunology & Cell Therapy (BioOS)](#immunology--cell-therapy-bioos)
- [Single-Cell & Spatial Agents (BioOS)](#single-cell--spatial-agents-bioos)
- [Drug Discovery & Design (BioOS)](#drug-discovery--design-bioos)
- [Clinical AI & Healthcare (BioOS)](#clinical-ai--healthcare-bioos)
- [Research Infrastructure & Agents (BioOS)](#research-infrastructure--agents-bioos)

### Data Science & Tools
- [Statistics & Data Analysis](#statistics--data-analysis)
- [Data Processing & Scientific Computing](#data-processing--scientific-computing)
- [Scientific Visualization & Communication](#scientific-visualization--communication)
- [Public Health & Time Series](#public-health--time-series)
- [Computational Simulation & Ontology](#computational-simulation--ontology-heshamfsmaterials-simulation-skills)
- [Analyst Personas](#analyst-personas)
- [Lab Automation & Integration](#lab-automation--integration)
- [Scientific Research & Writing](#scientific-research--writing)
- [Scientific Literature & Reference Management](#scientific-literature--reference-management)
- [Additional Scientific Tools](#additional-scientific-tools)
- [Developer Workflow Skills](#developer-workflow-skills-obrasuperpowers)

---

## Skills List

## 🧰 General & Core

<details open>
<summary>Expand/Collapse this category</summary>

### General Tools

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-browser-automation](skills/research-browser-automation/) | Browse the web for any task — research topics, read articles, interact with web apps, fill forms, take screenshots, extract data, and test web pages. Use whenever a browser would be useful. |
| [research-skill-discovery](skills/research-skill-discovery/) | Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending capabilities. |
| [evidence-multi-engine-web-search](skills/evidence-multi-engine-web-search/) | Multi search engine integration with 17 engines (8 CN + 9 Global). Supports Baidu, Bing, 360, Sogou, WeChat, Google, DuckDuckGo, WolframAlpha and more. Supports advanced operators, time filters, site search. No API keys required. |
| [evidence-wikipedia-search](skills/evidence-wikipedia-search/) | Search and fetch structured content from Wikipedia using the MediaWiki API for reliable, encyclopedic information. Supports multi-language queries. |
| [evidence-multisource-research](skills/evidence-multisource-research/) | Execute autonomous multi-step deep research on any topic. Searches multiple sources, reads full content, synthesizes findings, and produces a structured report. Use for comprehensive research, literature reviews, competitive analysis, or topic deep-dives. |
| [research-pdf-edit](skills/research-pdf-edit/) | Comprehensive PDF toolkit — extract text and tables, create new PDFs, merge/split documents, handle forms, OCR scanned PDFs. Use when working with any .pdf file. |
| [research-docx-edit](skills/research-docx-edit/) | Create, edit, and analyze Word documents (.docx). Supports tracked changes, comments, formatting preservation, and text extraction. Use for drafting, redlining, or extracting content from Word files. |
| [research-xlsx-analysis](skills/research-xlsx-analysis/) | Spreadsheet creation, editing, and analysis. Supports formulas, formatting, data analysis, and visualization. Use for any .xlsx, .xlsm, .csv, or .tsv task. |
| [research-pptx-edit](skills/research-pptx-edit/) | Presentation creation, editing, and analysis. Supports layouts, speaker notes, templates, and design. Use for any .pptx file. |
| [research-doc-coauthoring](skills/research-doc-coauthoring/) | Guide users through a structured workflow for co-authoring documentation. Use when writing documentation, proposals, technical specs, decision docs, or similar structured content. |

</details>

</details>

## 🏥 Medical & Clinical

<details open>
<summary>Expand/Collapse this category</summary>

### Medical Tools

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [evidence-pubmed-entrez-search](skills/evidence-pubmed-entrez-search/) | Search PubMed for scientific literature. Use when the user asks to find papers, search literature, look up research, find publications, or asks about recent studies. |
| [evidence-biomedical-database-query](skills/evidence-biomedical-database-query/) | Query 14+ biomedical databases for drug repurposing, target discovery, clinical trials, and literature research. Access ChEMBL, PubMed, ClinicalTrials.gov, OpenTargets, OpenFDA, OMIM, Reactome, KEGG, UniProt, and more through a unified MCP endpoint. |
| [evidence-medical-specialty-briefs](skills/evidence-medical-specialty-briefs/) | Generate daily or on-demand medical research briefs for any medical specialty. Searches latest research from top-tier journals (NEJM, Lancet, JAMA, BMJ, Nature Medicine), delivers concise summaries with 1-sentence takeaways and direct links. Use when user asks for medical news, research updates, or specialty-specific updates (endocrinology, cardiology, oncology, neurology, etc.). |
| [health-usmle-study-planning](skills/health-usmle-study-planning/) | Prepare for US medical licensing exams with progress tracking, weak area analysis, question bank management, and residency match planning. Covers Step 1/2 CK/Step 3, IMG-specific guidance, score prediction, and wellbeing support. |
| [clinical-message-entity-extraction](skills/clinical-message-entity-extraction/) | Extract medical entities (symptoms, medications, lab values, diagnoses) from patient messages. |
| [clinical-patient-document-explanation](skills/clinical-patient-document-explanation/) | Simplifies medical documents for patients. Takes doctor's letters, test results, prescriptions, discharge summaries, and clinical notes and explains them in clear, personalised language. |
| [evidence-biomedical-search](skills/evidence-biomedical-search/) | Complete biomedical information search combining PubMed, preprints, clinical trials, and FDA drug labels. Powered by Valyu semantic search. |
| [evidence-medical-imaging-review](skills/evidence-medical-imaging-review/) | Write comprehensive literature reviews for medical imaging AI research. Use when writing survey papers, systematic reviews, or literature analyses on imaging topics. |
| [research-fhir-resource-development](skills/research-fhir-resource-development/) | FHIR API development guide for building healthcare endpoints (Patient, Observation, Encounter, Condition, MedicationRequest). Use when developing or integrating FHIR REST APIs. |
| [clinical-trial-protocol-planning](skills/clinical-trial-protocol-planning/) | Generate clinical trial protocols for medical devices or drugs. Use when designing clinical studies, creating FDA submission documentation, or developing protocols for investigational products. |
| [clinical-prior-authorization-review](skills/clinical-prior-authorization-review/) | Automate payer review of prior authorization (PA) requests. Assesses medical necessity, validates against coverage policies, and generates PA decisions. |
| [research-clinical-reports](skills/research-clinical-reports/) | Write comprehensive clinical reports — case reports (CARE guidelines), diagnostic reports (radiology/pathology/lab), clinical trial reports (ICH-E3, CSR), and patient documentation (SOAP, H&P, discharge summaries). HIPAA/FDA/ICH-GCP compliant. |
| [evidence-clinicaltrials-api-search](skills/evidence-clinicaltrials-api-search/) | Query ClinicalTrials.gov via API v2. Search trials by condition, drug, location, status, or phase. Retrieve trial details by NCT ID, export data for clinical research and patient matching. |
| [clinical-decision-support](skills/clinical-decision-support/) | Generate clinical decision support (CDS) documents for pharmaceutical and clinical research — patient cohort analyses, treatment recommendation reports with GRADE evidence grading, biomarker integration, and statistical outputs (hazard ratios, survival curves). |
| [clinical-tooluniverse-clinical-trial-design](skills/clinical-tooluniverse-clinical-trial-design/) | Strategic clinical trial design feasibility assessment. Evaluates patient population sizing, biomarker prevalence, endpoint selection, comparator analysis, safety monitoring, and regulatory pathways. Use when planning Phase 1/2 trials or assessing trial feasibility. |
| [evidence-tooluniverse-disease-research](skills/evidence-tooluniverse-disease-research/) | Generate comprehensive disease research reports covering epidemiology, mechanisms, diagnostics, treatments, and ongoing trials. Use when asking about diseases, syndromes, or needing systematic disease analysis. |
| [evidence-tooluniverse-literature-deep-research](skills/evidence-tooluniverse-literature-deep-research/) | Deep literature research with target disambiguation, evidence grading, and structured theme extraction. Resolves gene/protein IDs, identifies synonyms, synthesizes biological models, and generates testable hypotheses. Use for thorough literature reviews or target profiles. |
| [evidence-tooluniverse-clinical-guidelines](skills/evidence-tooluniverse-clinical-guidelines/) | Search and retrieve clinical practice guidelines from 12+ sources (NICE, WHO, ADA, AHA/ACC, NCCN, SIGN, CPIC, etc.). Covers cardiology, oncology, diabetes, pharmacogenomics, and more. Use when asking about treatment recommendations or standard of care. |
| [drug-tooluniverse-drug-research](skills/drug-tooluniverse-drug-research/) | Comprehensive drug research reports covering identity, pharmacology, targets, clinical trials, safety, pharmacogenomics, and ADMET. Use for drug profiling, safety assessment, or clinical development research. |
| [drug-tooluniverse-drug-repurposing](skills/drug-tooluniverse-drug-repurposing/) | Identify drug repurposing candidates using target-based, compound-based, and disease-driven strategies. Finds new indications for approved drugs by analyzing targets, bioactivity, and safety profiles. |
| [drug-tooluniverse-drug-drug-interaction](skills/drug-tooluniverse-drug-drug-interaction/) | Drug-drug interaction prediction and risk assessment. Analyzes CYP450/transporter mechanisms, severity classification, and provides management strategies. Supports polypharmacy analysis (3+ drugs) and alternative drug recommendations. |
| [health-tooluniverse-rare-disease-diagnosis](skills/health-tooluniverse-rare-disease-diagnosis/) | Differential diagnosis for rare diseases based on phenotype and genetic data. Matches symptoms to HPO terms, identifies candidate diseases from Orphanet/OMIM, and interprets variants of uncertain significance. |
| [drug-tooluniverse-pharmacovigilance](skills/drug-tooluniverse-pharmacovigilance/) | Analyze drug safety signals from FDA adverse event reports, label warnings, and pharmacogenomic data. Calculates PRR/ROR, identifies serious adverse events, and assesses pharmacogenomic risk. |
| [clinical-tooluniverse-clinical-trial-matching](skills/clinical-tooluniverse-clinical-trial-matching/) | Patient-to-trial matching for precision medicine and oncology. Ranks trials from ClinicalTrials.gov by molecular eligibility, clinical criteria, biomarker alignment, and geographic feasibility with a quantitative Trial Match Score (0-100). |
| [evidence-literature-review](skills/evidence-literature-review/) | Systematic literature reviews across multiple databases (PubMed, arXiv, bioRxiv, Semantic Scholar). Produces professionally formatted reports with verified citations in APA, Nature, Vancouver styles. |
| [clinical-tooluniverse-precision-oncology](skills/clinical-tooluniverse-precision-oncology/) | Actionable treatment recommendations for cancer patients based on molecular profile. Interprets tumor mutations, identifies FDA-approved therapies, clinical trials, and resistance mechanisms. |
| [clinical-tooluniverse-cancer-variant-interpretation](skills/clinical-tooluniverse-cancer-variant-interpretation/) | Clinical interpretation of somatic mutations in cancer. Given gene+variant (e.g., EGFR L858R, BRAF V600E), assesses oncogenicity, therapeutic implications, and trial eligibility. |
| [omics-tooluniverse-variant-analysis](skills/omics-tooluniverse-variant-analysis/) | Production-ready VCF processing, variant annotation, and mutation analysis. Parses VCF files, annotates with ClinVar/gnomAD/COSMIC, and interprets clinical significance. |
| [omics-tooluniverse-variant-interpretation](skills/omics-tooluniverse-variant-interpretation/) | Systematic clinical variant interpretation from raw calls to ACMG-classified recommendations. Aggregates evidence from ClinVar, gnomAD, literature, and population databases. |
| [omics-tooluniverse-structural-variant-analysis](skills/omics-tooluniverse-structural-variant-analysis/) | Comprehensive structural variant (SV/CNV) analysis for clinical genomics. Classifies SVs, assesses pathogenicity, and interprets copy number alterations. |
| [omics-tooluniverse-polygenic-risk-score](skills/omics-tooluniverse-polygenic-risk-score/) | Build and interpret polygenic risk scores (PRS) for complex diseases using GWAS summary statistics. Calculates genetic risk profiles and interprets PRS percentiles. |
| [clinical-tooluniverse-precision-medicine-stratification](skills/clinical-tooluniverse-precision-medicine-stratification/) | Patient stratification for precision medicine by integrating genomic, clinical, and therapeutic data. Identifies treatment-relevant subgroups and biomarker-driven therapy options. |
| [omics-tooluniverse-gwas-trait-to-gene](skills/omics-tooluniverse-gwas-trait-to-gene/) | Discover genes associated with diseases and traits using GWAS Catalog (500k+ associations) and Open Targets Genetics locus-to-gene predictions. |
| [drug-tooluniverse-gwas-drug-discovery](skills/drug-tooluniverse-gwas-drug-discovery/) | Transform GWAS signals into drug targets and repurposing opportunities. Performs locus-to-gene mapping, druggability assessment, and existing drug identification. |
| [omics-tooluniverse-gwas-study-explorer](skills/omics-tooluniverse-gwas-study-explorer/) | Compare GWAS studies and assess replication across cohorts. Integrates NHGRI-EBI GWAS Catalog and Open Targets Genetics for cross-study meta-analysis. |
| [omics-tooluniverse-gwas-finemapping](skills/omics-tooluniverse-gwas-finemapping/) | Identify and prioritize causal variants at GWAS loci using statistical fine-mapping. Computes posterior probabilities and credible sets for causal variant identification. |
| [omics-tooluniverse-gwas-snp-interpretation](skills/omics-tooluniverse-gwas-snp-interpretation/) | Interpret SNPs from GWAS studies by aggregating evidence from GWAS Catalog, Open Targets Genetics, and ClinVar. Retrieves variant-trait associations and functional annotations. |
| [omics-tooluniverse-phylogenetics](skills/omics-tooluniverse-phylogenetics/) | Phylogenetics and sequence analysis — alignment processing, evolutionary tree construction, and evolutionary metrics for pathogens or species. |
| [omics-tooluniverse-epigenomics](skills/omics-tooluniverse-epigenomics/) | Epigenomics data processing — methylation array analysis (CpG filtering, differential methylation), chromatin accessibility, and histone modification analysis. |
| [omics-tooluniverse-rnaseq-deseq2](skills/omics-tooluniverse-rnaseq-deseq2/) | RNA-seq differential expression analysis using PyDESeq2. Performs normalization, dispersion estimation, Wald testing, LFC shrinkage, and pathway enrichment. |
| [omics-tooluniverse-single-cell](skills/omics-tooluniverse-single-cell/) | Single-cell RNA-seq analysis using scanpy. Performs QC, normalization, PCA, UMAP, Leiden clustering, trajectory analysis, and cell type annotation. |
| [omics-tooluniverse-spatial-transcriptomics](skills/omics-tooluniverse-spatial-transcriptomics/) | Spatial transcriptomics data analysis — maps gene expression in tissue architecture. Supports 10x Visium, MERFISH, seqFISH, and Slide-seq platforms. |
| [omics-tooluniverse-spatial-omics-analysis](skills/omics-tooluniverse-spatial-omics-analysis/) | Computational analysis for spatial multi-omics data integration — spatially variable genes, domain annotation, and tissue-resolved omics. |
| [omics-tooluniverse-proteomics-analysis](skills/omics-tooluniverse-proteomics-analysis/) | Mass spectrometry proteomics analysis — protein quantification, differential expression, PTMs, and protein-protein interaction network construction. |
| [omics-tooluniverse-metabolomics](skills/omics-tooluniverse-metabolomics/) | Metabolomics research — identifies metabolites and searches databases (HMDB 220k+ metabolites, MetaboLights, Metabolomics Workbench). |
| [omics-tooluniverse-metabolomics-analysis](skills/omics-tooluniverse-metabolomics-analysis/) | Metabolomics data analysis — metabolite identification, quantification, pathway analysis, and metabolic flux from LC-MS, GC-MS, or NMR data. |
| [omics-tooluniverse-multi-omics-integration](skills/omics-tooluniverse-multi-omics-integration/) | Integrate transcriptomics, proteomics, epigenomics, genomics, and metabolomics for systems biology and precision medicine. |
| [omics-tooluniverse-multiomic-disease-characterization](skills/omics-tooluniverse-multiomic-disease-characterization/) | Systems-level disease characterization integrating genomics, transcriptomics, proteomics, pathway, and therapeutic layers. |
| [omics-tooluniverse-expression-data-retrieval](skills/omics-tooluniverse-expression-data-retrieval/) | Retrieve gene expression and omics datasets from ArrayExpress and BioStudies with quality assessment and structured reports. |
| [omics-tooluniverse-gene-enrichment](skills/omics-tooluniverse-gene-enrichment/) | Gene enrichment and pathway analysis using gseapy, PANTHER, STRING, Reactome. Supports GO enrichment, KEGG pathways, and 40+ ToolUniverse tools. |
| [omics-tooluniverse-systems-biology](skills/omics-tooluniverse-systems-biology/) | Systems biology and pathway analysis using Reactome, KEGG, WikiPathways, Pathway Commons, and BioModels. Network modeling and pathway simulation. |
| [omics-tooluniverse-protein-interactions](skills/omics-tooluniverse-protein-interactions/) | Protein-protein interaction network analysis using STRING, BioGRID, and SASBDB. Maps interaction networks with confidence scores and functional modules. |
| [omics-tooluniverse-protein-structure-retrieval](skills/omics-tooluniverse-protein-structure-retrieval/) | Retrieve protein structure data from RCSB PDB, PDBe, and AlphaFold with quality assessment and comprehensive structural profiles. |
| [omics-tooluniverse-protein-therapeutic-design](skills/omics-tooluniverse-protein-therapeutic-design/) | Design novel protein therapeutics (binders, enzymes, scaffolds) using AI-guided de novo design — RFdiffusion, ProteinMPNN, and ESM. |
| [omics-tooluniverse-antibody-engineering](skills/omics-tooluniverse-antibody-engineering/) | Antibody engineering and optimization for therapeutics — humanization, affinity maturation, developability assessment, and immunogenicity prediction. |
| [omics-tooluniverse-immune-repertoire-analysis](skills/omics-tooluniverse-immune-repertoire-analysis/) | TCR/BCR repertoire analysis from sequencing data — clonality, diversity, V(D)J gene usage, clonal expansion, and antigen specificity prediction. |
| [clinical-tooluniverse-immunotherapy-response-prediction](skills/clinical-tooluniverse-immunotherapy-response-prediction/) | Predict patient response to immune checkpoint inhibitors using multi-biomarker integration — TMB, MSI, PD-L1, TIL signatures, and HLA typing. |
| [omics-tooluniverse-infectious-disease](skills/omics-tooluniverse-infectious-disease/) | Pathogen characterization and drug repurposing for infectious disease outbreaks. Identifies taxonomy, essential proteins, structural targets, and treatment options. |
| [omics-tooluniverse-crispr-screen-analysis](skills/omics-tooluniverse-crispr-screen-analysis/) | CRISPR screen analysis for functional genomics — pooled or arrayed screens (knockout/activation/interference) to identify essential genes and hits. |
| [drug-tooluniverse-target-research](skills/drug-tooluniverse-target-research/) | Comprehensive biological target intelligence — protein info, structure, interactions, pathways, expression, variant landscape, and drug pipeline. |
| [drug-tooluniverse-network-pharmacology](skills/drug-tooluniverse-network-pharmacology/) | Compound-target-disease network analysis for drug repurposing, polypharmacology discovery, and systems pharmacology. |
| [clinical-tooluniverse-statistical-modeling](skills/clinical-tooluniverse-statistical-modeling/) | Statistical modeling on biomedical datasets — linear/logistic regression, mixed-effects models, survival analysis, and Bayesian methods. |
| [imaging-tooluniverse-image-analysis](skills/imaging-tooluniverse-image-analysis/) | Biomedical microscopy image analysis — colony morphometry, cell counting, fluorescence quantification, and statistical comparison of imaging data. |
| [evidence-literature-search](skills/evidence-literature-search/) | Comprehensive scientific literature search across PubMed, arXiv, bioRxiv, medRxiv using natural language queries powered by Valyu semantic search. |
| [evidence-medrxiv-search](skills/evidence-medrxiv-search/) | Search medRxiv medical preprints with natural language queries powered by Valyu semantic search. |
| [evidence-clinicaltrials-semantic-search](skills/evidence-clinicaltrials-semantic-search/) | Search ClinicalTrials.gov with natural language queries — find trials by condition, enrollment status, and outcomes via Valyu. |
| [drug-discovery-search](skills/drug-discovery-search/) | End-to-end drug discovery platform combining ChEMBL, DrugBank, targets, and FDA labels via natural language Valyu search. |
| [drug-labels-search](skills/drug-labels-search/) | Search FDA drug labels with natural language queries — indications, dosing, and safety data via Valyu. |
| [drug-chembl-search](skills/drug-chembl-search/) | Search ChEMBL bioactive molecules database — compounds, assay data, and bioactivity via Valyu semantic search. |
| [drug-open-targets-search](skills/drug-open-targets-search/) | Search Open Targets drug-disease associations and target validation via Valyu semantic search. |
| [evidence-patents-search](skills/evidence-patents-search/) | Search global patents with natural language queries — prior art, patent landscapes, and innovation tracking via Valyu. |
| [drug-drugbank-search](skills/drug-drugbank-search/) | Search DrugBank comprehensive drug database — mechanisms, interactions, and safety data via Valyu semantic search. |
| [evidence-arxiv-search](skills/evidence-arxiv-search/) | Search arXiv preprints (biology, medicine, AI) using natural language queries powered by Valyu semantic search. |
| [omics-gwas-query](skills/omics-gwas-query/) | Query NHGRI-EBI GWAS Catalog for SNP-trait associations by rs ID, disease/trait, or gene. Retrieve p-values and summary statistics for genetic epidemiology. |
| [clinical-scikit-survival-modeling](skills/clinical-scikit-survival-modeling/) | Survival analysis and time-to-event modeling in Python — Kaplan-Meier, Cox regression, log-rank tests, and censored data handling using scikit-survival. |

</details>

### Drug Safety & Chemical Biology

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [drug-tooluniverse-adverse-event-detection](skills/drug-tooluniverse-adverse-event-detection/) | Detect and analyze adverse drug event signals using FDA FAERS data, drug labels, disproportionality analysis (PRR, ROR, IC), and biomedical evidence. Generates quantitative safety signal scores (0-100). |
| [drug-tooluniverse-binder-discovery](skills/drug-tooluniverse-binder-discovery/) | Discover novel small molecule binders for protein targets using structure-based and ligand-based approaches. Creates actionable reports with candidate compounds, ADMET profiles, and synthesis feasibility. |
| [drug-tooluniverse-chemical-compound-retrieval](skills/drug-tooluniverse-chemical-compound-retrieval/) | Retrieves chemical compound information from PubChem and ChEMBL with disambiguation, cross-referencing, and quality assessment. Comprehensive compound profiles with identifiers, properties, bioactivity. |
| [drug-tooluniverse-chemical-safety](skills/drug-tooluniverse-chemical-safety/) | Comprehensive chemical safety and toxicology assessment integrating ADMET-AI predictions, CTD toxicogenomics, FDA label safety data, DrugBank safety profiles, and STITCH chemical-protein interactions. |
| [drug-tooluniverse-drug-target-validation](skills/drug-tooluniverse-drug-target-validation/) | Computational validation of drug targets across 10 dimensions: disambiguation, disease association, druggability, chemical matter, clinical precedent, safety, and expression evidence. |
| [omics-tooluniverse-sequence-retrieval](skills/omics-tooluniverse-sequence-retrieval/) | Retrieve biological sequences (DNA, RNA, protein) from NCBI and ENA with gene disambiguation, accession type handling, and comprehensive sequence profiles. |

</details>

### Medical Imaging & Pathology

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [imaging-pydicom-data-processing](skills/imaging-pydicom-data-processing/) | Python library for working with DICOM medical imaging files. Reading, writing, modifying DICOM data, extracting pixel data, handling metadata and multi-frame files. |
| [imaging-histolab-slide-preprocessing](skills/imaging-histolab-slide-preprocessing/) | Digital pathology image processing toolkit for whole slide images (WSI). Process H&E or IHC stained tissue images, extract tiles from gigapixel slides. |
| [imaging-pathml](skills/imaging-pathml/) | Computational pathology toolkit for analyzing WSI and multiparametric imaging data. H&E stained images, multiplex immunofluorescence, spatial omics integration. |
| [imaging-omero-integration](skills/imaging-omero-integration/) | Microscopy data management platform. Access images via Python, retrieve datasets, analyze pixels, manage ROIs/annotations, for high-content screening workflows. |
| [research-neurokit-physiological-signal-analysis](skills/research-neurokit-physiological-signal-analysis/) | Comprehensive biosignal processing: ECG, EEG, EDA, RSP, PPG, EMG, EOG signals. Cardiovascular signal analysis, neurophysiology, and physiological data processing. |
| [research-neuropixels-signal-analysis](skills/research-neuropixels-signal-analysis/) | Neuropixels neural recording analysis. Load SpikeGLX/OpenEphys data, Kilosort4 spike sorting, quality metrics, Allen/IBL curation, for neuroscience research. |

</details>

### Healthcare ML & Clinical AI

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [clinical-pyhealth-model-training](skills/clinical-pyhealth-model-training/) | Comprehensive healthcare AI toolkit for developing ML models with clinical data (EHR, claims). Task definition API, model training, evaluation for clinical NLP and prediction. |
| [research-sklearn-model-training](skills/research-sklearn-model-training/) | Machine learning in Python: supervised learning (classification, regression), unsupervised learning (clustering, dimensionality reduction), model evaluation, hyperparameter tuning. |
| [research-transformers-model-use](skills/research-transformers-model-use/) | Pre-trained transformer models for NLP, computer vision, audio, and multimodal tasks. Text generation, classification, question answering, and biomedical NLP (BioBERT, ClinicalBERT). |
| [research-shap-model-explanation](skills/research-shap-model-explanation/) | Model interpretability using SHAP (SHapley Additive exPlanations). Explain ML model predictions, compute feature importance, generate SHAP plots for biomedical models. |
| [research-umap-dimensionality-reduction](skills/research-umap-dimensionality-reduction/) | UMAP dimensionality reduction. Fast nonlinear manifold learning for 2D/3D visualization, clustering preprocessing (HDBSCAN), for high-dimensional omics data. |

</details>

### Health & Wellness Analytics

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [health-nutrition-analyzer](skills/health-nutrition-analyzer/) | Comprehensive nutrition analysis: macro/micronutrient tracking, dietary assessment, meal planning, food data lookup, and nutritional recommendations. |
| [health-mental-health-analyzer](skills/health-mental-health-analyzer/) | Mental health data analysis: mood tracking, symptom patterns, PHQ/GAD scoring, behavioral insights, and wellness recommendations. |
| [health-sleep-analyzer](skills/health-sleep-analyzer/) | Sleep quality analysis: sleep stages, duration, efficiency metrics, circadian rhythm assessment, and sleep hygiene recommendations. |
| [health-rehabilitation-analyzer](skills/health-rehabilitation-analyzer/) | Rehabilitation progress tracking: functional assessments, exercise programs, recovery milestones, and outcome measurement for physical/occupational therapy. |
| [health-fitness-analyzer](skills/health-fitness-analyzer/) | Fitness performance analysis: exercise tracking, strength/cardio metrics, training load, VO2max estimation, and periodization planning. |
| [health-trend-analyzer](skills/health-trend-analyzer/) | Longitudinal health trend analysis: vital sign tracking, biomarker trends, risk factor monitoring, and predictive health insights. |
| [health-weightloss-analyzer](skills/health-weightloss-analyzer/) | Weight management analytics: caloric balance, body composition tracking, progress monitoring, and evidence-based weight loss strategies. |
| [health-goal-analyzer](skills/health-goal-analyzer/) | Health goal tracking and analysis: SMART goal setting, progress metrics, habit formation, and motivational insights for wellness objectives. |
| [health-occupational-health-analyzer](skills/health-occupational-health-analyzer/) | Occupational health assessment: workplace ergonomics, exposure risk, work-related illness surveillance, and return-to-work planning. |
| [health-travel-health-analyzer](skills/health-travel-health-analyzer/) | Travel medicine: destination health risks, vaccination requirements, malaria prophylaxis, altitude sickness, and traveler health preparation. |
| [health-family-health-analyzer](skills/health-family-health-analyzer/) | Family health management: pediatric milestones, family medical history, preventive screening schedules, and multigenerational health tracking. |
| [health-tcm-constitution-analyzer](skills/health-tcm-constitution-analyzer/) | Traditional Chinese Medicine constitution analysis: TCM body type assessment, pattern differentiation, herbal recommendations, and lifestyle guidance. |
| [health-emergency-card](skills/health-emergency-card/) | Generate emergency medical information cards with critical health data, medications, allergies, and emergency contacts for patient safety. |
| [health-records-analysis](skills/health-records-analysis/) | AI-powered comprehensive health data interpretation combining multiple biomarkers and health metrics for holistic wellness assessment. |
| [health-wellally-tech](skills/health-wellally-tech/) | Technical framework for WellAlly health analytics platform: integration patterns, data pipelines, and health AI infrastructure. |

</details>

### Mental Health & Crisis Intervention

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [health-crisis-detection-intervention-ai](skills/health-crisis-detection-intervention-ai/) | Detect crisis signals using NLP and mental health sentiment analysis. Implements suicide ideation detection, automated escalation, and crisis resource integration for mental health apps and recovery platforms. |
| [health-crisis-response-protocol](skills/health-crisis-response-protocol/) | Handle mental health crisis situations safely: crisis detection, safety protocols, emergency escalation, suicide prevention, and hotline integration for AI coaching applications. |
| [research-hipaa-compliance](skills/research-hipaa-compliance/) | Ensure HIPAA compliance when handling PHI. Audit logging, data access controls, security event tracking, and compliance verification for health data applications. |
| [clinical-diagnostic-reasoning](skills/clinical-diagnostic-reasoning/) | Identify and counteract cognitive biases in medical decision-making through systematic error analysis, differential diagnosis frameworks, and clinical judgment improvement. |
| [health-speech-pathology-guidance](skills/health-speech-pathology-guidance/) | AI-powered speech-language pathology: phoneme analysis, articulation visualization, voice disorder assessment, fluency intervention, AAC, and stuttering treatment support. |
| [health-hrv-alexithymia-expert](skills/health-hrv-alexithymia-expert/) | Heart rate variability biometrics and emotional awareness training. HRV analysis, interoception training, biofeedback, vagal tone assessment, and autonomic nervous system evaluation. |
| [health-adhd-daily-planner](skills/health-adhd-daily-planner/) | ADHD-optimized daily planning: time-blind friendly scheduling, executive function support, dopamine-aware task design, and neurodivergent-friendly productivity systems. |
| [health-grief-companion](skills/health-grief-companion/) | Compassionate bereavement support, memorial creation, grief education, and healing journey guidance through the non-linear path of loss. |
| [health-jungian-psychologist](skills/health-jungian-psychologist/) | Jungian analytical psychology: shadow work, archetypal analysis, dream interpretation, active imagination, addiction/recovery through depth psychology lens, and individuation process. |
| [health-modern-drug-rehab-computer](skills/health-modern-drug-rehab-computer/) | Comprehensive addiction recovery knowledge system: evidence-based treatment (CBT, DBT, MI, EMDR, MAT), recovery resources, crisis intervention, and family systems for rehab environments. |
| [health-recovery-community-moderator](skills/health-recovery-community-moderator/) | Trauma-informed AI moderation for addiction recovery communities: harm reduction, 12-step traditions, conflict detection, and crisis post identification. |

</details>

### Medical Device & Regulatory

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-iso-13485-certification](skills/research-iso-13485-certification/) | Comprehensive toolkit for ISO 13485 QMS documentation for medical devices: gap analysis, Quality Manuals, procedures, Medical Device Files. Covers FDA QMSR, EU MDR compliance. |

</details>

</details>

## 🗂️ Scientific Databases

<details open>
<summary>Expand/Collapse this category</summary>

### Scientific Databases (Genomics & Variants)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-clinvar-query](skills/omics-clinvar-query/) | Query NCBI ClinVar for variant clinical significance. Search by gene/position, interpret pathogenicity classifications, access via E-utilities API or FTP, annotate VCFs, for genomic medicine. |
| [omics-clinpgx-database-query](skills/omics-clinpgx-database-query/) | Access ClinPGx pharmacogenomics data (successor to PharmGKB). Query gene-drug interactions, CPIC guidelines, allele functions, for precision medicine and genotype-guided dosing decisions. |
| [clinical-cosmic-query](skills/clinical-cosmic-query/) | Access COSMIC cancer mutation database. Query somatic mutations, Cancer Gene Census, mutational signatures, gene fusions, for cancer research and precision oncology. Requires authentication. |
| [omics-ensembl-annotation-query](skills/omics-ensembl-annotation-query/) | Query Ensembl genome database REST API for 250+ species. Gene lookups, sequence retrieval, variant analysis, comparative genomics, orthologs, VEP predictions, for genomic research. |
| [omics-gene-query](skills/omics-gene-query/) | Query NCBI Gene via E-utilities/Datasets API. Search by symbol/ID, retrieve gene info (RefSeqs, GO, locations, phenotypes), batch lookups, for gene annotation and functional analysis. |
| [omics-geo-query](skills/omics-geo-query/) | Access NCBI GEO for gene expression/genomics data. Search/download microarray and RNA-seq datasets (GSE, GSM, GPL), retrieve SOFT/Matrix files, for transcriptomics and expression analysis. |
| [omics-ena-sequence-query](skills/omics-ena-sequence-query/) | Access European Nucleotide Archive via API/FTP. Retrieve DNA/RNA sequences, raw reads (FASTQ), genome assemblies by accession, for genomics and bioinformatics pipelines. |
| [omics-gget-database-query](skills/omics-gget-database-query/) | CLI/Python toolkit for rapid bioinformatics queries with access to 20+ databases: Ensembl, UniProt, AlphaFold, ARCHS4, Enrichr, OpenTargets, COSMIC, BLAST, and more. |
| [omics-pysam-sequence-file-processing](skills/omics-pysam-sequence-file-processing/) | Genomic file toolkit. Read/write SAM/BAM/CRAM alignments, VCF/BCF variants, FASTA/FASTQ sequences, extract regions, calculate coverage, for NGS data processing pipelines. |

</details>

### Scientific Databases (Proteins, Pathways & Drugs)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-alphafold-structure-retrieval](skills/omics-alphafold-structure-retrieval/) | Access AlphaFold's 200M+ AI-predicted protein structures. Retrieve structures by UniProt ID, download PDB/mmCIF files, analyze confidence metrics (pLDDT, PAE), for drug discovery and structural biology. |
| [omics-rcsb-structure-query](skills/omics-rcsb-structure-query/) | Access RCSB PDB for 3D protein/nucleic acid structures. Search by text/sequence/structure, download coordinates (PDB/mmCIF), retrieve metadata, for structural biology and drug discovery. |
| [omics-uniprot-query](skills/omics-uniprot-query/) | Direct REST API access to UniProt. Protein searches, FASTA retrieval, ID mapping, Swiss-Prot/TrEMBL. For multi-database workflows, prefer bioservices (unified interface to 40+ services). |
| [omics-string-query](skills/omics-string-query/) | Query STRING API for protein-protein interactions (59M proteins, 20B interactions). Network analysis, GO/KEGG enrichment, interaction discovery, 5000+ species, for systems biology. |
| [omics-kegg-pathway-query](skills/omics-kegg-pathway-query/) | Direct REST API access to KEGG (academic use). Pathway analysis, gene-pathway mapping, metabolic pathways, drug interactions, ID conversion. |
| [omics-reactome-query](skills/omics-reactome-query/) | Query Reactome REST API for pathway analysis, enrichment, gene-pathway mapping, disease pathways, molecular interactions, expression analysis, for systems biology. |
| [omics-brenda-enzyme-query](skills/omics-brenda-enzyme-query/) | Access BRENDA enzyme database via SOAP API. Retrieve kinetic parameters (Km, kcat), reaction equations, organism data, substrate-specific enzyme info for biochemical research. |
| [omics-hmdb-metabolite-query](skills/omics-hmdb-metabolite-query/) | Access Human Metabolome Database (220K+ metabolites). Search by name/ID/structure, retrieve chemical properties, biomarker data, NMR/MS spectra, pathways, for metabolomics. |
| [omics-metabolomics-workbench-query](skills/omics-metabolomics-workbench-query/) | Access NIH Metabolomics Workbench via REST API (4,200+ studies). Query metabolites, RefMet nomenclature, MS/NMR data, m/z searches, for metabolomics and biomarker discovery. |
| [drug-pubchem-query](skills/drug-pubchem-query/) | Query PubChem via PUG-REST API (110M+ compounds). Search by name/CID/SMILES, retrieve properties, similarity/substructure searches, bioactivity, for cheminformatics. |
| [drug-chembl-query](skills/drug-chembl-query/) | Query ChEMBL's bioactive molecules and drug discovery data. Search compounds by structure/properties, retrieve bioactivity data (IC50, Ki), find inhibitors, for medicinal chemistry. |
| [drug-drugbank-query](skills/drug-drugbank-query/) | Access comprehensive drug information from DrugBank including drug properties, interactions, targets, pathways, chemical structures, and pharmacology data. |
| [drug-zinc-query](skills/drug-zinc-query/) | Access ZINC (230M+ purchasable compounds). Search by ZINC ID/SMILES, similarity searches, 3D-ready structures for docking, analog discovery, for virtual screening. |
| [drug-opentargets-query](skills/drug-opentargets-query/) | Query Open Targets Platform for target-disease associations, drug target discovery, tractability/safety data, genetics/omics evidence, known drugs, for therapeutic target identification. |
| [clinical-fda-query](skills/clinical-fda-query/) | Query openFDA API for drugs, devices, adverse events, recalls, regulatory submissions (510k, PMA), substance identification (UNII), for FDA regulatory data analysis. |
| [evidence-pubmed-api-search](skills/evidence-pubmed-api-search/) | Direct REST API access to PubMed. Advanced Boolean/MeSH queries, E-utilities API, batch processing, citation management. |
| [evidence-openalex-query](skills/evidence-openalex-query/) | Query and analyze scholarly literature using the OpenAlex database. Search for academic papers, analyze research trends, find works by authors or institutions. |
| [evidence-biorxiv-query](skills/evidence-biorxiv-query/) | Search bioRxiv preprint server by keywords, authors, date ranges, or categories, retrieving paper metadata for life sciences preprint discovery. |
| [omics-bioservices-database-query](skills/omics-bioservices-database-query/) | Primary Python tool for 40+ bioinformatics services. Unified API for UniProt, KEGG, ChEMBL, PubChem, Reactome, QuickGO — preferred for multi-database workflows. |
| [evidence-uspto-patent-query](skills/evidence-uspto-patent-query/) | Access USPTO APIs for patent/trademark searches, examination history (PEDS), assignments, citations, office actions, for IP analysis and prior art searches. |

</details>

### Cancer Genomics Databases

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [clinical-cbioportal-query](skills/clinical-cbioportal-query/) | Query cBioPortal for cancer genomics: somatic mutations, copy number, gene expression, and survival data across hundreds of cancer studies. Cancer target validation, oncogene analysis, and patient-level genomic profiling. |
| [drug-depmap-dependency-query](skills/drug-depmap-dependency-query/) | Query the Cancer Dependency Map (DepMap) for cancer cell line gene dependency scores (CRISPR Chronos), drug sensitivity, and gene effect profiles. Identify cancer-specific vulnerabilities and synthetic lethal interactions. |
| [imaging-data-commons](skills/imaging-data-commons/) | Query and download public cancer imaging data from NCI Imaging Data Commons. Access radiology (CT, MR, PET) and pathology datasets for AI training or research. No authentication required. |

</details>

### Genomic & Molecular Databases

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [drug-bindingdb-query](skills/drug-bindingdb-query/) | Query BindingDB for measured drug-target binding affinities (Ki, Kd, IC50, EC50). Drug discovery, lead optimization, polypharmacology, and SAR studies. |
| [omics-gnomad-frequency-query](skills/omics-gnomad-frequency-query/) | Query gnomAD for population allele frequencies, variant constraint scores (pLI, LOEUF), and loss-of-function intolerance. Variant pathogenicity interpretation and rare disease genetics. |
| [omics-gtex-expression-query](skills/omics-gtex-expression-query/) | Query GTEx for tissue-specific gene expression, eQTLs, and sQTLs. Link GWAS variants to gene regulation and interpret non-coding variant effects. |
| [omics-interpro-domain-query](skills/omics-interpro-domain-query/) | Query InterPro for protein family, domain, and functional site annotations. Integrates Pfam, PANTHER, PRINTS, SMART, and 11+ databases for protein function prediction. |
| [omics-jaspar-motif-query](skills/omics-jaspar-motif-query/) | Query JASPAR for transcription factor binding site profiles (PWMs/PFMs). Regulatory genomics, motif analysis, and GWAS regulatory variant interpretation. |
| [omics-monarch-query](skills/omics-monarch-query/) | Query the Monarch Initiative knowledge graph for disease-gene-phenotype associations. Integrates OMIM, ORPHANET, HPO, ClinVar for rare disease gene discovery. |
| [omics-tiledbvcf-cohort-query](skills/omics-tiledbvcf-cohort-query/) | Scalable VCF/BCF ingestion, storage, and parallel queries using TileDB for population genomics at scale. |

</details>

### Structural Biology & Drug Discovery

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-molecular-dynamics](skills/omics-molecular-dynamics/) | Run and analyze molecular dynamics simulations with OpenMM and MDAnalysis. Protein/small molecule systems, force fields, energy minimization, RMSD/RMSF analysis, free energy surfaces. |
| [drug-protein-glycosylation-design](skills/drug-protein-glycosylation-design/) | Analyze and engineer protein glycosylation. Predict N/O-glycosylation sites, access glycoengineering tools (NetOGlyc, GlycoShield). Therapeutic antibody optimization and vaccine design. |
| [research-adaptyv-protein-testing](skills/research-adaptyv-protein-testing/) | Cloud laboratory platform for automated protein testing: binding assays, expression testing, thermostability, enzyme activity. Protein sequence optimization with NetSolP, SoluProt, ESM. |
| [research-ginkgo-experiment-submission](skills/research-ginkgo-experiment-submission/) | Submit and manage protocols on Ginkgo Bioworks Cloud Lab for autonomous lab execution. Cell-free protein expression, protocol workflows, and biotech automation. |

</details>

</details>

## 🧬 Bioinformatics (gptomics bio-* suite)

<details open>
<summary>Expand/Collapse this category</summary>

### Bioinformatics Tools & Pipelines

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-biopython-sequence-analysis](skills/omics-biopython-sequence-analysis/) | Primary Python toolkit for molecular biology: PubMed/NCBI queries (Bio.Entrez), sequence manipulation, file parsing (FASTA, GenBank, FASTQ, PDB), BLAST workflows. |
| [omics-scikit-bio-sequence-analysis](skills/omics-scikit-bio-sequence-analysis/) | Biological data toolkit. Sequence analysis, alignments, phylogenetic trees, diversity metrics (alpha/beta, UniFrac), ordination (PCoA), PERMANOVA, for microbiome analysis. |
| [omics-ete-tree-analysis](skills/omics-ete-tree-analysis/) | Phylogenetic tree toolkit (ETE). Tree manipulation (Newick/NHX), evolutionary event detection, orthology/paralogy, NCBI taxonomy, visualization (PDF/SVG), for phylogenomics. |
| [omics-deeptools-signal-analysis](skills/omics-deeptools-signal-analysis/) | NGS analysis toolkit. BAM to bigWig conversion, QC (correlation, PCA, fingerprints), heatmaps/profiles (TSS, peaks), for ChIP-seq, RNA-seq, ATAC-seq visualization. |
| [sop-omics-nextflow-analysis](skills/sop-omics-nextflow-analysis/) | Run nf-core bioinformatics pipelines (rnaseq, sarek, atacseq) on sequencing data. Use for RNA-seq, WGS/WES, or ATAC-seq from local FASTQs or public datasets (GEO/SRA). |
| [omics-fastq-analysis](skills/omics-fastq-analysis/) | SRA downloading, FASTQ quality control, STAR alignment, gene quantification, and single-cell kallisto/bustools pipelines for bulk and single-cell sequencing data. |
| [omics-geniml-interval-modeling](skills/omics-geniml-interval-modeling/) | Genomic interval data (BED files) for machine learning tasks. Train region embeddings (Region2Vec, BEDspace), single-cell ATAC-seq analysis. |
| [omics-gtars-interval-processing](skills/omics-gtars-interval-processing/) | High-performance genomic interval analysis in Rust with Python bindings. Genomic regions, BED files, coverage tracks, overlap detection, tokenization for ML models. |
| [omics-arboreto-regulatory-network-inference](skills/omics-arboreto-regulatory-network-inference/) | Infer gene regulatory networks (GRNs) from gene expression data using GRNBoost2 and GENIE3 algorithms. For bulk RNA-seq and single-cell RNA-seq regulatory network inference. |
| [research-lamindb-data-management](skills/research-lamindb-data-management/) | Open-source biological data framework for queryable, traceable, reproducible, and FAIR datasets (scRNA-seq, genomics, imaging). |
| [omics-dnanexus-integration](skills/omics-dnanexus-integration/) | DNAnexus cloud genomics platform. Build apps/applets, manage data, dxpy Python SDK, run workflows, FASTQ/BAM/VCF, for genomics pipeline development. |
| [research-latchbio-integration](skills/research-latchbio-integration/) | Latch platform for bioinformatics workflows. Build pipelines with Latch SDK, @workflow/@task decorators, deploy serverless workflows, Nextflow/Snakemake integration. |

</details>

### Bioinformatics — Clinical Databases & Variant Analysis

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-clinical-databases-clinvar-lookup](skills/omics-clinical-databases-clinvar-lookup/) | Query ClinVar for clinical variant classifications, pathogenicity assertions, and review status. |
| [omics-clinical-databases-dbsnp-queries](skills/omics-clinical-databases-dbsnp-queries/) | Query dbSNP for SNP frequency, allele, and functional annotation data. |
| [omics-clinical-databases-gnomad-frequencies](skills/omics-clinical-databases-gnomad-frequencies/) | Retrieve population allele frequencies from gnomAD for rare variant interpretation. |
| [omics-clinical-databases-hla-typing](skills/omics-clinical-databases-hla-typing/) | HLA typing from sequencing data using standard typing tools and databases. |
| [omics-clinical-databases-myvariant-queries](skills/omics-clinical-databases-myvariant-queries/) | Batch query MyVariant.info for aggregated variant annotations from multiple databases. |
| [omics-clinical-databases-pharmacogenomics](skills/omics-clinical-databases-pharmacogenomics/) | PharmGKB/CPIC pharmacogenomics variant lookup for drug-gene interactions. |
| [omics-clinical-databases-polygenic-risk](skills/omics-clinical-databases-polygenic-risk/) | Calculate polygenic risk scores from GWAS summary statistics and genotype data. |
| [omics-clinical-databases-somatic-signatures](skills/omics-clinical-databases-somatic-signatures/) | Extract and classify mutational signatures from somatic variant catalogs (COSMIC). |
| [omics-clinical-databases-tumor-mutational-burden](skills/omics-clinical-databases-tumor-mutational-burden/) | Compute tumor mutational burden (TMB) from somatic variant calls. |
| [omics-clinical-databases-variant-prioritization](skills/omics-clinical-databases-variant-prioritization/) | Rank and filter candidate variants by pathogenicity scores, inheritance, and phenotype match. |
| [omics-variant-calling](skills/omics-variant-calling/) | GATK-based germline variant calling pipeline from aligned BAM/CRAM files. |
| [omics-variant-calling-clinical-interpretation](skills/omics-variant-calling-clinical-interpretation/) | Interpret variant calls in clinical context with ACMG guidelines. |
| [omics-variant-calling-deepvariant](skills/omics-variant-calling-deepvariant/) | DeepVariant deep-learning variant caller for short-read WGS/WES data. |
| [omics-variant-calling-filtering-best-practices](skills/omics-variant-calling-filtering-best-practices/) | Apply VQSR and hard-filtering best practices to variant call sets. |
| [omics-variant-calling-joint-calling](skills/omics-variant-calling-joint-calling/) | Joint genotyping across multiple samples for improved variant discovery. |
| [omics-variant-calling-structural-variant-calling](skills/omics-variant-calling-structural-variant-calling/) | Call structural variants (SVs) from long-read or paired-end sequencing. |
| [omics-variant-annotation](skills/omics-variant-annotation/) | Annotate VCF files with functional, population, and clinical consequence data. |
| [omics-variant-normalization](skills/omics-variant-normalization/) | Normalize variant representations (left-alignment, decomposition) for consistent comparison. |
| [omics-vcf-basics](skills/omics-vcf-basics/) | Read, write, and parse VCF files; filter by quality, region, and sample. |
| [omics-vcf-manipulation](skills/omics-vcf-manipulation/) | Advanced VCF manipulation: merging, splitting, reformatting, subset extraction. |
| [omics-vcf-statistics](skills/omics-vcf-statistics/) | Compute variant statistics: ts/tv ratio, heterozygosity, depth distributions. |
| [omics-gatk-variant-calling](skills/omics-gatk-variant-calling/) | End-to-end GATK HaplotypeCaller variant calling with BQSR and joint genotyping. |
| [omics-copy-number-cnv-annotation](skills/omics-copy-number-cnv-annotation/) | Annotate CNV calls with gene content, database overlap, and clinical significance. |
| [omics-copy-number-cnv-visualization](skills/omics-copy-number-cnv-visualization/) | Visualize copy number profiles and segment plots from WGS/WES data. |
| [omics-copy-number-cnvkit-analysis](skills/omics-copy-number-cnvkit-analysis/) | CNVKit copy number analysis for targeted sequencing and WES data. |
| [omics-copy-number-gatk-cnv](skills/omics-copy-number-gatk-cnv/) | GATK4 somatic copy number alteration calling pipeline. |
| [omics-tumor-fraction-estimation](skills/omics-tumor-fraction-estimation/) | Estimate tumor purity and ploidy from allele frequencies and copy number data. |
| [omics-ctdna-mutation-detection](skills/omics-ctdna-mutation-detection/) | Detect circulating tumor DNA mutations from liquid biopsy ultra-deep sequencing. |
| [omics-cfdna-preprocessing](skills/omics-cfdna-preprocessing/) | Process cell-free DNA sequencing data: adapter trimming, deduplication, QC. |
| [omics-methylation-based-detection](skills/omics-methylation-based-detection/) | Detect methylation-based cancer signals from cfDNA methylation data. |
| [omics-longitudinal-monitoring](skills/omics-longitudinal-monitoring/) | Track somatic variant evolution and clonal dynamics across serial samples. |

</details>

### Bioinformatics — Sequencing & Read QC

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-fastq-quality](skills/omics-fastq-quality/) | Assess FASTQ read quality with FastQC/MultiQC; generate per-sample QC reports. |
| [omics-read-qc-adapter-trimming](skills/omics-read-qc-adapter-trimming/) | Trim sequencing adapters with Trimmomatic, Cutadapt, or fastp. |
| [omics-read-qc-contamination-screening](skills/omics-read-qc-contamination-screening/) | Screen reads for human/microbial contamination using FastQ Screen or Kraken. |
| [omics-read-qc-fastp-workflow](skills/omics-read-qc-fastp-workflow/) | End-to-end read QC and preprocessing with fastp including UMI handling. |
| [omics-read-qc-quality-filtering](skills/omics-read-qc-quality-filtering/) | Apply quality-score and length filters to remove low-quality reads. |
| [omics-read-qc-quality-reports](skills/omics-read-qc-quality-reports/) | Aggregate multi-sample QC reports with MultiQC. |
| [omics-read-qc-umi-processing](skills/omics-read-qc-umi-processing/) | Deduplicate PCR duplicates using UMI-tools for accurate quantification. |
| [omics-paired-end-fastq](skills/omics-paired-end-fastq/) | Handle paired-end FASTQ files: validation, interleaving, splitting. |
| [omics-alignment-io](skills/omics-alignment-io/) | Read/write SAM/BAM/CRAM alignment files with pysam and samtools. |
| [omics-alignment-msa-parsing](skills/omics-alignment-msa-parsing/) | Parse and analyze multiple sequence alignments (FASTA, ClustalW, Stockholm). |
| [omics-alignment-msa-statistics](skills/omics-alignment-msa-statistics/) | Compute MSA statistics: conservation, gap content, entropy. |
| [omics-alignment-pairwise](skills/omics-alignment-pairwise/) | Pairwise sequence alignment using Smith-Waterman, Needleman-Wunsch, BLAST. |
| [omics-longread-alignment](skills/omics-longread-alignment/) | Align long reads (ONT/PacBio) with minimap2; sort and index BAM files. |
| [omics-longread-qc](skills/omics-longread-qc/) | Quality control for long-read sequencing: read length, N50, error rate. |
| [omics-longread-medaka](skills/omics-longread-medaka/) | Consensus polishing and variant calling with Oxford Nanopore Medaka. |
| [omics-longread-structural-variants](skills/omics-longread-structural-variants/) | Call large structural variants from long-read data with Sniffles/PBSV. |
| [omics-basecalling](skills/omics-basecalling/) | Base-call raw ONT signals with Dorado/Guppy; convert FAST5 to FASTQ. |
| [omics-compressed-files](skills/omics-compressed-files/) | Handle compressed bioinformatics files: bgzip, tabix, zstd, htslib. |
| [omics-format-conversion](skills/omics-format-conversion/) | Convert between bioinformatics formats: FASTQ↔FASTA, BAM↔CRAM, BED↔GTF. |
| [omics-sequence-statistics](skills/omics-sequence-statistics/) | Compute sequence statistics: GC content, length distributions, complexity. |
| [omics-read-sequences](skills/omics-read-sequences/) | Read and iterate over biological sequences from FASTA/FASTQ files. |
| [omics-write-sequences](skills/omics-write-sequences/) | Write biological sequences to FASTA/FASTQ with metadata preservation. |
| [omics-filter-sequences](skills/omics-filter-sequences/) | Filter sequences by length, quality, pattern, or taxonomy label. |
| [omics-batch-processing](skills/omics-batch-processing/) | Batch-process large bioinformatics datasets across samples and cohorts. |
| [omics-rnaseq-qc](skills/omics-rnaseq-qc/) | RNA-seq specific QC: strandedness, rRNA contamination, gene body coverage. |
| [omics-long-read-sequencing-clair3-variants](skills/omics-long-read-sequencing-clair3-variants/) | Call variants from long-read sequencing with Clair3 deep-learning model. |
| [omics-long-read-sequencing-isoseq-analysis](skills/omics-long-read-sequencing-isoseq-analysis/) | Iso-Seq full-length transcript analysis for isoform discovery. |
| [omics-long-read-sequencing-nanopore-methylation](skills/omics-long-read-sequencing-nanopore-methylation/) | Call CpG methylation from Oxford Nanopore sequencing with Modbam2bed. |
| [omics-splicing-qc](skills/omics-splicing-qc/) | RNA splicing quality assessment: junction read coverage, novel splice sites. |
| [omics-splicing-quantification](skills/omics-splicing-quantification/) | Quantify alternative splicing events: PSI/inclusion levels per isoform. |
| [omics-sashimi-plots](skills/omics-sashimi-plots/) | Generate sashimi plots for visualizing RNA-seq splicing at specific loci. |
| [omics-consensus-sequences](skills/omics-consensus-sequences/) | Generate consensus FASTA sequences by applying VCF variants to a reference using `bcftools consensus`; useful for sample-specific references and haplotype reconstruction. |

</details>

### Bioinformatics — Differential Expression & Transcriptomics

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-de-deseq2-basics](skills/omics-de-deseq2-basics/) | DESeq2 differential expression analysis: design matrix, size factors, dispersion. |
| [omics-de-edger-basics](skills/omics-de-edger-basics/) | EdgeR differential expression for count data with empirical Bayes dispersion. |
| [omics-de-results](skills/omics-de-results/) | Extract, filter, and annotate DESeq2/EdgeR results tables. |
| [omics-de-visualization](skills/omics-de-visualization/) | Volcano plots, MA plots, and heatmaps for differential expression results. |
| [omics-differential-expression-batch-correction](skills/omics-differential-expression-batch-correction/) | Remove batch effects with ComBat/limma for multi-cohort DE analysis. |
| [omics-differential-expression-timeseries-de](skills/omics-differential-expression-timeseries-de/) | Time-series differential expression with splines and mixed models. |
| [omics-differential-splicing](skills/omics-differential-splicing/) | Detect differential alternative splicing events with rMATS or MAJIQ. |
| [omics-isoform-switching](skills/omics-isoform-switching/) | Identify isoform switching events with DRIMSeq and IsoformSwitchAnalyzeR. |
| [omics-ribo-seq-orf-detection](skills/omics-ribo-seq-orf-detection/) | Detect translated ORFs from ribosome profiling data with RiboTaper/Ribo-TISH. |
| [omics-ribo-seq-riboseq-preprocessing](skills/omics-ribo-seq-riboseq-preprocessing/) | Preprocess ribosome profiling reads: adapter trimming, rRNA removal, alignment. |
| [omics-ribo-seq-ribosome-periodicity](skills/omics-ribo-seq-ribosome-periodicity/) | Assess triplet periodicity and ribosome footprint quality in Ribo-seq data. |
| [omics-ribo-seq-ribosome-stalling](skills/omics-ribo-seq-ribosome-stalling/) | Identify ribosome stalling sites and pausing from Ribo-seq profiles. |
| [omics-ribo-seq-translation-efficiency](skills/omics-ribo-seq-translation-efficiency/) | Compute translation efficiency ratios from matched RNA-seq and Ribo-seq. |

</details>

### Bioinformatics — Pathway & Network Analysis

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-pathway-go-enrichment](skills/omics-pathway-go-enrichment/) | Gene Ontology enrichment analysis with clusterProfiler or g:Profiler. |
| [omics-pathway-gsea](skills/omics-pathway-gsea/) | Gene Set Enrichment Analysis (GSEA) with pre-ranked or count-based statistics. |
| [omics-pathway-kegg-pathways](skills/omics-pathway-kegg-pathways/) | KEGG pathway enrichment and visualization for metabolic/signaling pathways. |
| [omics-pathway-reactome](skills/omics-pathway-reactome/) | Reactome pathway analysis with hierarchical enrichment and visualization. |
| [omics-pathway-wikipathways](skills/omics-pathway-wikipathways/) | WikiPathways enrichment and network visualization. |
| [omics-pathway-enrichment-visualization](skills/omics-pathway-enrichment-visualization/) | Dot plots, enrichment maps, and network visualizations for pathway results. |

</details>

### Bioinformatics — Single-Cell & Spatial Omics

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-single-cell-batch-integration](skills/omics-single-cell-batch-integration/) | Integrate scRNA-seq datasets across batches with Harmony, BBKNN, scVI. |
| [omics-single-cell-cell-annotation](skills/omics-single-cell-cell-annotation/) | Annotate single-cell clusters using marker genes and reference atlases. |
| [omics-single-cell-cell-communication](skills/omics-single-cell-cell-communication/) | Infer ligand-receptor cell-cell communication with CellChat or NicheNet. |
| [omics-single-cell-clustering](skills/omics-single-cell-clustering/) | Cluster single cells with Leiden/Louvain algorithms in Scanpy/Seurat. |
| [omics-single-cell-data-io](skills/omics-single-cell-data-io/) | Read/write AnnData, Seurat, and 10x Genomics h5ad/h5 formats. |
| [omics-single-cell-doublet-detection](skills/omics-single-cell-doublet-detection/) | Remove doublets from scRNA-seq with Scrublet or DoubletFinder. |
| [omics-single-cell-lineage-tracing](skills/omics-single-cell-lineage-tracing/) | Reconstruct cell lineage trees from scRNA-seq with clonal barcodes. |
| [omics-single-cell-markers-annotation](skills/omics-single-cell-markers-annotation/) | Identify cluster marker genes and auto-annotate cell types. |
| [omics-single-cell-metabolite-communication](skills/omics-single-cell-metabolite-communication/) | Infer metabolite-mediated intercellular communication from scRNA-seq. |
| [omics-single-cell-multimodal-integration](skills/omics-single-cell-multimodal-integration/) | Integrate scRNA-seq with ATAC, CITE-seq, or spatial using WNN/MultiVI. |
| [omics-single-cell-perturb-seq](skills/omics-single-cell-perturb-seq/) | Analyze genetic perturbation screens from Perturb-seq / CROP-seq data. |
| [omics-single-cell-preprocessing](skills/omics-single-cell-preprocessing/) | Single-cell preprocessing: count filtering, normalization, HVG selection. |
| [omics-single-cell-scatac-analysis](skills/omics-single-cell-scatac-analysis/) | scATAC-seq peak calling, TF motif enrichment, and chromatin accessibility. |
| [omics-single-cell-splicing](skills/omics-single-cell-splicing/) | RNA velocity and splicing dynamics with scVelo or Alevin. |
| [omics-single-cell-trajectory-inference](skills/omics-single-cell-trajectory-inference/) | Infer pseudotime trajectories with Monocle3, PAGA, or Slingshot. |
| [omics-spatial-transcriptomics-image-analysis](skills/omics-spatial-transcriptomics-image-analysis/) | Analyze histology images co-registered with spatial transcriptomics data. |
| [omics-spatial-transcriptomics-spatial-communication](skills/omics-spatial-transcriptomics-spatial-communication/) | Ligand-receptor communication analysis with spatial context (COMMOT, SpatialDE). |
| [omics-spatial-transcriptomics-spatial-data-io](skills/omics-spatial-transcriptomics-spatial-data-io/) | Load and process Visium, Slide-seq, MERFISH, and STARmap datasets. |
| [omics-spatial-transcriptomics-spatial-deconvolution](skills/omics-spatial-transcriptomics-spatial-deconvolution/) | Deconvolve cell type proportions in spatial spots with RCTD, SPOTlight. |
| [omics-spatial-transcriptomics-spatial-domains](skills/omics-spatial-transcriptomics-spatial-domains/) | Identify spatially variable genes and tissue domains with SpatialDE/BANKSY. |
| [omics-spatial-transcriptomics-spatial-multiomics](skills/omics-spatial-transcriptomics-spatial-multiomics/) | Integrate spatial transcriptomics with proteomics, metabolomics, or imaging. |
| [omics-spatial-transcriptomics-spatial-neighbors](skills/omics-spatial-transcriptomics-spatial-neighbors/) | Build spatial neighbor graphs and perform neighborhood enrichment analysis. |
| [omics-spatial-transcriptomics-spatial-preprocessing](skills/omics-spatial-transcriptomics-spatial-preprocessing/) | Preprocess spatial transcriptomics: QC, normalization, spot filtering. |
| [omics-spatial-transcriptomics-spatial-proteomics](skills/omics-spatial-transcriptomics-spatial-proteomics/) | Analyze spatial proteomics data from CODEX, IMC, or MIBI platforms. |
| [omics-spatial-transcriptomics-spatial-statistics](skills/omics-spatial-transcriptomics-spatial-statistics/) | Spatial statistics: Moran's I, spatial autocorrelation, co-localization. |
| [omics-spatial-transcriptomics-spatial-visualization](skills/omics-spatial-transcriptomics-spatial-visualization/) | Visualize spatial gene expression maps and tissue section overlays. |

</details>

### Bioinformatics — Epigenomics & Chromatin

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-atac-seq-atac-peak-calling](skills/omics-atac-seq-atac-peak-calling/) | Call ATAC-seq chromatin accessibility peaks with MACS2/MACS3. |
| [omics-atac-seq-atac-qc](skills/omics-atac-seq-atac-qc/) | ATAC-seq quality control: TSS enrichment, fragment size, FRiP score. |
| [omics-atac-seq-differential-accessibility](skills/omics-atac-seq-differential-accessibility/) | Differential chromatin accessibility between conditions with DESeq2/DiffBind. |
| [omics-atac-seq-footprinting](skills/omics-atac-seq-footprinting/) | Transcription factor footprinting from ATAC-seq with TOBIAS or HINT-ATAC. |
| [omics-atac-seq-motif-deviation](skills/omics-atac-seq-motif-deviation/) | TF motif deviation scoring with chromVAR for single-cell ATAC data. |
| [omics-atac-seq-nucleosome-positioning](skills/omics-atac-seq-nucleosome-positioning/) | Infer nucleosome positioning from ATAC-seq fragment length distributions. |
| [omics-chipseq-differential-binding](skills/omics-chipseq-differential-binding/) | Differential ChIP-seq binding analysis with DiffBind. |
| [omics-chipseq-motif-analysis](skills/omics-chipseq-motif-analysis/) | De novo and known motif discovery from ChIP-seq peaks with HOMER/MEME. |
| [omics-chipseq-peak-annotation](skills/omics-chipseq-peak-annotation/) | Annotate ChIP-seq peaks with genomic features and nearest genes. |
| [omics-chipseq-peak-calling](skills/omics-chipseq-peak-calling/) | Call ChIP-seq peaks with MACS2 for TF binding and histone marks. |
| [omics-chipseq-qc](skills/omics-chipseq-qc/) | ChIP-seq quality metrics: FRiP, SCC, phantompeakqualtools. |
| [omics-chipseq-super-enhancers](skills/omics-chipseq-super-enhancers/) | Identify super enhancers from H3K27ac ChIP-seq with ROSE. |
| [omics-chipseq-visualization](skills/omics-chipseq-visualization/) | Heatmaps and aggregate profiles at peak regions with deepTools. |
| [omics-hi-c-analysis-compartment-analysis](skills/omics-hi-c-analysis-compartment-analysis/) | Call A/B compartments from Hi-C contact matrices. |
| [omics-hi-c-analysis-contact-pairs](skills/omics-hi-c-analysis-contact-pairs/) | Process Hi-C contact pairs: filtering, deduplication, binning. |
| [omics-hi-c-analysis-hic-data-io](skills/omics-hi-c-analysis-hic-data-io/) | Read and write Hi-C data formats: .hic, cool, mcool with cooler/hicstuff. |
| [omics-hi-c-analysis-hic-differential](skills/omics-hi-c-analysis-hic-differential/) | Differential Hi-C interaction analysis between conditions. |
| [omics-hi-c-analysis-hic-visualization](skills/omics-hi-c-analysis-hic-visualization/) | Visualize Hi-C contact maps, TADs, and loops with pyGenomeTracks. |
| [omics-hi-c-analysis-loop-calling](skills/omics-hi-c-analysis-loop-calling/) | Detect chromatin loops from Hi-C data with Mustache or HICCUPS. |
| [omics-hi-c-analysis-matrix-operations](skills/omics-hi-c-analysis-matrix-operations/) | Normalize Hi-C matrices: ICE, KR, VC; compute observed/expected. |
| [omics-hi-c-analysis-tad-detection](skills/omics-hi-c-analysis-tad-detection/) | Identify topologically associating domains (TADs) from Hi-C data. |
| [omics-methylation-bismark-alignment](skills/omics-methylation-bismark-alignment/) | Align bisulfite sequencing reads and extract CpG methylation with Bismark. |
| [omics-methylation-calling](skills/omics-methylation-calling/) | Call CpG methylation from WGBS/RRBS alignments. |
| [omics-methylation-dmr-detection](skills/omics-methylation-dmr-detection/) | Identify differentially methylated regions (DMRs) with DSS or MethylKit. |
| [omics-methylation-methylkit](skills/omics-methylation-methylkit/) | Methylation analysis with MethylKit: CpG tiles, DMR calling, annotation. |

</details>

### Bioinformatics — Metagenomics & Microbiome

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-metagenomics-abundance](skills/omics-metagenomics-abundance/) | Estimate microbial taxon abundances from shotgun metagenomics. |
| [omics-metagenomics-amr-detection](skills/omics-metagenomics-amr-detection/) | Detect antimicrobial resistance genes with AMRFinder or RGI/CARD. |
| [omics-metagenomics-functional-profiling](skills/omics-metagenomics-functional-profiling/) | Functional profiling of metagenomes with HUMAnN3 for pathway/gene families. |
| [omics-metagenomics-kraken](skills/omics-metagenomics-kraken/) | Taxonomic classification of metagenomic reads with Kraken2/Bracken. |
| [omics-metagenomics-metaphlan](skills/omics-metagenomics-metaphlan/) | Clade-specific marker-based profiling of microbial communities with MetaPhlAn4. |
| [omics-metagenomics-strain-tracking](skills/omics-metagenomics-strain-tracking/) | Track microbial strains across samples with StrainPhlan or inStrain. |
| [omics-metagenomics-visualization](skills/omics-metagenomics-visualization/) | Visualize microbiome composition with Krona charts and stacked bar plots. |
| [omics-microbiome-amplicon-processing](skills/omics-microbiome-amplicon-processing/) | Process 16S/ITS amplicon sequencing with QIIME2 or DADA2. |
| [omics-microbiome-differential-abundance](skills/omics-microbiome-differential-abundance/) | Test differential microbial abundance with ANCOM-BC, MaAsLin2, or ALDEx2. |
| [omics-microbiome-diversity-analysis](skills/omics-microbiome-diversity-analysis/) | Alpha/beta diversity analysis: Shannon, PD, UniFrac, PCoA. |
| [omics-microbiome-functional-prediction](skills/omics-microbiome-functional-prediction/) | Predict functional capacity from 16S data with PICRUSt2 or Tax4Fun. |
| [omics-microbiome-qiime2-workflow](skills/omics-microbiome-qiime2-workflow/) | End-to-end QIIME2 workflow: denoising, diversity, differential abundance. |
| [omics-microbiome-taxonomy-assignment](skills/omics-microbiome-taxonomy-assignment/) | Assign taxonomy to ASVs/OTUs using SILVA, GTDB, or Greengenes2. |

</details>

### Bioinformatics — Immunoinformatics & Flow Cytometry

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-immunoinformatics-epitope-prediction](skills/omics-immunoinformatics-epitope-prediction/) | Predict MHC-I/II epitopes from protein sequences with NetMHCpan/MHCflurry. |
| [omics-immunoinformatics-immunogenicity-scoring](skills/omics-immunoinformatics-immunogenicity-scoring/) | Score peptide immunogenicity for vaccine and neoantigen prioritization. |
| [omics-immunoinformatics-mhc-binding-prediction](skills/omics-immunoinformatics-mhc-binding-prediction/) | Predict peptide-MHC binding affinities for multiple alleles. |
| [omics-immunoinformatics-neoantigen-prediction](skills/omics-immunoinformatics-neoantigen-prediction/) | Predict neoantigens from somatic mutations for personalized cancer vaccines. |
| [omics-immunoinformatics-tcr-epitope-binding](skills/omics-immunoinformatics-tcr-epitope-binding/) | Predict TCR-epitope binding with ERGO, pMTnet, or NetTCR. |
| [omics-tcr-bcr-analysis-immcantation-analysis](skills/omics-tcr-bcr-analysis-immcantation-analysis/) | Analyze B/T cell receptor repertoires with the Immcantation suite. |
| [omics-tcr-bcr-analysis-mixcr-analysis](skills/omics-tcr-bcr-analysis-mixcr-analysis/) | MiXCR V(D)J alignment and clonotype assembly for immune repertoires. |
| [omics-tcr-bcr-analysis-repertoire-visualization](skills/omics-tcr-bcr-analysis-repertoire-visualization/) | Visualize repertoire diversity, clonal expansion, and V-gene usage. |
| [omics-tcr-bcr-analysis-scirpy-analysis](skills/omics-tcr-bcr-analysis-scirpy-analysis/) | Single-cell TCR/BCR analysis integrated with scRNA-seq using Scirpy. |
| [omics-tcr-bcr-analysis-vdjtools-analysis](skills/omics-tcr-bcr-analysis-vdjtools-analysis/) | Immune repertoire statistics and overlap analysis with VDJtools. |
| [omics-flow-cytometry-bead-normalization](skills/omics-flow-cytometry-bead-normalization/) | Normalize flow cytometry data using calibration beads. |
| [omics-flow-cytometry-clustering-phenotyping](skills/omics-flow-cytometry-clustering-phenotyping/) | Cluster and phenotype cell populations with FlowSOM, PhenoGraph, or UMAP. |
| [omics-flow-cytometry-compensation-transformation](skills/omics-flow-cytometry-compensation-transformation/) | Apply compensation matrices and biexponential/arcsinh transformations. |
| [omics-flow-cytometry-cytometry-qc](skills/omics-flow-cytometry-cytometry-qc/) | Quality control for flow/mass cytometry: signal drift, spillover, outlier detection. |
| [omics-flow-cytometry-differential-analysis](skills/omics-flow-cytometry-differential-analysis/) | Statistical comparison of cell populations between conditions. |
| [omics-flow-cytometry-doublet-detection](skills/omics-flow-cytometry-doublet-detection/) | Detect and remove doublets from flow cytometry data. |
| [omics-flow-cytometry-fcs-handling](skills/omics-flow-cytometry-fcs-handling/) | Read, write, and manipulate FCS files with FlowCore/FlowKit. |
| [omics-flow-cytometry-gating-analysis](skills/omics-flow-cytometry-gating-analysis/) | Manual and algorithmic gating strategies for cell population identification. |
| [omics-imaging-mass-cytometry-cell-segmentation](skills/omics-imaging-mass-cytometry-cell-segmentation/) | Segment cells in IMC images with Mesmer or CellProfiler. |
| [omics-imaging-mass-cytometry-data-preprocessing](skills/omics-imaging-mass-cytometry-data-preprocessing/) | Preprocess imaging mass cytometry data: hot pixel removal, normalization. |
| [omics-imaging-mass-cytometry-interactive-annotation](skills/omics-imaging-mass-cytometry-interactive-annotation/) | Interactively annotate cell types in IMC spatial datasets. |
| [omics-imaging-mass-cytometry-phenotyping](skills/omics-imaging-mass-cytometry-phenotyping/) | Phenotype immune and tumor cells from multi-marker IMC panels. |
| [omics-imaging-mass-cytometry-quality-metrics](skills/omics-imaging-mass-cytometry-quality-metrics/) | Quality metrics for IMC acquisitions: signal-to-noise, tissue coverage. |
| [omics-imaging-mass-cytometry-spatial-analysis](skills/omics-imaging-mass-cytometry-spatial-analysis/) | Spatial cell neighborhood analysis from imaging mass cytometry data. |

</details>

### Bioinformatics — Multi-Omics Integration

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-multi-omics-data-harmonization](skills/omics-multi-omics-data-harmonization/) | Harmonize multi-omics datasets: sample matching, batch correction, feature alignment. |
| [omics-multi-omics-mixomics-analysis](skills/omics-multi-omics-mixomics-analysis/) | Multi-omics factor analysis with mixOmics (DIABLO, MOFA, sPLS-DA). |
| [omics-multi-omics-mofa-integration](skills/omics-multi-omics-mofa-integration/) | Multi-Omics Factor Analysis (MOFA+) for latent factor discovery across modalities. |
| [omics-multi-omics-similarity-network](skills/omics-multi-omics-similarity-network/) | Similarity Network Fusion (SNF) for patient stratification from multi-omics. |

</details>

### Bioinformatics — Proteomics & Metabolomics

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-proteomics-data-import](skills/omics-proteomics-data-import/) | Import DDA/DIA proteomics data from MaxQuant, Proteome Discoverer, FragPipe. |
| [omics-proteomics-dia-analysis](skills/omics-proteomics-dia-analysis/) | DIA proteomics analysis with DIA-NN or Spectronaut. |
| [omics-proteomics-differential-abundance](skills/omics-proteomics-differential-abundance/) | Differential protein abundance with limma, MSstats, or DEqMS. |
| [omics-proteomics-peptide-identification](skills/omics-proteomics-peptide-identification/) | Peptide spectrum matching and database search result parsing. |
| [omics-proteomics-protein-inference](skills/omics-proteomics-protein-inference/) | Protein grouping, parsimony, and FDR control for proteomics experiments. |
| [omics-proteomics-proteomics-qc](skills/omics-proteomics-proteomics-qc/) | Proteomics QC: peptide counts, coverage, missing values, CV. |
| [omics-proteomics-ptm-analysis](skills/omics-proteomics-ptm-analysis/) | Post-translational modification analysis: phospho, ubiquitin, glycan enrichment. |
| [omics-proteomics-quantification](skills/omics-proteomics-quantification/) | Label-free, TMT/iTRAQ, and SILAC quantification workflows. |
| [omics-proteomics-spectral-libraries](skills/omics-proteomics-spectral-libraries/) | Build and use spectral libraries for DIA data analysis. |
| [omics-metabolomics-lipidomics](skills/omics-metabolomics-lipidomics/) | Lipidomics data analysis: lipid class annotation, fatty acid composition. |
| [omics-metabolomics-metabolite-annotation](skills/omics-metabolomics-metabolite-annotation/) | Annotate mass spec features with HMDB, MZmine, SIRIUS, or MetFrag. |
| [omics-metabolomics-msdial-preprocessing](skills/omics-metabolomics-msdial-preprocessing/) | MS-DIAL-based LC-MS/GC-MS data preprocessing and peak detection. |
| [omics-metabolomics-normalization-qc](skills/omics-metabolomics-normalization-qc/) | Metabolomics normalization: PQN, LOESS, median, batch correction. |
| [omics-metabolomics-pathway-mapping](skills/omics-metabolomics-pathway-mapping/) | Map identified metabolites to KEGG, MetaCyc, or Reactome pathways. |
| [omics-metabolomics-statistical-analysis](skills/omics-metabolomics-statistical-analysis/) | Univariate/multivariate stats for metabolomics: PCA, PLS-DA, ANOVA. |
| [omics-metabolomics-targeted-analysis](skills/omics-metabolomics-targeted-analysis/) | Targeted metabolomics with MRM/SRM: calibration curves, quantification. |
| [omics-metabolomics-xcms-preprocessing](skills/omics-metabolomics-xcms-preprocessing/) | XCMS-based LC-MS peak detection, alignment, and grouping. |

</details>

### Bioinformatics — Structural Biology & Cheminformatics

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-structural-biology-alphafold-predictions](skills/omics-structural-biology-alphafold-predictions/) | Use AlphaFold2/3 predictions: model quality assessment, confidence scores. |
| [omics-structural-biology-modern-structure-prediction](skills/omics-structural-biology-modern-structure-prediction/) | Modern structure prediction with ESMFold, RoseTTAFold, and OpenFold. |
| [omics-pdb-geometric-analysis](skills/omics-pdb-geometric-analysis/) | Geometric analysis of protein structures: distances, angles, contacts, RMSD. |
| [omics-pdb-structure-io](skills/omics-pdb-structure-io/) | Read and write PDB/mmCIF structure files with BioPython or Gemmi. |
| [omics-pdb-structure-modification](skills/omics-pdb-structure-modification/) | Modify protein structures: add hydrogens, mutate residues, energy minimize. |
| [omics-pdb-structure-navigation](skills/omics-pdb-structure-navigation/) | Navigate and inspect PDB structures: chain, residue, atom selection. |
| [drug-molecular-descriptors](skills/drug-molecular-descriptors/) | Calculate molecular descriptors (RDKit): MW, LogP, TPSA, fingerprints. |
| [drug-molecular-io](skills/drug-molecular-io/) | Read/write chemical structure formats: SDF, SMILES, MOL2, PDB with RDKit. |
| [drug-reaction-enumeration](skills/drug-reaction-enumeration/) | Enumerate reactions and products from SMARTS reaction templates. |
| [drug-similarity-searching](skills/drug-similarity-searching/) | Molecular similarity search: Tanimoto, fingerprint-based, scaffold hopping. |
| [drug-substructure-search](skills/drug-substructure-search/) | Substructure searching in chemical databases using SMARTS patterns. |
| [drug-virtual-screening](skills/drug-virtual-screening/) | Virtual screening workflows: docking, scoring, pose filtering with AutoDock/Vina. |
| [drug-admet-prediction](skills/drug-admet-prediction/) | Predict ADMET properties: absorption, distribution, metabolism, excretion, toxicity. |

</details>

### Bioinformatics — Epidemiological & Causal Genomics

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-epidemiological-genomics-amr-surveillance](skills/omics-epidemiological-genomics-amr-surveillance/) | Antimicrobial resistance surveillance from genomic epidemiology data. |
| [omics-epidemiological-genomics-pathogen-typing](skills/omics-epidemiological-genomics-pathogen-typing/) | Pathogen molecular typing: MLST, wgMLST, cgMLST for outbreak analysis. |
| [omics-epidemiological-genomics-phylodynamics](skills/omics-epidemiological-genomics-phylodynamics/) | Phylodynamics: molecular clock, population dynamics, BEAST2/TreeTime. |
| [omics-epidemiological-genomics-transmission-inference](skills/omics-epidemiological-genomics-transmission-inference/) | Infer transmission networks from pathogen genomics with TransPhylo/outbreaker2. |
| [omics-epidemiological-genomics-variant-surveillance](skills/omics-epidemiological-genomics-variant-surveillance/) | Track pathogen variant emergence and spread from genomic surveillance. |
| [omics-causal-genomics-colocalization-analysis](skills/omics-causal-genomics-colocalization-analysis/) | Colocalization analysis of GWAS and eQTL signals with coloc or eCAVIAR. |
| [omics-causal-genomics-fine-mapping](skills/omics-causal-genomics-fine-mapping/) | Fine-map causal variants at GWAS loci with SuSiE or FINEMAP. |
| [omics-causal-genomics-mediation-analysis](skills/omics-causal-genomics-mediation-analysis/) | Causal mediation analysis for gene expression intermediaries. |
| [omics-causal-genomics-mendelian-randomization](skills/omics-causal-genomics-mendelian-randomization/) | Two-sample Mendelian randomization with MR-Base/TwoSampleMR. |
| [omics-causal-genomics-pleiotropy-detection](skills/omics-causal-genomics-pleiotropy-detection/) | Detect horizontal pleiotropy and heterogeneity in MR analyses. |
| [omics-genome-engineering-base-editing-design](skills/omics-genome-engineering-base-editing-design/) | Design base editors (CBE/ABE) for precise single-base correction. |
| [omics-genome-engineering-grna-design](skills/omics-genome-engineering-grna-design/) | Design and score CRISPR guide RNAs with Cas-OFFinder and CRISPOR. |
| [omics-genome-engineering-hdr-template-design](skills/omics-genome-engineering-hdr-template-design/) | Design HDR templates for precise knock-in via homology-directed repair. |
| [omics-genome-engineering-off-target-prediction](skills/omics-genome-engineering-off-target-prediction/) | Predict CRISPR off-target sites genome-wide for safety assessment. |
| [omics-genome-engineering-prime-editing-design](skills/omics-genome-engineering-prime-editing-design/) | Design pegRNAs and nickase gRNAs for prime editing experiments. |
| [omics-crispr-screens-base-editing-analysis](skills/omics-crispr-screens-base-editing-analysis/) | Analyze base editing screens: guide efficiency, editing outcomes. |
| [omics-crispr-screens-batch-correction](skills/omics-crispr-screens-batch-correction/) | Correct batch effects in CRISPR screen data across replicates. |
| [omics-crispr-screens-crispresso-editing](skills/omics-crispr-screens-crispresso-editing/) | Quantify editing outcomes with CRISPResso2 from amplicon sequencing. |
| [omics-crispr-screens-hit-calling](skills/omics-crispr-screens-hit-calling/) | Call hits from CRISPR screens using MAGeCK, BAGEL2, or casTLE. |
| [omics-crispr-screens-jacks-analysis](skills/omics-crispr-screens-jacks-analysis/) | CRISPR screen analysis with JACKS hierarchical Bayesian model. |
| [omics-crispr-screens-library-design](skills/omics-crispr-screens-library-design/) | Design CRISPR screen libraries: guide selection, controls, coverage. |
| [omics-crispr-screens-mageck-analysis](skills/omics-crispr-screens-mageck-analysis/) | MAGeCK MLE/RRA analysis for CRISPR pooled screens. |
| [omics-crispr-screens-screen-qc](skills/omics-crispr-screens-screen-qc/) | Quality control for CRISPR screens: Gini index, read distribution. |

</details>

</details>

## 🔬 Omics & Computational Biology

<details open>
<summary>Expand/Collapse this category</summary>

### Single-Cell & Spatial Omics

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-anndata-matrix-management](skills/omics-anndata-matrix-management/) | Working with annotated data matrices in Python for single-cell genomics analysis, managing experimental measurements with metadata and large-scale omics data. |
| [omics-scanpy-single-cell-analysis](skills/omics-scanpy-single-cell-analysis/) | Single-cell RNA-seq analysis. Load .h5ad/10X data, QC, normalization, PCA/UMAP/t-SNE, Leiden clustering, marker genes, cell type annotation, trajectory. |
| [omics-scvi-single-cell-integration](skills/omics-scvi-single-cell-integration/) | Deep learning for single-cell analysis: data integration/batch correction (scVI/scANVI), ATAC-seq (PeakVI), CITE-seq (totalVI), multiome (MultiVI), spatial deconvolution (DestVI). |
| [omics-single-cell-rna-qc](skills/omics-single-cell-rna-qc/) | Quality control on single-cell RNA-seq data (.h5ad or .h5 files) using scverse best practices with MAD-based filtering and comprehensive visualizations. |
| [omics-cellxgene-census-query](skills/omics-cellxgene-census-query/) | Query CZ CELLxGENE Census (61M+ cells). Filter by cell type/tissue/disease, retrieve expression data, integrate with scanpy/PyTorch, for population-scale single-cell analysis. |
| [omics-pydeseq2-differential-expression](skills/omics-pydeseq2-differential-expression/) | Differential gene expression analysis (Python DESeq2). Identify DE genes from bulk RNA-seq counts, Wald tests, FDR correction, volcano/MA plots. |
| [omics-bulk-combat-correction](skills/omics-bulk-combat-correction/) | Remove batch effects from merged bulk RNA-seq or microarray cohorts using pyComBat, with corrected matrix export and pre/post correction visualizations. |
| [omics-bulk-deg-analysis](skills/omics-bulk-deg-analysis/) | Bulk RNA-seq DEG pipeline: gene ID mapping, DESeq2 normalization, statistical testing, visualization, and pathway enrichment via OmicVerse. |
| [omics-bulk-deseq2-analysis](skills/omics-bulk-deseq2-analysis/) | PyDESeq2-based differential expression analysis with ID mapping, DE testing, fold-change thresholding, and enrichment visualization. |
| [omics-bulk-stringdb-ppi](skills/omics-bulk-stringdb-ppi/) | Query STRING for protein interactions, build PPI graphs with pyPPI, and render network figures for bulk gene lists. |
| [omics-bulk-to-single-deconvolution](skills/omics-bulk-to-single-deconvolution/) | Convert bulk RNA-seq cohorts to synthetic single-cell datasets using Bulk2Single workflow for cell fraction estimation and beta-VAE generation. |
| [omics-bulk-trajblend-interpolation](skills/omics-bulk-trajblend-interpolation/) | Extend scRNA-seq developmental trajectories with BulkTrajBlend by generating intermediate cells from bulk RNA-seq using beta-VAE and GNN models. |
| [omics-bulk-wgcna-analysis](skills/omics-bulk-wgcna-analysis/) | Run PyWGCNA through OmicVerse — co-expression module construction, eigengene visualization, and hub gene extraction. |
| [omics-single-annotation](skills/omics-single-annotation/) | Single-cell annotation workflows: SCSA, MetaTiME, CellVote, CellMatch, GPTAnno, and weighted KNN transfer for annotating cell types across modalities. |
| [omics-single-cellphone-db](skills/omics-single-cellphone-db/) | Run CellPhoneDB v5 on annotated single-cell data to infer ligand-receptor networks and produce CellChat-style visualizations. |
| [omics-single-clustering](skills/omics-single-clustering/) | Single-cell clustering workflow: QC, multimethod clustering, topic modeling, cNMF, and cross-batch integration in OmicVerse. |
| [omics-single-downstream-analysis](skills/omics-single-downstream-analysis/) | OmicVerse downstream tutorials covering AUCell scoring, metacell DEG, and related exports for single-cell data. |
| [omics-single-multiomics](skills/omics-single-multiomics/) | OmicVerse multi-omics tutorials: MOFA, GLUE pairing, SIMBA integration, TOSICA transfer, and StaVIA cartography. |
| [omics-single-preprocessing](skills/omics-single-preprocessing/) | Single-cell preprocessing in OmicVerse: QC, normalization, HVG detection, PCA/embedding pipelines (CPU/GPU). |
| [omics-single-to-spatial-mapping](skills/omics-single-to-spatial-mapping/) | Map scRNA-seq atlases onto spatial transcriptomics slides using Single2Spatial workflow for deep-forest training and marker visualization. |
| [omics-single-trajectory](skills/omics-single-trajectory/) | OmicVerse trajectory workflows: PAGA, Palantir, VIA, velocity coupling, and fate scoring. |
| [omics-spatial-tutorials](skills/omics-spatial-tutorials/) | Spatial transcriptomics tutorials: preprocessing, deconvolution, and downstream modeling across Visium, Visium HD, Stereo-seq, and Slide-seq. |
| [omics-tcga-preprocessing](skills/omics-tcga-preprocessing/) | Ingest TCGA sample sheets, expression archives, and clinical carts into OmicVerse, with survival metadata initialization and AnnData export. |
| [omics-gsea-enrichment](skills/omics-gsea-enrichment/) | Gene set enrichment analysis in OmicVerse with correct geneset format handling for loading pathway databases and running GSEA. |

</details>

### Cheminformatics & Drug Discovery

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [drug-rdkit-molecule-processing](skills/drug-rdkit-molecule-processing/) | Cheminformatics toolkit for fine-grained molecular control. SMILES/SDF parsing, descriptors (MW, LogP, TPSA), fingerprints, substructure search, 2D/3D generation, similarity. |
| [drug-datamol-molecule-processing](skills/drug-datamol-molecule-processing/) | Pythonic RDKit wrapper with simplified interface for standard drug discovery: SMILES parsing, standardization, descriptors, fingerprints, clustering, 3D conformer generation. |
| [drug-medchem-molecule-filtering](skills/drug-medchem-molecule-filtering/) | Medicinal chemistry filters. Apply drug-likeness rules (Lipinski, Veber), PAINS filters, structural alerts, complexity metrics, for compound prioritization and library filtering. |
| [drug-diffdock-pose-prediction](skills/drug-diffdock-pose-prediction/) | Diffusion-based molecular docking. Predict protein-ligand binding poses from PDB/SMILES, confidence scores, virtual screening, for structure-based drug design. |
| [drug-molfeat-feature-generation](skills/drug-molfeat-feature-generation/) | Molecular featurization for ML (100+ featurizers). ECFP, MACCS, descriptors, pretrained models (ChemBERTa), convert SMILES to features, for QSAR and molecular ML. |
| [drug-deepchem-model-training](skills/drug-deepchem-model-training/) | Molecular machine learning toolkit. Property prediction (ADMET, toxicity), GNNs (GCN, MPNN), MoleculeNet benchmarks, pretrained models, for drug discovery ML. |
| [drug-torchdrug-graph-modeling](skills/drug-torchdrug-graph-modeling/) | Graph-based drug discovery toolkit. Molecular property prediction (ADMET), protein modeling, knowledge graph reasoning, molecular generation, retrosynthesis, GNNs. |
| [research-torch-geometric-reference](skills/research-torch-geometric-reference/) | Graph Neural Networks (PyG). Node/graph classification, link prediction, GCN, GAT, GraphSAGE, molecular property prediction, for geometric deep learning in drug discovery. |
| [drug-tdc-benchmark-evaluation](skills/drug-tdc-benchmark-evaluation/) | Therapeutics Data Commons. AI-ready drug discovery datasets (ADME, toxicity, DTI), benchmarks, scaffold splits, molecular oracles, for therapeutic ML. |
| [omics-cobrapy-metabolic-modeling](skills/omics-cobrapy-metabolic-modeling/) | Constraint-based metabolic modeling (COBRA). FBA, FVA, gene knockouts, flux sampling, SBML models, for systems biology and metabolic engineering. |

</details>

### Proteomics & Mass Spectrometry

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-matchms-spectrum-comparison](skills/omics-matchms-spectrum-comparison/) | Mass spectrometry spectral analysis. Process mzML/MGF/MSP files, spectral similarity (cosine, modified cosine), metadata harmonization, compound identification. |
| [omics-pyopenms-spectrum-processing](skills/omics-pyopenms-spectrum-processing/) | Python interface to OpenMS for LC-MS/MS proteomics and metabolomics workflows. File handling (mzML, mzXML, mzTab, pepXML, mzIdentML) and quantification. |
| [omics-fcs-data-io](skills/omics-fcs-data-io/) | Parse FCS (Flow Cytometry Standard) files v2.0-3.1. Extract events as NumPy arrays, read metadata/channels, convert to CSV/DataFrame, for flow cytometry data preprocessing. |

</details>

### Protein Structure & Design

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-esm-protein-modeling](skills/omics-esm-protein-modeling/) | ESM3 generative multimodal protein design (sequence, structure, function) and ESM C efficient protein embeddings. Protein language models for sequence scoring and embedding. |
| [omics-alphafold-structure-prediction](skills/omics-alphafold-structure-prediction/) | Validate protein designs using AlphaFold2 structure prediction. Validates designed sequences, predicts binder-target complex structures, calculates pLDDT/PAE metrics. |
| [omics-boltz-complex-prediction](skills/omics-boltz-complex-prediction/) | Structure prediction using Boltz-1/Boltz-2, an open biomolecular structure predictor for protein complexes, binder validation, and open-source AlphaFold alternative. |
| [drug-boltzgen-binder-design](skills/drug-boltzgen-binder-design/) | All-atom protein design using BoltzGen diffusion model. Side-chain aware design from the start, designing around small molecules or ligands. |
| [omics-chai-complex-prediction](skills/omics-chai-complex-prediction/) | Structure prediction using Chai-1 foundation model for protein-protein complexes, binder validation, and protein-small molecule interaction prediction. |
| [drug-rfdiffusion-backbone-design](skills/drug-rfdiffusion-backbone-design/) | Generate protein backbones using RFdiffusion diffusion model for de novo protein structure generation and binder scaffold design. |
| [drug-bindcraft-binder-design](skills/drug-bindcraft-binder-design/) | End-to-end binder design using BindCraft hallucination with built-in AF2 validation for production-quality binder campaigns. |
| [drug-protein-binder-method-selection](skills/drug-protein-binder-method-selection/) | Guidance for choosing the right protein binder design tool (BoltzGen, BindCraft, or RFdiffusion) and planning binder design campaigns. |
| [drug-proteinmpnn-sequence-design](skills/drug-proteinmpnn-sequence-design/) | Design protein sequences using ProteinMPNN inverse folding for RFdiffusion backbones, sequence redesign, and partial fixed-position design. |
| [drug-ligandmpnn-sequence-design](skills/drug-ligandmpnn-sequence-design/) | Ligand-aware protein sequence design using LigandMPNN for sequences around small molecules, enzyme active site design, and binding pocket optimization. |
| [drug-solublempnn-sequence-design](skills/drug-solublempnn-sequence-design/) | Solubility-optimized protein sequence design using SolubleMPNN for E. coli expression, reducing aggregation, and solubility optimization. |
| [omics-foldseek-structure-search](skills/omics-foldseek-structure-search/) | Structure similarity search with Foldseek for finding similar structures in PDB/AFDB databases, structural homology search, and evolutionary relationship discovery. |
| [omics-ipsae-interface-scoring](skills/omics-ipsae-interface-scoring/) | Binder design ranking using ipSAE (interprotein Score from Aligned Errors) for ranking binder designs and filtering BindCraft or RFdiffusion outputs. |
| [omics-pdb-structure-processing](skills/omics-pdb-structure-processing/) | Fetch and analyze protein structures from RCSB PDB by PDB ID, search for similar structures, prepare targets for binder design. |
| [sop-drug-protein-design](skills/sop-drug-protein-design/) | End-to-end guidance for protein design pipelines from project initiation to experimental validation. |
| [omics-protein-qc](skills/omics-protein-qc/) | Quality control metrics and filtering thresholds for protein design: pLDDT, PAE, ipTM for binding, expression, and structure evaluation. |
| [research-cell-free-expression-planning](skills/research-cell-free-expression-planning/) | Guidance for cell-free protein synthesis (CFPS) optimization, troubleshooting low yield/aggregation, and optimizing DNA template design. |
| [research-protein-binding-experiment-design](skills/research-protein-binding-experiment-design/) | Guidance for SPR and BLI binding characterization experiments, kinetics interpretation, and troubleshooting poor binding signal. |

</details>

### Single-Cell & Trajectory Analysis

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-scvelo-rna-velocity](skills/omics-scvelo-rna-velocity/) | RNA velocity analysis. Estimate cell state transitions from unspliced/spliced mRNA dynamics, infer trajectory directions, compute latent time, and identify driver genes in scRNA-seq data. |

</details>

### Phylogenetics & Network Analysis

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-phylogenetics](skills/omics-phylogenetics/) | Build and analyze phylogenetic trees using MAFFT, IQ-TREE 2, and FastTree. Evolutionary analysis, microbial genomics, viral phylodynamics, and molecular clock studies. |
| [research-networkx-network-analysis](skills/research-networkx-network-analysis/) | Network and graph analysis in Python. Biological network analysis, protein interaction networks, pathway graphs, community detection, and centrality measures. |
| [research-torch-geometric-analysis](skills/research-torch-geometric-analysis/) | Graph Neural Networks (PyG) for molecular property prediction, drug-target interaction modeling, and geometric deep learning on biological graphs. |

</details>

</details>

## ⚙️ ClawBio Pipelines

<details open>
<summary>Expand/Collapse this category</summary>

### Bioinformatics Orchestration & Pipelines (ClawBio)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-bioinformatics-task-routing](skills/research-bioinformatics-task-routing/) | Meta-agent routing bioinformatics requests to specialized sub-skills. Handles file type detection (VCF, FASTQ, BAM, PDB, h5ad), analysis planning, report generation, and reproducibility export. |
| [sop-omics-single-cell-analysis](skills/sop-omics-single-cell-analysis/) | Local Scanpy pipeline for single-cell RNA-seq QC, clustering, marker discovery, and two-group differential expression from raw-count .h5ad files. |
| [sop-omics-read-alignment-planning](skills/sop-omics-read-alignment-planning/) | Sequence QC, alignment, and BAM processing. Wraps FastQC, BWA/Bowtie2, SAMtools for automated read-to-BAM pipelines. |
| [omics-vcf-annotator](skills/omics-vcf-annotator/) | Annotate VCF variants with VEP, ClinVar, gnomAD frequencies, and ancestry-aware context. Generates prioritized variant reports. |
| [research-analysis-reproducibility](skills/research-analysis-reproducibility/) | Export bioinformatics analyses as reproducible bundles with Conda environment, Singularity container definition, and Nextflow pipeline. |
| [research-galaxy-tool-execution](skills/research-galaxy-tool-execution/) | Galaxy tool discovery, recommendation, and execution — 8,000+ bioinformatics tools from usegalaxy.org with multi-signal scoring and workflow suggestions. |

</details>

### Genomics, Ancestry & Pharmacogenomics (ClawBio)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-gwas-lookup](skills/omics-gwas-lookup/) | Federated variant lookup across 9 genomic databases: GWAS Catalog, Open Targets, PheWeb (UKB, FinnGen, BBJ), GTEx, eQTL Catalogue, and more. |
| [omics-pgs-catalog-score-calculation](skills/omics-pgs-catalog-score-calculation/) | Calculate polygenic risk scores from DTC genetic data (23andMe/AncestryDNA) using the PGS Catalog. |
| [omics-pharmgx-reporter](skills/omics-pharmgx-reporter/) | Pharmacogenomic report from DTC genetic data — 12 genes, 31 SNPs, 51 drugs with CPIC guidelines and personalized dosage cards. |
| [omics-clinpgx-guideline-query](skills/omics-clinpgx-guideline-query/) | Query the ClinPGx API for pharmacogenomic gene-drug data, clinical annotations, CPIC guidelines, and FDA drug labels. |
| [health-drug-photo](skills/health-drug-photo/) | Identify a medication from a packaging photo via Claude vision, then retrieve genotype-informed dosage guidance. |
| [omics-ancestry-pca-analysis](skills/omics-ancestry-pca-analysis/) | Ancestry decomposition PCA against the Simons Genome Diversity Project (345 samples, 164 global populations). |
| [omics-genome-compare](skills/omics-genome-compare/) | Compare genome to reference individuals and estimate ancestry composition via IBS and EM admixture. |
| [omics-population-representation-assessment](skills/omics-population-representation-assessment/) | Compute HEIM diversity and equity metrics from VCF or ancestry data. Generates heterozygosity, FST, PCA plots, and HEIM Equity Score with markdown reports. |
| [sop-omics-metagenomics-profiling](skills/sop-omics-metagenomics-profiling/) | Shotgun metagenomics profiling: taxonomy (Kraken2/Bracken), resistome (CARD/RGI), and functional pathways (HUMAnN3) from paired-end FASTQ. |
| [clinical-ukb-navigator](skills/clinical-ukb-navigator/) | Semantic search across UK Biobank's 12,000+ data fields and publications — find the right variables for your research question. |

</details>

### Structural Biology & Literature (ClawBio)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-protein-structure-planning](skills/omics-protein-structure-planning/) | Local protein structure prediction with AlphaFold, Boltz, or Chai. Compare structures, compute RMSD, visualize 3D models. |
| [evidence-literature-synthesis](skills/evidence-literature-synthesis/) | Search PubMed and bioRxiv, summarize papers with LLM, build citation graphs, and generate literature review sections. |
| [evidence-disease-semantic-comparison](skills/evidence-disease-semantic-comparison/) | Semantic Similarity Index for disease research literature using PubMedBERT embeddings. Compute research equity metrics (HEIM). |
| [research-labstep-record-query](skills/research-labstep-record-query/) | Interact with the Labstep electronic lab notebook API. Query experiments, protocols, resources, and inventory. |
| [health-genomic-profile-report](skills/health-genomic-profile-report/) | Generate structured bioinformatics analysis profile reports. |

</details>

</details>

## 🧠 BioOS Extended Suite

<details open>
<summary>Expand/Collapse this category</summary>

### BioOS Extended Bioinformatics Suite (mdbabumiamssm/LLMs-Universal-Life-Science-and-Clinical-Skills-)

#### Sequence & Alignment Tools

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-alignment-sorting](skills/omics-alignment-sorting/) | Sort SAM/BAM files by coordinate or name with samtools sort. |
| [omics-alignment-filtering](skills/omics-alignment-filtering/) | Filter alignments by flag, quality, region, or paired status. |
| [omics-alignment-indexing](skills/omics-alignment-indexing/) | Index BAM/CRAM files with samtools index for random access. |
| [omics-alignment-validation](skills/omics-alignment-validation/) | Validate alignment file integrity and detect truncated/corrupt files. |
| [omics-alignment-files-bam-statistics](skills/omics-alignment-files-bam-statistics/) | Compute alignment statistics: flagstat, idxstats, coverage depth. |
| [omics-sam-bam-basics](skills/omics-sam-bam-basics/) | Read, inspect, and manipulate SAM/BAM files with samtools/pysam. |
| [omics-duplicate-handling](skills/omics-duplicate-handling/) | Mark and remove PCR duplicates with Picard or samtools markdup. |
| [omics-pileup-generation](skills/omics-pileup-generation/) | Generate base-level pileup from BAM for variant calling and coverage. |
| [omics-reference-operations](skills/omics-reference-operations/) | Download, index, and manage reference genome FASTA files. |
| [omics-blast-searches](skills/omics-blast-searches/) | Run BLAST searches against local or remote databases for sequence homology. |
| [omics-local-blast](skills/omics-local-blast/) | Set up and run BLAST+ locally with custom databases. |
| [omics-entrez-search](skills/omics-entrez-search/) | Search NCBI Entrez databases (PubMed, gene, nucleotide, protein, SRA). |
| [omics-entrez-fetch](skills/omics-entrez-fetch/) | Fetch records from NCBI Entrez by accession or UID. |
| [omics-entrez-link](skills/omics-entrez-link/) | Retrieve linked records across NCBI Entrez databases. |
| [omics-uniprot-access](skills/omics-uniprot-access/) | Query UniProt for protein sequences, annotations, and cross-references. |
| [omics-geo-data](skills/omics-geo-data/) | Download and parse GEO datasets and series matrices. |
| [omics-sra-data](skills/omics-sra-data/) | Download raw sequencing data from NCBI SRA with fasterq-dump. |
| [omics-batch-downloads](skills/omics-batch-downloads/) | Batch download bioinformatics data from NCBI, EBI, Ensembl. |

</details>

#### Sequence Analysis

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-seq-objects](skills/omics-seq-objects/) | Work with BioPython sequence objects: SeqRecord, features, annotations. |
| [omics-sequence-properties](skills/omics-sequence-properties/) | Compute sequence properties: MW, pI, hydrophobicity, extinction coefficient. |
| [omics-sequence-similarity](skills/omics-sequence-similarity/) | Compute sequence similarity with pairwise alignment and percent identity. |
| [omics-sequence-slicing](skills/omics-sequence-slicing/) | Slice, extract, and manipulate subsequences from FASTA/FASTQ. |
| [omics-motif-search](skills/omics-motif-search/) | Search sequences for regulatory motifs using FIMO, MAST, or regex. |
| [omics-codon-usage](skills/omics-codon-usage/) | Analyze codon usage bias and optimize sequences for expression. |
| [omics-transcription-translation](skills/omics-transcription-translation/) | Transcribe and translate DNA sequences; handle genetic code variations. |
| [omics-reverse-complement](skills/omics-reverse-complement/) | Compute reverse complement and strand-aware sequence operations. |
| [omics-primer-design-primer-basics](skills/omics-primer-design-primer-basics/) | Design PCR primers with Primer3 for standard amplification. |
| [omics-primer-design-primer-validation](skills/omics-primer-design-primer-validation/) | Validate primer specificity by BLAST and thermodynamic analysis. |
| [omics-primer-design-qpcr-primers](skills/omics-primer-design-qpcr-primers/) | Design qPCR/RT-PCR primers with efficiency and specificity optimization. |
| [omics-restriction-sites](skills/omics-restriction-sites/) | Find restriction enzyme recognition sites in DNA sequences. |
| [omics-restriction-mapping](skills/omics-restriction-mapping/) | Create restriction maps and in silico digestion patterns. |
| [omics-restriction-fragment-analysis](skills/omics-restriction-fragment-analysis/) | Analyze restriction fragment patterns for cloning and gel prediction. |
| [omics-restriction-enzyme-selection](skills/omics-restriction-enzyme-selection/) | Select restriction enzymes for cloning based on cut sites and compatibility. |

</details>

#### Read Alignment

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-read-alignment-bwa-alignment](skills/omics-read-alignment-bwa-alignment/) | Align short reads to reference genome with BWA-MEM. |
| [omics-read-alignment-bowtie2-alignment](skills/omics-read-alignment-bowtie2-alignment/) | Align short reads with Bowtie2; local and end-to-end modes. |
| [omics-read-alignment-hisat2-alignment](skills/omics-read-alignment-hisat2-alignment/) | Splice-aware RNA-seq alignment with HISAT2. |
| [omics-read-alignment-star-alignment](skills/omics-read-alignment-star-alignment/) | High-speed STAR aligner for RNA-seq with junction detection. |

</details>

#### Genome Assembly

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-genome-assembly-long-read-assembly](skills/omics-genome-assembly-long-read-assembly/) | De novo assembly from ONT/PacBio long reads with Flye or Canu. |
| [omics-genome-assembly-hifi-assembly](skills/omics-genome-assembly-hifi-assembly/) | HiFi (CCS) read assembly with Hifiasm for high-accuracy genomes. |
| [omics-genome-assembly-short-read-assembly](skills/omics-genome-assembly-short-read-assembly/) | Illumina de novo assembly with SPAdes for metagenomes/bacteria/transcriptomes. |
| [omics-genome-assembly-metagenome-assembly](skills/omics-genome-assembly-metagenome-assembly/) | Metagenomic assembly: co-assembly, binning, MAG recovery. |
| [omics-genome-assembly-assembly-qc](skills/omics-genome-assembly-assembly-qc/) | Assess assembly quality with QUAST, BUSCO, and NGA50 metrics. |
| [omics-genome-assembly-assembly-polishing](skills/omics-genome-assembly-assembly-polishing/) | Polish assemblies with Medaka (ONT) or NextPolish (Illumina). |
| [omics-genome-assembly-scaffolding](skills/omics-genome-assembly-scaffolding/) | Scaffold contigs with Hi-C, optical mapping, or long reads. |
| [omics-genome-assembly-contamination-detection](skills/omics-genome-assembly-contamination-detection/) | Detect and remove contamination in assembled genomes. |

</details>

#### Genome Intervals & Annotation

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-genome-intervals-bed-file-basics](skills/omics-genome-intervals-bed-file-basics/) | Read, write, and filter BED files with pybedtools/bedtools. |
| [omics-genome-intervals-interval-arithmetic](skills/omics-genome-intervals-interval-arithmetic/) | Intersect, subtract, merge, and complement genomic intervals. |
| [omics-genome-intervals-proximity-operations](skills/omics-genome-intervals-proximity-operations/) | Find nearest features and compute distances between intervals. |
| [omics-genome-intervals-coverage-analysis](skills/omics-genome-intervals-coverage-analysis/) | Compute read depth coverage across genomic regions. |
| [omics-genome-intervals-bigwig-tracks](skills/omics-genome-intervals-bigwig-tracks/) | Create and query BigWig signal tracks from BAM/bedGraph. |
| [omics-genome-intervals-gtf-gff-handling](skills/omics-genome-intervals-gtf-gff-handling/) | Parse and manipulate GTF/GFF annotation files. |
| [omics-bedgraph-handling](skills/omics-bedgraph-handling/) | Process bedGraph coverage files: arithmetic, normalization, conversion. |

</details>

#### RNA Quantification

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-rna-quantification-featurecounts-counting](skills/omics-rna-quantification-featurecounts-counting/) | Count reads per gene with featureCounts from subread package. |
| [omics-rna-quantification-alignment-free-quant](skills/omics-rna-quantification-alignment-free-quant/) | Pseudo-alignment quantification with Salmon or Kallisto. |
| [omics-rna-quantification-tximport-workflow](skills/omics-rna-quantification-tximport-workflow/) | Import Salmon/Kallisto quantification into R/DESeq2 with tximport. |
| [omics-rna-quantification-count-matrix-qc](skills/omics-rna-quantification-count-matrix-qc/) | QC count matrices: library size, zero inflation, gene detection rates. |
| [omics-expression-matrix-counts-ingest](skills/omics-expression-matrix-counts-ingest/) | Load and validate count matrices from multiple quantification tools. |
| [omics-expression-matrix-gene-id-mapping](skills/omics-expression-matrix-gene-id-mapping/) | Map between Ensembl, Entrez, HGNC, and gene symbol identifiers. |
| [omics-expression-matrix-metadata-joins](skills/omics-expression-matrix-metadata-joins/) | Join sample metadata to expression matrices for downstream analysis. |
| [omics-expression-matrix-sparse-handling](skills/omics-expression-matrix-sparse-handling/) | Handle sparse count matrices efficiently with scipy sparse formats. |

</details>

#### Epitranscriptomics & CLIP-seq

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-epitranscriptomics-merip-preprocessing](skills/omics-epitranscriptomics-merip-preprocessing/) | Preprocess MeRIP-seq data for m6A methylation analysis. |
| [omics-epitranscriptomics-m6a-peak-calling](skills/omics-epitranscriptomics-m6a-peak-calling/) | Call m6A peaks from MeRIP-seq with exomePeak2 or MACS2. |
| [omics-epitranscriptomics-m6anet-analysis](skills/omics-epitranscriptomics-m6anet-analysis/) | Nanopore direct RNA m6A detection with m6Anet deep learning. |
| [omics-epitranscriptomics-m6a-differential](skills/omics-epitranscriptomics-m6a-differential/) | Differential m6A methylation analysis between conditions. |
| [omics-epitranscriptomics-modification-visualization](skills/omics-epitranscriptomics-modification-visualization/) | Visualize RNA modification profiles and metagene plots. |
| [omics-clip-seq-clip-preprocessing](skills/omics-clip-seq-clip-preprocessing/) | Preprocess CLIP-seq/eCLIP data: adapter trimming, demultiplexing. |
| [omics-clip-seq-clip-alignment](skills/omics-clip-seq-clip-alignment/) | Align CLIP-seq reads with STAR; handle unique mappers. |
| [omics-clip-seq-clip-peak-calling](skills/omics-clip-seq-clip-peak-calling/) | Call RBP binding peaks from CLIP-seq with PureCLIP or MACS2. |
| [omics-clip-seq-binding-site-annotation](skills/omics-clip-seq-binding-site-annotation/) | Annotate CLIP-seq peaks with genomic features and RNA regions. |
| [omics-clip-seq-clip-motif-analysis](skills/omics-clip-seq-clip-motif-analysis/) | Discover RBP binding motifs from CLIP-seq peak sequences. |

</details>

#### Small RNA-seq

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-small-rna-seq-smrna-preprocessing](skills/omics-small-rna-seq-smrna-preprocessing/) | Preprocess small RNA-seq: adapter trimming, size selection. |
| [omics-small-rna-seq-mirdeep2-analysis](skills/omics-small-rna-seq-mirdeep2-analysis/) | Identify and quantify known/novel miRNAs with miRDeep2. |
| [omics-small-rna-seq-mirge3-analysis](skills/omics-small-rna-seq-mirge3-analysis/) | miRNA annotation and quantification with miRge3.0. |
| [omics-small-rna-seq-target-prediction](skills/omics-small-rna-seq-target-prediction/) | Predict miRNA target genes with TargetScan or miRDB. |
| [omics-small-rna-seq-differential-mirna](skills/omics-small-rna-seq-differential-mirna/) | Differential miRNA expression analysis with DESeq2/edgeR. |

</details>

#### Population Genetics & Phasing

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-population-genetics-plink-basics](skills/omics-population-genetics-plink-basics/) | PLINK2 for GWAS QC, LD pruning, and basic population genetics. |
| [omics-population-genetics-population-structure](skills/omics-population-genetics-population-structure/) | Population stratification with PCA, ADMIXTURE, and STRUCTURE. |
| [omics-population-genetics-linkage-disequilibrium](skills/omics-population-genetics-linkage-disequilibrium/) | Compute LD metrics (r², D') and LD decay analysis. |
| [omics-population-genetics-association-testing](skills/omics-population-genetics-association-testing/) | GWAS association testing with PLINK, BOLT-LMM, or SAIGE. |
| [omics-population-genetics-scikit-allel-analysis](skills/omics-population-genetics-scikit-allel-analysis/) | Population genetics analysis with scikit-allel: diversity, Fst, haplotypes. |
| [omics-population-genetics-selection-statistics](skills/omics-population-genetics-selection-statistics/) | Detect natural selection signatures: iHS, XP-EHH, Tajima's D. |
| [omics-phasing-imputation-haplotype-phasing](skills/omics-phasing-imputation-haplotype-phasing/) | Phase variants with SHAPEIT4 or BEAGLE. |
| [omics-phasing-imputation-genotype-imputation](skills/omics-phasing-imputation-genotype-imputation/) | Impute missing genotypes using Michigan/TOPMed imputation servers. |
| [omics-phasing-imputation-reference-panels](skills/omics-phasing-imputation-reference-panels/) | Select and prepare reference panels (1KGP, HRC, TOPMed) for imputation. |
| [omics-phasing-imputation-imputation-qc](skills/omics-phasing-imputation-imputation-qc/) | QC imputed data: R² filter, INFO score, allele concordance. |

</details>

#### Comparative Genomics & Phylogenetics

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-comparative-genomics-ortholog-inference](skills/omics-comparative-genomics-ortholog-inference/) | Infer orthologs and paralogs with OrthoFinder or OMA. |
| [omics-comparative-genomics-synteny-analysis](skills/omics-comparative-genomics-synteny-analysis/) | Detect syntenic blocks between genomes with MCScan or SyRI. |
| [omics-comparative-genomics-positive-selection](skills/omics-comparative-genomics-positive-selection/) | Test for positive selection with PAML, HyPhy, or dN/dS ratios. |
| [omics-comparative-genomics-hgt-detection](skills/omics-comparative-genomics-hgt-detection/) | Detect horizontal gene transfer events in microbial genomes. |
| [omics-comparative-genomics-ancestral-reconstruction](skills/omics-comparative-genomics-ancestral-reconstruction/) | Reconstruct ancestral sequences and traits with ASR methods. |
| [omics-phylo-tree-io](skills/omics-phylo-tree-io/) | Read/write phylogenetic trees in Newick, Nexus, PhyloXML formats. |
| [omics-phylo-modern-tree-inference](skills/omics-phylo-modern-tree-inference/) | Maximum likelihood tree inference with IQ-TREE 2 or FastTree. |
| [omics-phylo-tree-manipulation](skills/omics-phylo-tree-manipulation/) | Root, prune, reorder, and annotate phylogenetic trees. |
| [omics-phylo-tree-visualization](skills/omics-phylo-tree-visualization/) | Visualize trees with iTOL, ETE3, or ggtree. |
| [omics-phylo-distance-calculations](skills/omics-phylo-distance-calculations/) | Compute pairwise phylogenetic distances and diversity metrics. |

</details>

#### Systems Biology & Metabolic Modeling

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-systems-biology-flux-balance-analysis](skills/omics-systems-biology-flux-balance-analysis/) | Flux balance analysis (FBA) with COBRApy for metabolic network modeling. |
| [omics-systems-biology-metabolic-reconstruction](skills/omics-systems-biology-metabolic-reconstruction/) | Reconstruct genome-scale metabolic models from genome annotations. |
| [omics-systems-biology-gene-essentiality](skills/omics-systems-biology-gene-essentiality/) | Predict essential genes by single gene knockouts in metabolic models. |
| [omics-systems-biology-context-specific-models](skills/omics-systems-biology-context-specific-models/) | Build context-specific metabolic models from expression data (GIMME, iMAT). |
| [omics-systems-biology-model-curation](skills/omics-systems-biology-model-curation/) | Curate SBML metabolic models: mass/charge balance, gap filling. |

</details>

#### Experimental Design & Reporting

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-experimental-design-sample-size](skills/omics-experimental-design-sample-size/) | Power analysis and sample size calculation for omics experiments. |
| [omics-experimental-design-power-analysis](skills/omics-experimental-design-power-analysis/) | Statistical power analysis for detecting differential signals. |
| [omics-experimental-design-batch-design](skills/omics-experimental-design-batch-design/) | Optimize sample batching to minimize confounding with ComBat design. |
| [omics-experimental-design-multiple-testing](skills/omics-experimental-design-multiple-testing/) | Multiple testing correction: Bonferroni, BH/FDR, q-values. |
| [omics-machine-learning-omics-classifiers](skills/omics-machine-learning-omics-classifiers/) | Train classifiers on omics data: random forest, SVM, XGBoost. |
| [omics-machine-learning-biomarker-discovery](skills/omics-machine-learning-biomarker-discovery/) | Identify biomarkers from omics data with LASSO, elastic net, SHAP. |
| [omics-machine-learning-model-validation](skills/omics-machine-learning-model-validation/) | Cross-validation, AUC-ROC, calibration, and permutation testing. |
| [omics-machine-learning-survival-analysis](skills/omics-machine-learning-survival-analysis/) | Survival ML: RSF, DeepSurv, CoxBoost from omics features. |
| [omics-machine-learning-atlas-mapping](skills/omics-machine-learning-atlas-mapping/) | Map query cells to reference atlases with scANVI or Symphony. |
| [omics-machine-learning-prediction-explanation](skills/omics-machine-learning-prediction-explanation/) | Explain omics ML predictions with SHAP and feature importance. |
| [research-reporting-automated-qc-reports](skills/research-reporting-automated-qc-reports/) | Generate automated MultiQC-style reports for omics pipelines. |
| [research-reporting-jupyter-reports](skills/research-reporting-jupyter-reports/) | Create Jupyter notebook reports with reproducible analysis code. |
| [research-reporting-rmarkdown-reports](skills/research-reporting-rmarkdown-reports/) | Render Rmarkdown reports with integrated plots and statistics. |
| [research-reporting-quarto-reports](skills/research-reporting-quarto-reports/) | Build Quarto multi-format reports (HTML/PDF) from analysis code. |
| [research-reporting-figure-export](skills/research-reporting-figure-export/) | Export publication-quality figures in PDF/SVG/TIFF at specified DPI. |
| [omics-research-tools-biomarker-signature-studio](skills/omics-research-tools-biomarker-signature-studio/) | Build, validate, and visualize multi-omic biomarker signatures. |

</details>

#### End-to-End Workflow Pipelines

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [sop-omics-fastq-to-variants](skills/sop-omics-fastq-to-variants/) | Complete FASTQ → alignment → variant calling pipeline. |
| [sop-omics-rnaseq-to-de](skills/sop-omics-rnaseq-to-de/) | RNA-seq → alignment → counts → DESeq2 differential expression. |
| [sop-omics-scrnaseq-pipeline](skills/sop-omics-scrnaseq-pipeline/) | Single-cell RNA-seq end-to-end: Cell Ranger → Scanpy → clustering. |
| [sop-omics-atacseq-pipeline](skills/sop-omics-atacseq-pipeline/) | ATAC-seq: trimming → alignment → peak calling → differential. |
| [sop-omics-chipseq-pipeline](skills/sop-omics-chipseq-pipeline/) | ChIP-seq: alignment → peak calling → motif analysis → annotation. |
| [sop-omics-methylation-pipeline](skills/sop-omics-methylation-pipeline/) | WGBS/RRBS: bismark alignment → methylation calling → DMR detection. |
| [sop-omics-metagenomics-pipeline](skills/sop-omics-metagenomics-pipeline/) | Metagenomics: QC → classification → functional profiling → AMR. |
| [sop-omics-metabolomics-pipeline](skills/sop-omics-metabolomics-pipeline/) | LC-MS/GC-MS: preprocessing → annotation → statistical analysis. |
| [sop-omics-proteomics-pipeline](skills/sop-omics-proteomics-pipeline/) | DDA/DIA proteomics: search → quantification → differential abundance. |
| [sop-omics-gwas-pipeline](skills/sop-omics-gwas-pipeline/) | GWAS: QC → imputation → association → fine-mapping → annotation. |
| [sop-omics-somatic-variant-pipeline](skills/sop-omics-somatic-variant-pipeline/) | Tumor-normal somatic variant calling with GATK Mutect2/Strelka2. |
| [sop-omics-cnv-pipeline](skills/sop-omics-cnv-pipeline/) | Copy number variant detection: WGS/WES CNV calling and annotation. |
| [sop-omics-spatial-pipeline](skills/sop-omics-spatial-pipeline/) | Spatial transcriptomics: alignment → deconvolution → domain detection. |
| [sop-omics-multi-omics-pipeline](skills/sop-omics-multi-omics-pipeline/) | Multi-omics integration pipeline: MOFA, SNF, similarity network fusion. |
| [sop-omics-multiome-pipeline](skills/sop-omics-multiome-pipeline/) | 10x Multiome: joint scRNA-seq + scATAC-seq processing and integration. |
| [sop-omics-hic-pipeline](skills/sop-omics-hic-pipeline/) | Hi-C contact map generation, normalization, TAD/loop calling. |
| [sop-omics-neoantigen-pipeline](skills/sop-omics-neoantigen-pipeline/) | Neoantigen prediction: somatic variants → MHC binding → immunogenicity. |
| [sop-omics-microbiome-pipeline](skills/sop-omics-microbiome-pipeline/) | Microbiome: 16S/ITS amplicon or shotgun → diversity → differential. |
| [sop-omics-crispr-screen-pipeline](skills/sop-omics-crispr-screen-pipeline/) | CRISPR screen: guide counting → MAGeCK → hit calling → visualization. |
| [sop-omics-crispr-editing-pipeline](skills/sop-omics-crispr-editing-pipeline/) | CRISPR editing: amplicon sequencing → CRISPResso2 → outcome analysis. |
| [sop-omics-tcr-pipeline](skills/sop-omics-tcr-pipeline/) | TCR/BCR: V(D)J alignment → clonotype → repertoire analysis. |
| [sop-omics-riboseq-pipeline](skills/sop-omics-riboseq-pipeline/) | Ribo-seq: footprint alignment → periodicity → ORF detection. |
| [sop-omics-smrna-pipeline](skills/sop-omics-smrna-pipeline/) | Small RNA-seq: miRNA identification → quantification → DE analysis. |
| [sop-omics-merip-pipeline](skills/sop-omics-merip-pipeline/) | MeRIP-seq: m6A peak calling → differential → motif analysis. |
| [sop-omics-clip-pipeline](skills/sop-omics-clip-pipeline/) | CLIP-seq: peak calling → binding site annotation → motif discovery. |
| [sop-omics-imc-pipeline](skills/sop-omics-imc-pipeline/) | Imaging mass cytometry: segmentation → phenotyping → spatial analysis. |
| [sop-omics-cytometry-pipeline](skills/sop-omics-cytometry-pipeline/) | Flow/mass cytometry: QC → gating → clustering → differential. |
| [sop-omics-longread-sv-pipeline](skills/sop-omics-longread-sv-pipeline/) | Long-read structural variant calling and annotation pipeline. |
| [sop-omics-genome-assembly-pipeline](skills/sop-omics-genome-assembly-pipeline/) | De novo genome assembly: raw reads → assembly → QC → annotation. |
| [sop-omics-outbreak-pipeline](skills/sop-omics-outbreak-pipeline/) | Pathogen genomics: assembly → typing → phylodynamics → transmission. |
| [sop-omics-biomarker-pipeline](skills/sop-omics-biomarker-pipeline/) | Biomarker discovery: omics → feature selection → validation → report. |
| [sop-omics-metabolic-modeling-pipeline](skills/sop-omics-metabolic-modeling-pipeline/) | Metabolic model reconstruction → FBA → simulation → visualization. |
| [omics-splicing-pipeline](skills/omics-splicing-pipeline/) | Alternative splicing analysis: rMATS → PSI → differential → sashimi. |
| [omics-liquid-biopsy-pipeline](skills/omics-liquid-biopsy-pipeline/) | Liquid biopsy: cfDNA/ctDNA QC → mutation detection → TMB → MRD. |
| [research-workflow-management-snakemake-workflows](skills/research-workflow-management-snakemake-workflows/) | Create and manage Snakemake reproducible bioinformatics workflows. |
| [research-workflow-management-nextflow-pipelines](skills/research-workflow-management-nextflow-pipelines/) | Build and run Nextflow (DSL2) bioinformatics pipelines. |
| [research-workflow-management-cwl-workflows](skills/research-workflow-management-cwl-workflows/) | Write Common Workflow Language (CWL) portable workflow definitions. |
| [research-workflow-management-wdl-workflows](skills/research-workflow-management-wdl-workflows/) | Create WDL workflows for Terra/Cromwell bioinformatics execution. |
| [sop-omics-expression-to-pathways](skills/sop-omics-expression-to-pathways/) | End-to-end workflow from differential expression to GO/KEGG/Reactome enrichment and pathway visualization. |

</details>

#### Data Visualization (Bioinformatics)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-data-visualization-heatmaps-clustering](skills/research-data-visualization-heatmaps-clustering/) | Hierarchical clustering heatmaps with ComplexHeatmap or seaborn. |
| [research-data-visualization-volcano-customization](skills/research-data-visualization-volcano-customization/) | Customized volcano plots with ggplot2 or matplotlib for DE results. |
| [research-data-visualization-circos-plots](skills/research-data-visualization-circos-plots/) | Circular genome visualization with Circos or pycirclize. |
| [research-data-visualization-genome-browser-tracks](skills/research-data-visualization-genome-browser-tracks/) | Generate genome browser tracks and IGV sessions from BAM/BigWig. |
| [research-data-visualization-genome-tracks](skills/research-data-visualization-genome-tracks/) | Multi-panel genome track plots with pyGenomeTracks. |
| [research-data-visualization-ggplot2-fundamentals](skills/research-data-visualization-ggplot2-fundamentals/) | R ggplot2 for publication-quality genomics and omics figures. |
| [research-data-visualization-interactive-visualization](skills/research-data-visualization-interactive-visualization/) | Interactive omics visualizations with Plotly, Bokeh, or shiny. |
| [research-data-visualization-upset-plots](skills/research-data-visualization-upset-plots/) | UpSet plots for multi-set intersection visualization. |
| [research-data-visualization-multipanel-figures](skills/research-data-visualization-multipanel-figures/) | Compose multipanel publication figures with cowplot or patchwork. |
| [research-data-visualization-color-palettes](skills/research-data-visualization-color-palettes/) | Scientific color palettes: colorblind-safe, perceptually uniform, diverging. |
| [research-data-visualization-specialized-omics-plots](skills/research-data-visualization-specialized-omics-plots/) | Specialized plots: lollipop (mutations), circomap, oncoprint. |

</details>

### Oncology & Precision Medicine Agents (BioOS)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [clinical-oncology-evidence-integration](skills/clinical-oncology-evidence-integration/) | Autonomous oncology research agent: literature mining, trial matching, biomarker analysis, and treatment hypothesis generation. |
| [clinical-precision-oncology](skills/clinical-precision-oncology/) | Precision oncology: tumor molecular profiling → actionable alterations → treatment recommendations. |
| [omics-pan-cancer-integration](skills/omics-pan-cancer-integration/) | Pan-cancer multi-omics integration for cross-cancer pattern discovery and driver identification. |
| [clinical-tumor-clonal-evolution](skills/clinical-tumor-clonal-evolution/) | Model tumor clonal evolution: phylogenetic trees, clonal dynamics, branching patterns from somatic variants. |
| [clinical-tumor-heterogeneity](skills/clinical-tumor-heterogeneity/) | Analyze intratumoral heterogeneity from bulk and single-cell sequencing data. |
| [clinical-tumor-mutational-burden](skills/clinical-tumor-mutational-burden/) | Compute TMB and assess its predictive value for immunotherapy response. |
| [omics-chromosomal-instability-analysis](skills/omics-chromosomal-instability-analysis/) | Quantify chromosomal instability (CIN) from copy number and SV data. |
| [omics-cancer-metabolism-analysis](skills/omics-cancer-metabolism-analysis/) | Analyze tumor metabolic reprogramming from transcriptomic and metabolomic data. |
| [omics-liquid-biopsy-analysis](skills/omics-liquid-biopsy-analysis/) | Comprehensive liquid biopsy analytics: ctDNA detection, MRD monitoring, treatment response. |
| [omics-ctdna-dynamics-analysis](skills/omics-ctdna-dynamics-analysis/) | Track ctDNA dynamics for minimal residual disease detection and treatment monitoring. |
| [omics-ctdna-residual-disease-analysis](skills/omics-ctdna-residual-disease-analysis/) | Ultra-sensitive MRD detection from deep sequencing with error suppression. |
| [omics-homologous-recombination-analysis](skills/omics-homologous-recombination-analysis/) | Homologous recombination deficiency (HRD) analysis for PARP inhibitor response prediction. |
| [imaging-computational-pathology](skills/imaging-computational-pathology/) | Computational pathology: WSI analysis, tissue segmentation, histological feature extraction. |
| [imaging-multimodal-radpath-fusion](skills/imaging-multimodal-radpath-fusion/) | Fuse radiology and pathology imaging for integrated cancer phenotyping. |
| [imaging-radiomics-pathomics-fusion](skills/imaging-radiomics-pathomics-fusion/) | Extract radiomic and pathomic features and integrate for predictive modeling. |
| [clinical-radiology-report-explanation](skills/clinical-radiology-report-explanation/) | AI-assisted radiology report generation from imaging findings. |
| [drug-organoid-response-analysis](skills/drug-organoid-response-analysis/) | Analyze drug response in patient-derived organoids for personalized therapy prediction. |
| [drug-pdx-response-analysis](skills/drug-pdx-response-analysis/) | Patient-derived xenograft model analysis for drug efficacy and biomarker discovery. |
| [omics-deep-visual-proteomics](skills/omics-deep-visual-proteomics/) | Deep visual proteomics: spatial proteomic analysis from laser-capture microdissection MS data. |
| [omics-exosome-cargo-analysis](skills/omics-exosome-cargo-analysis/) | Extracellular vesicle and exosome analysis: cargo profiling and biomarker discovery. |
| [omics-microbiome-cancer-association](skills/omics-microbiome-cancer-association/) | Tumor microbiome analysis and its role in cancer progression and immunotherapy response. |
| [omics-fragment-analysis](skills/omics-fragment-analysis/) | Analyze cfDNA fragment size distributions and fragmentomics features (FinaleToolkit/Griffin) for cancer detection and tissue-of-origin assessment. |

</details>

### Hematology & Blood Disorders (BioOS)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [clinical-myeloma-residual-disease-assessment](skills/clinical-myeloma-residual-disease-assessment/) | Multiple myeloma MRD assessment from flow cytometry and NGS data. |
| [clinical-mpn-progression-monitoring](skills/clinical-mpn-progression-monitoring/) | Myeloproliferative neoplasm progression monitoring from serial molecular data. |
| [clinical-mpn-research-assistant](skills/clinical-mpn-research-assistant/) | Research assistant for myeloproliferative neoplasms: literature, mutation analysis, treatment. |
| [imaging-bone-marrow-ai](skills/imaging-bone-marrow-ai/) | Bone marrow analysis: blast counting, immunophenotyping, disease classification. |
| [research-hemoglobinopathy-analysis](skills/research-hemoglobinopathy-analysis/) | Hemoglobin variant analysis, sickle cell, and thalassemia genotype-phenotype assessment. |
| [omics-chip-clonal-hematopoiesis](skills/omics-chip-clonal-hematopoiesis/) | Clonal hematopoiesis of indeterminate potential (CHIP) variant detection and risk assessment. |
| [clinical-coagulation-thrombosis](skills/clinical-coagulation-thrombosis/) | Coagulation pathway analysis, thrombophilia assessment, anticoagulation guidance. |

</details>

### Immunology & Cell Therapy (BioOS)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [drug-cart-design-optimization](skills/drug-cart-design-optimization/) | Optimize CAR-T cell construct design: scFv selection, linker, co-stimulatory domain. |
| [drug-armored-cart-design](skills/drug-armored-cart-design/) | Design armored CAR-T cells with cytokine payloads and resistance mechanisms. |
| [omics-tcell-exhaustion-analysis](skills/omics-tcell-exhaustion-analysis/) | Analyze T cell exhaustion from scRNA-seq and ATAC-seq data. |
| [drug-nk-cell-therapy-planning](skills/drug-nk-cell-therapy-planning/) | NK cell therapy design: receptor engineering, expansion protocols, persistence. |
| [omics-tcr-pmhc-prediction](skills/omics-tcr-pmhc-prediction/) | Predict TCR-pMHC binding affinity and selectivity for TCR therapy design. |
| [omics-tcr-repertoire-analysis](skills/omics-tcr-repertoire-analysis/) | TCR repertoire analysis: V(D)J usage, clonotype dynamics, antigen specificity. |
| [drug-immune-checkpoint-combination-planning](skills/drug-immune-checkpoint-combination-planning/) | Predict optimal immune checkpoint combination strategies from tumor immune microenvironment. |
| [omics-tme-immune-profiling](skills/omics-tme-immune-profiling/) | Tumor microenvironment immune profiling: cell type deconvolution and spatial mapping. |
| [omics-cytokine-storm-analysis](skills/omics-cytokine-storm-analysis/) | Cytokine storm detection, severity scoring, and intervention modeling. |

</details>

### Single-Cell & Spatial Agents (BioOS)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [omics-cellagent-cell-annotation](skills/omics-cellagent-cell-annotation/) | AI-driven single-cell cluster annotation using marker gene databases. |
| [omics-universal-single-cell-annotator](skills/omics-universal-single-cell-annotator/) | Universal scRNA-seq annotator using foundation models and multi-reference integration. |
| [omics-scfoundation-model](skills/omics-scfoundation-model/) | Single-cell foundation model inference (scFoundation/scGPT) for zero-shot annotation. |
| [omics-rna-velocity](skills/omics-rna-velocity/) | RNA velocity analysis with scVelo for trajectory and fate decision inference. |
| [omics-spatial-transcriptomics](skills/omics-spatial-transcriptomics/) | End-to-end spatial transcriptomics analysis: QC, deconvolution, domain detection. |
| [omics-spatial-transcriptomics-analysis](skills/omics-spatial-transcriptomics-analysis/) | Spatial transcriptomics analysis with Squidpy and SpatialDE. |
| [omics-spatial](skills/omics-spatial/) | Spatial omics agent: integrate spatial data with imaging, protein, and genomic layers. |
| [omics-nicheformer-spatial](skills/omics-nicheformer-spatial/) | Spatial niche analysis with Nicheformer foundation model for tissue microenvironment. |
| [omics-spatial-epigenomics](skills/omics-spatial-epigenomics/) | Spatial epigenomics analysis: spatially resolved chromatin accessibility and gene regulation. |
| [omics-single-cell-integration-guide](skills/omics-single-cell-integration-guide/) | General single-cell bioinformatics: clustering, trajectory, cell communication. |
| [omics-scrna-qc](skills/omics-scrna-qc/) | Single-cell RNA-seq quality control: doublet removal, ambient RNA, filtering thresholds. |
| [omics-single-cell-interactive-exploration](skills/omics-single-cell-interactive-exploration/) | Computational biology exploration agent for multi-omics dataset analysis. |
| [omics-simo-multiomics-integration](skills/omics-simo-multiomics-integration/) | Single-cell multi-omics integration with SIMO/MOFA+ for joint embedding. |
| [omics-epigenomics-methylgpt](skills/omics-epigenomics-methylgpt/) | Epigenomics and DNA methylation analysis with MethylGPT-inspired approaches. |
| [sop-omics-biomaster-analysis](skills/sop-omics-biomaster-analysis/) | BioMaster workflow orchestration for end-to-end bioinformatics analyses. |

</details>

### Drug Discovery & Design (BioOS)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [drug-agentd-molecule-discovery](skills/drug-agentd-molecule-discovery/) | AgentD autonomous drug discovery: target identification, hit finding, ADMET optimization. |
| [drug-chematagent-drug-discovery](skills/drug-chematagent-drug-discovery/) | CheMatAgent: chemistry-aware drug design with retrosynthesis and property optimization. |
| [drug-chemcrow-drug-discovery](skills/drug-chemcrow-drug-discovery/) | ChemCrow drug discovery toolkit: web search, Python, chemical tools integration. |
| [drug-medea-target-planning](skills/drug-medea-target-planning/) | MEDEA therapeutic discovery: multimodal evidence aggregation for target-disease validation. |
| [drug-molecule-evolution](skills/drug-molecule-evolution/) | Directed molecular evolution: generative models for compound optimization and library design. |
| [drug-molecular-glue-discovery-planning](skills/drug-molecular-glue-discovery-planning/) | Molecular glue discovery: induced proximity degraders and ternary complex stabilizers. |
| [drug-protac-design](skills/drug-protac-design/) | PROTAC design: E3 ligase ligand selection, linker optimization, ternary complex modeling. |
| [drug-tpd-ternary-complex](skills/drug-tpd-ternary-complex/) | Targeted protein degradation ternary complex modeling and cooperativity prediction. |
| [drug-mage-antibody-generation](skills/drug-mage-antibody-generation/) | MAGE antibody generator: sequence design, humanization, affinity maturation. |
| [drug-antibody-sequence-design](skills/drug-antibody-sequence-design/) | Antibody design: epitope mapping, CDR engineering, bispecific construction. |
| [drug-aav-vector-design](skills/drug-aav-vector-design/) | AAV vector design: capsid selection, promoter optimization, payload capacity. |
| [omics-protein-structure-prediction](skills/omics-protein-structure-prediction/) | Protein structure prediction with AlphaFold3, ESMFold, or Boltz with comparison. |
| [omics-crispr-guide-design](skills/omics-crispr-guide-design/) | CRISPR guide RNA design with on-target scoring and off-target minimization. |
| [omics-crispr-offtarget-predictor](skills/omics-crispr-offtarget-predictor/) | Predict CRISPR Cas9/Cas12 off-target sites genome-wide with CRISPOR/Cas-OFFinder. |
| [drug-chemical-property-lookup](skills/drug-chemical-property-lookup/) | Look up chemical properties from PubChem, ChEMBL, DrugBank by name/SMILES. |
| [drug-chemical-synthesis-planning](skills/drug-chemical-synthesis-planning/) | General chemistry agent for synthesis planning, reaction prediction, and property calculation. |
| [omics-cryoem-ai-drug-design](skills/omics-cryoem-ai-drug-design/) | AI-guided drug design from cryo-EM structures: binding site analysis and docking. |
| [omics-time-resolved-cryoem](skills/omics-time-resolved-cryoem/) | Time-resolved cryo-EM analysis for dynamic structural biology. |
| [omics-cnv-caller](skills/omics-cnv-caller/) | Specialized CNV detection agent integrating multiple callers with ensemble scoring. |
| [omics-popeve-variant-predictor](skills/omics-popeve-variant-predictor/) | Variant pathogenicity prediction using EVE population-based evolutionary models. |
| [omics-varcadd-pathogenicity](skills/omics-varcadd-pathogenicity/) | VARCADD pathogenicity scoring for coding variants from structure and evolution. |
| [omics-variant-interpretation-acmg](skills/omics-variant-interpretation-acmg/) | ACMG/AMP variant interpretation with evidence-based classification framework. |
| [omics-gene-panel-design](skills/omics-gene-panel-design/) | Design targeted gene panels for clinical or research sequencing applications. |
| [omics-pharmacogenomics](skills/omics-pharmacogenomics/) | Pharmacogenomics analysis: variant-drug interaction prediction and dosing recommendations. |
| [omics-multi-ancestry-prs](skills/omics-multi-ancestry-prs/) | Multi-ancestry polygenic risk score computation with ancestry-specific weighting. |
| [omics-prs-net-deep-learning](skills/omics-prs-net-deep-learning/) | Deep learning PRS prediction with PRSnet for complex traits. |
| [omics-cellfree-rna](skills/omics-cellfree-rna/) | Cell-free RNA analysis: plasma cfRNA profiling for liquid biopsy diagnostics. |
| [omics-long-read-sequencing](skills/omics-long-read-sequencing/) | Long-read sequencing analysis: SV calling, methylation, isoform discovery, assembly. |
| [research-bayesian-optimization](skills/research-bayesian-optimization/) | Bayesian optimization for experimental design and hyperparameter tuning in biomedical research. |

</details>

### Clinical AI & Healthcare (BioOS)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [clinical-ehr-question-answering](skills/clinical-ehr-question-answering/) | EHR clinical assistant: note summarization, structured data extraction, clinical decision support. |
| [clinical-note-summarization](skills/clinical-note-summarization/) | Summarize clinical notes into structured SOAP format with key findings. |
| [clinical-nlp-entity-extraction](skills/clinical-nlp-entity-extraction/) | Extract clinical entities (diagnoses, medications, procedures) from unstructured text. |
| [clinical-ehr-fhir-integration](skills/clinical-ehr-fhir-integration/) | EHR-FHIR integration: HL7 FHIR resource creation, querying, and workflow automation. |
| [research-fhir-resource-generation](skills/research-fhir-resource-generation/) | FHIR API development: build SMART on FHIR apps and FHIR resource endpoints. |
| [clinical-digital-twin-clinical](skills/clinical-digital-twin-clinical/) | Create patient digital twins for treatment simulation and outcome prediction. |
| [clinical-trial-eligibility](skills/clinical-trial-eligibility/) | Assess patient eligibility for clinical trials from EHR data and trial criteria. |
| [clinical-trialgpt-matching](skills/clinical-trialgpt-matching/) | TrialGPT patient-to-trial matching with eligibility assessment from clinical notes. |
| [health-wearable-trend-analysis](skills/health-wearable-trend-analysis/) | Analyze wearable sensor data: activity, sleep, HRV, ECG for health monitoring. |
| [imaging-multimodal-medical-imaging](skills/imaging-multimodal-medical-imaging/) | Multimodal medical imaging analysis: CT, MRI, PET fusion and segmentation. |
| [clinical-prior-authorization-drafting](skills/clinical-prior-authorization-drafting/) | Prior authorization workflow assistant for insurance approval processes. |
| [clinical-care-message-routing](skills/clinical-care-message-routing/) | Care coordination agent: multi-disciplinary team communication and care plan management. |
| [clinical-insurance-appeal-drafting](skills/clinical-insurance-appeal-drafting/) | Insurance claims appeals: documentation preparation and denial reasoning analysis. |
| [clinical-lab-result-interpretation](skills/clinical-lab-result-interpretation/) | Lab result interpretation: reference ranges, trend analysis, critical value alerts. |
| [drug-interaction-checker](skills/drug-interaction-checker/) | Check drug-drug interactions from patient medication lists with severity scoring. |
| [research-regulatory-drafter](skills/research-regulatory-drafter/) | Draft regulatory submissions: FDA, EMA, ICH document preparation. |
| [research-regulatory-drafting](skills/research-regulatory-drafting/) | Regulatory writing and document structuring for medical device/drug submissions. |
| [research-biomedical-data-analysis](skills/research-biomedical-data-analysis/) | Comprehensive biomedical data analysis: statistics, visualization, and interpretation. |
| [research-data-visualization-biomedical](skills/research-data-visualization-biomedical/) | Biomedical-specific data visualization: clinical trial plots, survival curves, forest plots. |

</details>

### Research Infrastructure & Agents (BioOS)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-biomni-local-workflow](skills/research-biomni-local-workflow/) | BioMni general biomedical agent for flexible multi-step research tasks. |
| [research-biomni-task-planning](skills/research-biomni-task-planning/) | BioMni research-focused agent with literature, database, and analysis integration. |
| [research-biokernel-task-routing](skills/research-biokernel-task-routing/) | BioKernel: unified computational kernel for bioinformatics tool orchestration. |
| [evidence-biomcp-search](skills/evidence-biomcp-search/) | BioMCP: Model Context Protocol server for bioinformatics tool access. |
| [omics-mcpmed-bioinformatics-server](skills/omics-mcpmed-bioinformatics-server/) | MCP server providing medical bioinformatics tool access to agents. |
| [research-kragen-knowledge-graph](skills/research-kragen-knowledge-graph/) | KRAGEN knowledge graph for biomedical entity relationships and reasoning. |
| [evidence-leads-literature-mining](skills/evidence-leads-literature-mining/) | LEADS literature mining: automated extraction of biological findings from papers. |
| [evidence-knowledge-synthesis](skills/evidence-knowledge-synthesis/) | Synthesize knowledge from multiple biomedical sources into structured summaries. |
| [evidence-research-task-coordination](skills/evidence-research-task-coordination/) | Multi-agent swarm for deep scientific research with parallel literature synthesis. |
| [evidence-research-literature](skills/evidence-research-literature/) | Research literature management: search, organize, and synthesize scientific papers. |
| [research-enterprise-search-strategy](skills/research-enterprise-search-strategy/) | Design systematic search strategies for scientific literature and databases. |
| [research-scientific-manuscript](skills/research-scientific-manuscript/) | Scientific manuscript writing and revision with journal-specific formatting. |
| [omics-cellular-senescence-analysis](skills/omics-cellular-senescence-analysis/) | Cellular senescence analysis: marker scoring, SASP profiling, tissue aging assessment. |
| [sop-omics-ngs-analysis](skills/sop-omics-ngs-analysis/) | Next-generation sequencing data analysis orchestration and QC. |
| [research-opentrons-protocol-generation](skills/research-opentrons-protocol-generation/) | Opentrons liquid handler protocol design for automated lab workflows. |
| [research-virtual-lab-planning](skills/research-virtual-lab-planning/) | Virtual lab agent for in silico experiment simulation and protocol optimization. |
| [research-data-visualization-expert](skills/research-data-visualization-expert/) | Expert data visualization for complex scientific and clinical datasets. |
| [sop-omics-lobster-analysis](skills/sop-omics-lobster-analysis/) | Run bioinformatics analyses via Lobster AI: scRNA-seq, bulk RNA-seq, literature mining, dataset discovery, QC, and visualization. |

</details>

</details>

## 📊 Data Science & Tools

<details open>
<summary>Expand/Collapse this category</summary>

### Statistics & Data Analysis

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [clinical-statistical-analysis](skills/clinical-statistical-analysis/) | Statistical analysis toolkit. Hypothesis tests (t-test, ANOVA, chi-square), regression, correlation, Bayesian stats, power analysis, assumption checks, APA reporting. |
| [research-statsmodels-statistical-modeling](skills/research-statsmodels-statistical-modeling/) | Statistical modeling: OLS, GLM, logistic, ARIMA, time series, hypothesis tests, diagnostics, AIC/BIC, for rigorous statistical inference. |
| [research-pymc-bayesian-modeling](skills/research-pymc-bayesian-modeling/) | Bayesian modeling with PyMC. Build hierarchical models, MCMC (NUTS), variational inference, LOO/WAIC comparison, posterior checks, for probabilistic programming. |
| [research-simpy-event-simulation](skills/research-simpy-event-simulation/) | Process-based discrete-event simulation for clinical systems: queues, resources, time-based events. Useful for modeling hospital workflows and patient flow. |
| [research-exploratory-data-analysis](skills/research-exploratory-data-analysis/) | Comprehensive exploratory data analysis on scientific data files across 200+ file formats — structure, content, quality assessment, and visualization. |
| [clinical-data-stats-analysis](skills/clinical-data-stats-analysis/) | Statistical tests, hypothesis testing, correlation analysis, and multiple testing corrections using scipy and statsmodels (OmicVerse). |
| [research-data-transform](skills/research-data-transform/) | Transform, clean, reshape, and preprocess biological data using pandas and numpy (OmicVerse). |
| [research-data-viz-plots](skills/research-data-viz-plots/) | Create publication-quality plots and visualizations using matplotlib and seaborn (OmicVerse). |
| [research-scientific-visualization](skills/research-scientific-visualization/) | Create publication figures with matplotlib/seaborn/plotly. Multi-panel layouts, error bars, significance markers, colorblind-safe, PDF/EPS/TIFF export. |

</details>

### Lab Automation & Integration

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-opentrons-integration](skills/research-opentrons-integration/) | Lab automation platform for Flex/OT-2 robots. Write Protocol API v2 protocols, liquid handling, hardware modules (heater-shaker, thermocycler), labware management. |
| [research-pylabrobot-lab-automation](skills/research-pylabrobot-lab-automation/) | Laboratory automation toolkit for controlling liquid handlers, plate readers, pumps, heater shakers, incubators, centrifuges, and analytical equipment. |
| [research-benchling-integration](skills/research-benchling-integration/) | Benchling R&D platform integration. Access registry (DNA, proteins), inventory, ELN entries, workflows via API, build Benchling Apps, for lab data management automation. |
| [research-labarchive-integration](skills/research-labarchive-integration/) | Electronic lab notebook API integration. Access notebooks, manage entries/attachments, backup notebooks, integrate with Protocols.io/Jupyter/REDCap. |
| [research-protocolsio-integration](skills/research-protocolsio-integration/) | Integration with protocols.io API for managing scientific protocols — search, create, update, publish protocols, and manage protocol steps and reagents. |
| [research-instrument-data-to-allotrope](skills/research-instrument-data-to-allotrope/) | Convert laboratory instrument output files (PDF, CSV, Excel, TXT) to Allotrope Simple Model (ASM) JSON format for LIMS systems, data lakes, and downstream analysis. |

</details>

### Scientific Research & Writing

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-scientific-writing](skills/research-scientific-writing/) | Write scientific manuscripts in full paragraphs using a two-stage process: section outlines then full text. Covers all sections of research papers. |
| [clinical-scientific-critical-thinking](skills/clinical-scientific-critical-thinking/) | Evaluate research rigor. Assess methodology, experimental design, statistical validity, biases, confounding, evidence quality (GRADE, Cochrane ROB). |
| [research-scientific-brainstorming](skills/research-scientific-brainstorming/) | Research ideation partner. Generate hypotheses, explore interdisciplinary connections, challenge assumptions, develop methodologies, identify research gaps. |
| [evidence-hypothesis-generation](skills/evidence-hypothesis-generation/) | Generate testable hypotheses. Formulate from observations, design experiments, explore competing explanations, develop predictions, propose mechanisms. |
| [research-scientific-problem-selection](skills/research-scientific-problem-selection/) | Help scientists with research problem selection, project ideation, troubleshooting stuck projects, and strategic scientific decisions. |
| [research-peer-review](skills/research-peer-review/) | Systematic peer review toolkit. Evaluate methodology, statistics, design, reproducibility, ethics, figure integrity, reporting standards, for manuscript and grant review. |
| [evidence-citation-management](skills/evidence-citation-management/) | Comprehensive citation management. Search Google Scholar and PubMed for papers, extract accurate metadata, validate citations, generate BibTeX entries. |
| [research-grants](skills/research-grants/) | Write competitive research proposals for NSF, NIH, DOE, and DARPA. Agency-specific formatting, review criteria, budget preparation, broader impacts. |
| [evidence-research-lookup](skills/evidence-research-lookup/) | Look up current research using Perplexity's Sonar Pro Search or Sonar Reasoning Pro via OpenRouter. Automatically selects best model for the query complexity. |
| [research-biomni-tool-guidance](skills/research-biomni-tool-guidance/) | Autonomous biomedical AI agent framework for executing complex research tasks across genomics, drug discovery, molecular biology, and clinical analysis. |
| [clinical-treatment-plan-drafting](skills/clinical-treatment-plan-drafting/) | Generate concise (3-4 page) medical treatment plans in LaTeX/PDF format for all clinical specialties including general medicine, rehabilitation, mental health, and chronic disease. |

</details>

### Analyst Personas

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-biologist-analyst](skills/research-biologist-analyst/) | Expert biologist analyst persona for interpreting biological experiments, sequencing data, cell biology assays, and molecular biology research. |
| [drug-chemist-analyst](skills/drug-chemist-analyst/) | Expert chemist analyst persona for interpreting chemical data, synthesis routes, spectroscopic results, reaction mechanisms, and laboratory analyses. |
| [clinical-epidemiologist-analyst](skills/clinical-epidemiologist-analyst/) | Expert epidemiologist analyst persona for study design, cohort analysis, risk factor assessment, public health surveillance, and causal inference. |
| [clinical-psychologist-analyst](skills/clinical-psychologist-analyst/) | Expert psychologist analyst persona for behavioral data analysis, psychological assessment interpretation, clinical case formulation, and mental health research. |

</details>

### Public Health & Time Series

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-datacommons-statistics-query](skills/research-datacommons-statistics-query/) | Access public health statistics from Google Data Commons: disease prevalence, demographic data, health indicators across global sources. |
| [research-timesfm-forecasting](skills/research-timesfm-forecasting/) | Zero-shot time series forecasting with Google's TimesFM. For vital sign trends, health sensor data, and longitudinal health monitoring without custom model training. |
| [research-aeon-timeseries-analysis](skills/research-aeon-timeseries-analysis/) | Time series ML: classification, regression, clustering, anomaly detection, segmentation for temporal health data and sequential clinical measurements. |

</details>

### Scientific Literature & Reference Management

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [evidence-bgpt-paper-search](skills/evidence-bgpt-paper-search/) | Search scientific papers with BGPT MCP server. Returns 25+ structured fields per paper: methods, results, sample sizes, quality scores. For literature reviews and evidence synthesis. |
| [evidence-zotero-library-management](skills/evidence-zotero-library-management/) | Interact with Zotero reference libraries programmatically via Zotero Web API v3. Retrieve, create, update items, export citations, upload PDFs, and build research automation workflows. |
| [evidence-research-notebook-management](skills/evidence-research-notebook-management/) | Self-hosted NotebookLM alternative. Ingest PDFs, videos, web pages, documents; generate AI-powered notes; chat with research materials; supports 16+ AI providers. |

</details>

### Data Processing & Scientific Computing

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-dask-data-processing](skills/research-dask-data-processing/) | Distributed computing for larger-than-RAM genomics/omics datasets. Scale pandas/NumPy beyond memory, parallel file processing, distributed ML. |
| [research-polars-table-processing](skills/research-polars-table-processing/) | Fast in-memory DataFrame library (1-100GB). Faster pandas replacement for biomedical data ETL and analysis pipelines. |
| [research-vaex-table-processing](skills/research-vaex-table-processing/) | Out-of-core DataFrame operations for billions of rows. Fast statistics and visualization for large genomic and clinical datasets. |
| [research-zarr-array-storage](skills/research-zarr-array-storage/) | Chunked N-D arrays for cloud storage. Compressed arrays, parallel I/O, S3/GCS integration for large-scale omics data. |
| [research-pytorch-lightning-model-training](skills/research-pytorch-lightning-model-training/) | Organized PyTorch deep learning for biomedical AI: multi-GPU training, callbacks, logging, distributed training for clinical/genomic models. |

</details>

### Scientific Visualization & Communication

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-matplotlib-figure-generation](skills/research-matplotlib-figure-generation/) | Low-level plotting library for full customization. Publication-quality figures for scientific manuscripts and journals. |
| [research-seaborn-statistical-visualization](skills/research-seaborn-statistical-visualization/) | Statistical visualization with pandas integration. Box plots, violin plots, heatmaps, pair plots for biomedical data exploration. |
| [research-plotly-interactive-visualization](skills/research-plotly-interactive-visualization/) | Interactive visualization. Hover info, zoom, dashboards for exploratory biomedical analysis and presentations. |
| [research-infographics](skills/research-infographics/) | Create professional scientific infographics with iterative AI refinement. Supports 10 infographic types and 8 industry styles. |
| [research-scientific-schematics](skills/research-scientific-schematics/) | Publication-quality scientific diagrams: neural network architectures, biological pathways, system diagrams, flowcharts. |
| [research-scientific-slides](skills/research-scientific-slides/) | Build research presentation slide decks for conferences, seminars, thesis defenses. PowerPoint and LaTeX Beamer support. |
| [research-latex-posters](skills/research-latex-posters/) | Create professional research posters in LaTeX (beamerposter, tikzposter). Conference posters with multi-column layouts. |
| [research-pptx-posters](skills/research-pptx-posters/) | HTML/CSS research posters exportable to PDF or PPTX. Modern web-based poster design. |
| [research-markdown-mermaid-writing](skills/research-markdown-mermaid-writing/) | Scientific documentation with Markdown and 24 Mermaid diagram types. 9 document templates for scientific reports. |
| [research-paper-2-web](skills/research-paper-2-web/) | Convert academic papers to interactive websites, presentation videos, and conference posters (Paper2Web, Paper2Video, Paper2Poster). |

</details>

### Additional Scientific Tools

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-pymoo-multiobjective-optimization](skills/research-pymoo-multiobjective-optimization/) | Multi-objective optimization with PYMOO. Drug design parameter optimization, Pareto front analysis, evolutionary algorithms. |
| [research-document-markdown-conversion](skills/research-document-markdown-conversion/) | Convert documents (PDF, DOCX, PPTX, HTML, images) to Markdown for processing and analysis. |
| [evidence-perplexity-search](skills/evidence-perplexity-search/) | AI-powered search via Perplexity for real-time scientific information retrieval. |
| [research-geopandas-spatial-analysis](skills/research-geopandas-spatial-analysis/) | Geospatial data analysis with GeoPandas. Epidemiology mapping, disease distribution, spatial health analytics. |
| [research-hypogenic-hypothesis-generation](skills/research-hypogenic-hypothesis-generation/) | Automated hypothesis generation and testing on tabular datasets. Combine literature insights with data-driven hypothesis validation. |
| [research-pdf-text-extraction](skills/research-pdf-text-extraction/) | Advanced PDF processing: text extraction, table parsing, annotation, form filling. |
| [research-pdf-batch-processing](skills/research-pdf-batch-processing/) | Professional PDF processing with enhanced OCR, multi-column layout handling, and batch processing. |
| [research-pdf-form-processing](skills/research-pdf-form-processing/) | Anthropic-optimized PDF analysis for scientific and medical document comprehension. |
| [research-xlsx-formula-edit](skills/research-xlsx-formula-edit/) | Official Excel/XLSX skill for spreadsheet creation, analysis, and data management. |
| [research-docx-track-changes](skills/research-docx-track-changes/) | Official Word/DOCX skill for document creation, editing, and formatting. |
| [research-pptx-ooxml-edit](skills/research-pptx-ooxml-edit/) | Official PowerPoint/PPTX skill for presentation creation and editing. |

</details>

### Computational Simulation & Ontology (HeshamFS/materials-simulation-skills)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-ontology-validator](skills/research-ontology-validator/) | Validate biomedical ontology structures and term relationships (HPO, GO, MeSH, SNOMED, OBO). |
| [research-ontology-explorer](skills/research-ontology-explorer/) | Navigate and query biomedical ontologies: term hierarchies, annotations, cross-references. |
| [research-ontology-mapper](skills/research-ontology-mapper/) | Map between biomedical ontologies: HPO↔OMIM, GO↔UniProt, disease↔phenotype cross-ontology. |
| [research-slurm-job-script-generator](skills/research-slurm-job-script-generator/) | Generate SLURM sbatch scripts for HPC genomics/bioinformatics pipeline jobs with optimized resource requests. |
| [research-numerical-integration](skills/research-numerical-integration/) | Select and configure ODE/PDE time integration for biological model simulation (stiff systems, IMEX). |
| [research-nonlinear-solvers](skills/research-nonlinear-solvers/) | Configure nonlinear solvers for biological network optimization, parameter fitting, FBA. |
| [research-parameter-optimization](skills/research-parameter-optimization/) | Design of experiments, sensitivity analysis, Bayesian optimization for biological model calibration. |
| [research-linear-solvers](skills/research-linear-solvers/) | Select linear solvers for large-scale biological network and metabolic model computations. |
| [research-numerical-stability](skills/research-numerical-stability/) | Analyze numerical stability for time-dependent biological simulations (CFL criteria, stiffness). |
| [research-simulation-orchestrator](skills/research-simulation-orchestrator/) | Orchestrate multi-simulation campaigns: parameter sweeps, batch jobs, result aggregation. |
| [research-simulation-validator](skills/research-simulation-validator/) | Validate simulations: pre-flight checks, runtime monitoring, convergence, NaN/Inf detection. |
| [research-convergence-study](skills/research-convergence-study/) | Spatial/temporal convergence analysis with Richardson extrapolation for simulation verification. |
| [research-post-processing](skills/research-post-processing/) | Extract, analyze, and visualize simulation output data: time series, field profiles, statistics. |
| [research-performance-profiling](skills/research-performance-profiling/) | Identify computational bottlenecks, analyze scaling behavior, optimize HPC simulation jobs. |
| [research-differentiation-schemes](skills/research-differentiation-schemes/) | Select finite difference/volume/spectral schemes for PDE discretization in biological models. |
| [research-time-stepping](skills/research-time-stepping/) | Adaptive time-step control for biological dynamics: CFL constraints, checkpoint scheduling. |
| [research-mesh-generation](skills/research-mesh-generation/) | Mesh generation for numerical simulations: resolution, quality metrics, adaptive refinement. |

</details>

### Developer Workflow Skills (obra/superpowers)

<details>
<summary>Click to expand skill list</summary>

| Skill | Description |
|-------|-------------|
| [research-test-driven-development](skills/research-test-driven-development/) | TDD workflow: write tests before implementation, red-green-refactor cycle for reliable code. |
| [research-systematic-debugging](skills/research-systematic-debugging/) | Structured debugging approach: hypothesis formation, evidence gathering, root cause analysis. |
| [research-parallel-task-delegation](skills/research-parallel-task-delegation/) | Orchestrate parallel subagents for independent tasks to maximize throughput. |
| [research-implementation-planning](skills/research-implementation-planning/) | Write structured implementation plans before touching code for complex multi-step tasks. |
| [research-executing-plans](skills/research-executing-plans/) | Execute written implementation plans with review checkpoints in isolated sessions. |
| [research-software-design-planning](skills/research-software-design-planning/) | Structured creative exploration of requirements and design before implementation. |
| [research-skill-authoring](skills/research-skill-authoring/) | Create and verify new SKILL.md skills with proper format and deployment validation. |
| [research-completion-verification](skills/research-completion-verification/) | Run verification commands and confirm outputs before claiming work is complete. |
| [research-code-review-request](skills/research-code-review-request/) | Structure code review requests with context, changes summary, and specific questions. |
| [research-code-review-response](skills/research-code-review-response/) | Process code review feedback with technical rigor rather than blind acceptance. |
| [research-delegated-development](skills/research-delegated-development/) | Break development tasks into subtasks for parallel subagent execution. |
| [research-git-worktree-management](skills/research-git-worktree-management/) | Create isolated git worktrees for feature work and plan execution. |
| [research-development-branch-completion](skills/research-development-branch-completion/) | Complete development branches: merge, PR, or cleanup with structured decision options. |
| [research-skill-selection](skills/research-skill-selection/) | Meta-skill: discover and use available skills for any task at conversation start. |

</details>

</details>

## Acknowledgements

We have benefited from the following excellent projects. If you’re interested, please check them out.

1. [awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)
2. [Anthropics Skills](https://github.com/anthropics/skills)
3. [Skillsmp](https://skillsmp.com/)
4. [awesome-claude-skills](https://github.com/BehiSecc/awesome-claude-skills)
5. [ClawHub](https://clawhub.ai/)
6. [水产市场](https://openclawmp.cc/)
7. [Skills.Sh](https://skills.sh/)
8. [awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills)
9. [llmbase](https://llmbase.ai/openclaw/)
10. [OpenClaw](https://docs.openclaw.ai/zh-CN)
11. [awesome-openclaw-skills](https://github.com/VoltAgent/awesome-openclaw-skills)
12. [claude-scientific-skills](https://github.com/K-Dense-AI/claude-scientific-skills)
13. [LLMs-Universal-Life-Science-and-Clinical-Skills-](https://github.com/mdbabumiamssm/LLMs-Universal-Life-Science-and-Clinical-Skills-)
14. [BioClaw](https://github.com/Runchuan-BU/BioClaw)
15. [ClawBio](https://github.com/ClawBio/ClawBio)

## Citation

```bib
@misc{freedomintelligence2026openclaw,
      title={OpenClaw-Medical-Skills},
      author={Rongsheng Wang, Dongli He, Benyou Wang},
      year={2026},
      publisher = {GitHub},
      journal = {GitHub repository},
      howpublished = {\url{https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills}},
}
```

or

```bib
王荣胜，何东立，王本友. OpenClaw-Medical-Skills：面向智能体的医疗技能库[EB/OL]. GitHub, 2026. https://github.com/FreedomIntelligence/OpenClaw-Medical-Skills
```

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=FreedomIntelligence/OpenClaw-Medical-Skills&type=Date)](https://star-history.com/#FreedomIntelligence/OpenClaw-Medical-Skills&Date)
