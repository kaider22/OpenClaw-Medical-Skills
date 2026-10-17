---
name: omics-machine-learning-omics-classifiers
description: 提供用随机森林、XGBoost和逻辑回归构建组学分类器的方法与调用指南；用于处理组学特征矩阵、分层标签和预处理配置。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: sklearn
    measurable_outcome: Execute skill workflow successfully with valid output within 15 minutes.
    allowed-tools:
    - read_file
    - run_shell_command
---
<!--
# COPYRIGHT NOTICE
# This file is part of the "Universal Biomedical Skills" project.
# Copyright (c) 2026 MD BABU MIA, PhD <md.babu.mia@mssm.edu>
# All Rights Reserved.
#
# This code is proprietary and confidential.
# Unauthorized copying of this file, via any medium is strictly prohibited.
#
# Provenance: Authenticated by MD BABU MIA

-->


# Classification Models for Omics Data

## Codex 调用

- **选择**：请求涉及“用随机森林、XGBoost和逻辑回归构建组学分类器”时使用；显式调用 `$omics-machine-learning-omics-classifiers`。
- **输入**：组学特征矩阵、分层标签和预处理配置。
- **预期产物**：分类预测、ROC-AUC、报告和特征重要性；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`matplotlib`、`pandas`、`sklearn`、`xgboost`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Core Workflow

```python
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, roc_auc_score, roc_curve
import matplotlib.pyplot as plt

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, stratify=y, random_state=42)

pipe = Pipeline([
    ('scaler', StandardScaler()),
    ('clf', RandomForestClassifier(n_estimators=100, random_state=42, n_jobs=-1))
])
pipe.fit(X_train, y_train)

y_pred = pipe.predict(X_test)
y_prob = pipe.predict_proba(X_test)[:, 1]
print(classification_report(y_test, y_pred))
print(f'ROC-AUC: {roc_auc_score(y_test, y_prob):.3f}')
```

## XGBoost Classifier

```python
from xgboost import XGBClassifier

# Use sklearn-compatible API with proper parameters (avoid deprecated seed, nthread)
xgb = XGBClassifier(
    n_estimators=100,
    max_depth=6,
    learning_rate=0.1,
    random_state=42,  # NOT seed
    n_jobs=-1,        # NOT nthread
    eval_metric='logloss'
)

pipe = Pipeline([('scaler', StandardScaler()), ('clf', xgb)])
pipe.fit(X_train, y_train)
```

## Logistic Regression with Regularization

```python
from sklearn.linear_model import LogisticRegressionCV

# L1 for sparse biomarkers, L2 for correlated features, elasticnet for mixed
logit = LogisticRegressionCV(
    Cs=10,
    cv=5,
    penalty='l1',
    solver='saga',
    max_iter=1000,
    random_state=42
)
pipe = Pipeline([('scaler', StandardScaler()), ('clf', logit)])
pipe.fit(X_train, y_train)

# Get selected features (nonzero coefficients)
feature_mask = logit.coef_[0] != 0
selected = X.columns[feature_mask]
```

## ROC Curve Visualization

```python
fpr, tpr, _ = roc_curve(y_test, y_prob)
auc = roc_auc_score(y_test, y_prob)

plt.figure(figsize=(6, 6))
plt.plot(fpr, tpr, label=f'ROC (AUC = {auc:.3f})')
plt.plot([0, 1], [0, 1], 'k--')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.legend()
plt.savefig('roc_curve.png', dpi=150)
```

## Multi-class Classification

```python
from sklearn.metrics import classification_report
from sklearn.preprocessing import LabelEncoder

le = LabelEncoder()
y_encoded = le.fit_transform(y)

# Use class_weight for imbalanced data
rf = RandomForestClassifier(n_estimators=100, class_weight='balanced', random_state=42)
```

## Feature Importance from Trees

```python
import pandas as pd

importances = pipe.named_steps['clf'].feature_importances_
feature_imp = pd.DataFrame({'feature': X.columns, 'importance': importances})
feature_imp = feature_imp.sort_values('importance', ascending=False).head(20)
```

## Preprocessing Guidelines

| Data Type | Scaler | Notes |
|-----------|--------|-------|
| Log-counts (RNA-seq) | StandardScaler | Assumes ~normal after log |
| TPM/FPKM | StandardScaler | Gene-wise centering |
| Raw counts | None | Tree models handle counts |
| Mixed features | ColumnTransformer | Different scalers per type |

## Related Skills

- machine-learning/model-validation - Proper model evaluation
- machine-learning/prediction-explanation - Explain predictions with SHAP
- machine-learning/biomarker-discovery - Reduce features before modeling


<!-- AUTHOR_SIGNATURE: 9a7f3c2e-MD-BABU-MIA-2026-MSSM-SECURE -->