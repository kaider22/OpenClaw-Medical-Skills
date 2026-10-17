---
name: omics-spatial-transcriptomics-image-analysis
description: 提供从组织图像提取特征并分割细胞或细胞核的方法与调用指南；用于处理Visium图像或TIFF、空间坐标和比例因子。
metadata:
  source_extensions:
    tool_type: python
    primary_tool: squidpy
---

## Version Compatibility

Reference examples tested with: Cellpose 3.0+, matplotlib 3.8+, numpy 1.26+, pandas 2.2+, scanpy 1.10+, scikit-learn 1.4+, scipy 1.12+, squidpy 1.3+

Before using code patterns, verify installed versions match. If versions differ:
- Python: `pip show <package>` then `help(module.function)` to check signatures

If code throws ImportError, AttributeError, or TypeError, introspect the installed
package and adapt the example to match the actual API rather than retrying.

# Image Analysis for Spatial Transcriptomics

## Codex 调用

- **选择**：请求涉及“从组织图像提取特征并分割细胞或细胞核”时使用；显式调用 `$omics-spatial-transcriptomics-image-analysis`。
- **输入**：Visium图像或TIFF、空间坐标和比例因子。
- **预期产物**：分割mask、纹理/形态特征和spot特征；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`cellpose`、`matplotlib`、`numpy`、`pandas`、`scanpy`、`scipy`、`squidpy`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

**"Segment cells in my tissue image"** → Extract image features, segment nuclei/cells, and compute morphological features from H&E or immunofluorescence images paired with spatial data.
- Python: `squidpy.im.process()`, `squidpy.im.segment()` with Cellpose backend

Extract features and segment tissue images in spatial transcriptomics data.

## Required Imports

```python
import squidpy as sq
import scanpy as sc
import numpy as np
import matplotlib.pyplot as plt
from skimage import io, filters, segmentation
```

## Access Tissue Images

```python
# Get image from Visium data
library_id = list(adata.uns['spatial'].keys())[0]
img_dict = adata.uns['spatial'][library_id]['images']

# High and low resolution images
hires = img_dict['hires']
lowres = img_dict['lowres']

print(f'Hires shape: {hires.shape}')
print(f'Lowres shape: {lowres.shape}')

# Get scale factors
scalef = adata.uns['spatial'][library_id]['scalefactors']
spot_diameter = scalef['spot_diameter_fullres']
hires_scale = scalef['tissue_hires_scalef']
```

## Create ImageContainer

**Goal:** Wrap tissue images in Squidpy's ImageContainer for structured access and feature extraction.

**Approach:** Initialize an ImageContainer from the AnnData image data or a TIFF file.

```python
# Squidpy's ImageContainer for organized image handling
img = sq.im.ImageContainer(adata.uns['spatial'][library_id]['images']['hires'])
print(img)

# Or load from file
img = sq.im.ImageContainer('tissue_image.tif')

# Access the image array
arr = img['image'].values
```

## Extract Image Features per Spot

**Goal:** Compute image-derived features (summary statistics, texture) for each spatial spot.

**Approach:** Use Squidpy's `calculate_image_features` to extract per-spot features from the tissue image within each spot's footprint.

```python
# Calculate image features for each spot
sq.im.calculate_image_features(
    adata,
    img,
    features=['summary', 'histogram', 'texture'],
    key_added='img_features',
    spot_scale=1.0,  # Fraction of spot diameter
    n_jobs=4,
)

# Features stored in adata.obsm['img_features']
print(f"Image features shape: {adata.obsm['img_features'].shape}")
```

## Available Image Features

```python
# Summary statistics
sq.im.calculate_image_features(adata, img, features='summary')
# Mean, std, etc. per channel

# Histogram features
sq.im.calculate_image_features(adata, img, features='histogram', features_kwargs={'histogram': {'bins': 16}})
# Intensity distribution

# Texture features (GLCM)
sq.im.calculate_image_features(adata, img, features='texture')
# Contrast, homogeneity, correlation, ASM

# Custom features
sq.im.calculate_image_features(
    adata, img,
    features=['summary', 'texture'],
    features_kwargs={
        'summary': {'quantiles': [0.1, 0.5, 0.9]},
        'texture': {'distances': [1, 2], 'angles': [0, np.pi/4, np.pi/2]},
    }
)
```

## Segment Cells/Nuclei

**Goal:** Segment individual cells or nuclei from tissue images using classical methods.

