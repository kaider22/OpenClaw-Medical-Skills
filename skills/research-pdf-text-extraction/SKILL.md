---
name: research-pdf-text-extraction
description: 提供抽取PDF文本表格并完成合并和拆分的方法与调用指南；用于处理PDF文件、页码范围、表单和扫描文档。
---

# PDF Processing

## Codex 调用

- **选择**：请求涉及“抽取PDF文本表格并完成合并和拆分”时使用；显式调用 `$research-pdf-text-extraction`。
- **输入**：PDF文件、页码范围、表单和扫描文档。
- **预期产物**：文本、表格CSV、合并PDF或拆分页面；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：按正文的库/命令行示例在当前终端执行与本次输入相符的分支；这是按指南运行，不是仓库自带完整算法入口。先确认所选软件和版本。
- **环境核对**：`pdfplumber`、`pypdf`（原文涉及的工具或导入名，按实际执行分支检查，不将导入名直接当作安装包名）。
- **按需阅读**：[FORMS.md](FORMS.md)；仅加载本次分支需要的说明。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

## Quick start

Use pdfplumber to extract text from PDFs:

```python
import pdfplumber

with pdfplumber.open("document.pdf") as pdf:
    text = pdf.pages[0].extract_text()
    print(text)
```

## Extracting tables

Extract tables from PDFs with automatic detection:

```python
import pdfplumber

with pdfplumber.open("report.pdf") as pdf:
    page = pdf.pages[0]
    tables = page.extract_tables()

    for table in tables:
        for row in table:
            print(row)
```

## Extracting all pages

Process multi-page documents efficiently:

```python
import pdfplumber

with pdfplumber.open("document.pdf") as pdf:
    full_text = ""
    for page in pdf.pages:
        full_text += page.extract_text() + "\n\n"

    print(full_text)
```

## Form filling

For PDF form filling, see [FORMS.md](FORMS.md) for the complete guide including field analysis and validation.

## Merging PDFs

Combine multiple PDF files:

```python
from pypdf import PdfMerger

merger = PdfMerger()

for pdf in ["file1.pdf", "file2.pdf", "file3.pdf"]:
    merger.append(pdf)

merger.write("merged.pdf")
merger.close()
```

## Splitting PDFs

Extract specific pages or ranges:

```python
from pypdf import PdfReader, PdfWriter

reader = PdfReader("input.pdf")
writer = PdfWriter()

# Extract pages 2-5
for page_num in range(1, 5):
    writer.add_page(reader.pages[page_num])

with open("output.pdf", "wb") as output:
    writer.write(output)
```

## Available packages

- **pdfplumber** - Text and table extraction (recommended)
- **pypdf** - PDF manipulation, merging, splitting
- **pdf2image** - Convert PDFs to images (requires poppler)
- **pytesseract** - OCR for scanned PDFs (requires tesseract)

## Common patterns

**Extract and save text:**
```python
import pdfplumber

with pdfplumber.open("input.pdf") as pdf:
    text = "\n\n".join(page.extract_text() for page in pdf.pages)

with open("output.txt", "w") as f:
    f.write(text)
```

**Extract tables to CSV:**
```python
import pdfplumber
import csv

with pdfplumber.open("tables.pdf") as pdf:
    tables = pdf.pages[0].extract_tables()

    with open("output.csv", "w", newline="") as f:
        writer = csv.writer(f)
        for table in tables:
            writer.writerows(table)
```

## Error handling

Handle common PDF issues:

```python
import pdfplumber

try:
    with pdfplumber.open("document.pdf") as pdf:
        if len(pdf.pages) == 0:
            print("PDF has no pages")
        else:
            text = pdf.pages[0].extract_text()
            if text is None or text.strip() == "":
                print("Page contains no extractable text (might be scanned)")
            else:
                print(text)
except Exception as e:
    print(f"Error processing PDF: {e}")
```

## Performance tips

- Process pages in batches for large PDFs
- Use multiprocessing for multiple files
- Extract only needed pages rather than entire document
- Close PDF objects after use