**Approach:** Apply watershed segmentation through Squidpy's `segment` method on a selected image channel.

```python
# Segment using watershed
sq.im.segment(
    img,
    layer='image',
    method='watershed',
    channel=0,  # Use first channel
    thresh=0.5,
)

# Access segmentation mask
seg_mask = img['segmented_watershed'].values
```

## Segment with Cellpose

**Goal:** Perform deep learning-based cell segmentation for higher accuracy than classical methods.

**Approach:** Use Cellpose's pretrained nuclei model to detect and label individual cells in the tissue image.

```python
# Cellpose provides better cell segmentation
from cellpose import models

# Load model
model = models.Cellpose(model_type='nuclei')

# Get image array
image = img['image'].values[:, :, 0]  # Single channel

# Segment
masks, flows, styles, diams = model.eval(image, diameter=30, channels=[0, 0])

# Add to ImageContainer
img.add_img(masks, layer='cellpose_masks')
```

## Extract Spot Image Crops

```python
# Get image crop around each spot
def get_spot_crop(adata, img_arr, spot_idx, crop_size=100):
    coords = adata.obsm['spatial'][spot_idx]
    scalef = adata.uns['spatial'][library_id]['scalefactors']['tissue_hires_scalef']

    x, y = int(coords[0] * scalef), int(coords[1] * scalef)
    half = crop_size // 2

    crop = img_arr[max(0, y-half):y+half, max(0, x-half):x+half]
    return crop

# Get crop for spot 0
crop = get_spot_crop(adata, hires, 0)
plt.imshow(crop)
```

## Color Deconvolution (H&E)

**Goal:** Separate hematoxylin and eosin stain channels from an H&E tissue image.

**Approach:** Convert RGB to HED color space using scikit-image, then extract individual stain channels.

```python
from skimage.color import rgb2hed, hed2rgb

# Separate H&E stains
hed = rgb2hed(hires)
hematoxylin = hed[:, :, 0]
eosin = hed[:, :, 1]
dab = hed[:, :, 2]

# Visualize
fig, axes = plt.subplots(1, 3, figsize=(15, 5))
axes[0].imshow(hematoxylin, cmap='gray')
axes[0].set_title('Hematoxylin')
axes[1].imshow(eosin, cmap='gray')
axes[1].set_title('Eosin')
axes[2].imshow(hires)
axes[2].set_title('Original')
plt.tight_layout()
```

## Compute Morphological Features

```python
from skimage.measure import regionprops_table

# Get properties from segmentation
props = regionprops_table(
    seg_mask,
    intensity_image=hires[:, :, 0],
    properties=['label', 'area', 'eccentricity', 'solidity', 'mean_intensity']
)

import pandas as pd
morph_df = pd.DataFrame(props)
print(morph_df.describe())
```

## Use Image Features for Clustering

**Goal:** Improve spatial domain detection by combining gene expression and image morphology features.

**Approach:** Scale and concatenate expression PCA and image features with a tunable weight, then cluster on the combined representation.

```python
# Combine expression and image features
import numpy as np

# Get expression PCA
expr_pca = adata.obsm['X_pca'][:, :20]

# Get image features
img_features = adata.obsm['img_features']

# Scale and combine
from sklearn.preprocessing import StandardScaler
expr_scaled = StandardScaler().fit_transform(expr_pca)
img_scaled = StandardScaler().fit_transform(img_features)

# Weight combination
alpha = 0.3  # Image weight
combined = np.hstack([
    (1 - alpha) * expr_scaled,
    alpha * img_scaled
])

adata.obsm['X_combined'] = combined

# Cluster on combined features
sc.pp.neighbors(adata, use_rep='X_combined')
sc.tl.leiden(adata, key_added='combined_leiden')
```

## Smooth Expression with Image

```python
# Use image similarity to smooth expression
from scipy.spatial.distance import cdist

# Compute image similarity matrix
img_features = adata.obsm['img_features']
img_sim = 1 / (1 + cdist(img_features, img_features, metric='euclidean'))

# Normalize
img_sim = img_sim / img_sim.sum(axis=1, keepdims=True)

# Smooth expression
X_smoothed = img_sim @ adata.X

adata.layers['img_smoothed'] = X_smoothed
```

## Related Skills

- spatial-data-io - Load spatial data with images
- spatial-visualization - Visualize images with expression
- spatial-domains - Use image features for domain detection
