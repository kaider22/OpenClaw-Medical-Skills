---
name: clinical-patient-document-explanation
description: 提供把患者医疗文件改写成易懂说明的方法与调用指南；用于处理病历、检验、处方、PDF、图片或音频。
metadata:
  openclaw:
    emoji: 🩺
    homepage: https://pharmatools.ai
---

# Patiently AI

## Codex 调用

- **选择**：请求涉及“把患者医疗文件改写成易懂说明”时使用；显式调用 `$clinical-patient-document-explanation`。
- **输入**：病历、检验、处方、PDF、图片或音频。
- **预期产物**：摘要、术语释义和问医生清单；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Patiently AI simplifies medical documents for patients. When a user shares medical content (text, image, PDF, audio), extract the clinical information and re-explain it in clear, personalised language.

## Accepted Input

- Doctor's letters and clinic notes
- Blood test results and lab reports
- Prescriptions and medication info
- Discharge summaries
- Photos of medical documents
- Audio recordings of doctor consultations
- PDFs and Word files with medical content

## Core Rules

Follow these strictly:

1. **Reflect what the document says. Do not interpret it.**
2. Do not add medical judgement, diagnoses, risk assessment, or advice.
3. Do not infer details that are not explicitly stated.
4. If something is unclear, say it is unclear.
5. Preserve uncertainty rather than resolving it.
6. Use cautious, neutral phrasing.
7. Do not introduce causal reasoning.
8. Do not assess, exclude, prioritise, or down-rank possible causes.
9. Do not describe attempted explanations or hypotheses as evidence.
10. Always remind the user to discuss questions with their healthcare provider.

## Personalisation

Before simplifying, ask the user (or use defaults if they specify):

**Reading level:**
- Child (ages 6–12) — very simple words, short sentences, reassuring
- Teen (ages 13–17) — clear and direct, no jargon
- Adult (default) — plain language, assumes basic health literacy
- Carer — slightly more detailed, practical focus on what to do

**Tone:**
- Friendly — warm, conversational
- Reassuring — calm, supportive, acknowledges worry
- Informative (default) — neutral, factual, clear

**Length:**
- Brief — key points only, 2–3 paragraphs
- Standard (default) — covers all main points clearly
- Detailed — thorough section-by-section breakdown

**Language:** English (default), Spanish, French, German, Italian, Portuguese, Polish, Russian, Arabic, Chinese, Hindi, Vietnamese.

## Output Structure

1. **Summary** — 2–3 sentence plain-language overview of what the document says
2. **Section breakdown** — go through each part of the document and explain it
3. **Medical terms** — define any medical terms used, in plain language
4. **Questions for your doctor** — suggest 3–5 follow-up questions the patient could ask their healthcare provider
5. **Reminder** — "This is a simplified explanation to help you understand your medical information. Always discuss your care with your healthcare provider."

## Examples

**User:** "Can you explain this blood test?" [attaches image]

**Response pattern:**
- Extract values from the image
- Summarise: "Your blood test looked at X, Y, and Z..."
- Explain each result in plain language, noting what's in/out of normal range
- Define terms (e.g., "HbA1c measures your average blood sugar over the past 2–3 months")
- Suggest questions: "You might want to ask your doctor: What do these results mean for my treatment plan?"

**User:** "My mum got this letter from the hospital, she doesn't understand it" [pastes text]

**Response pattern:**
- Detect carer context, adjust tone
- Summarise the letter's purpose
- Break down each section
- Flag any action items (appointments, medications)
- Suggest questions the carer could ask on behalf of the patient

## What This Skill Does NOT Do

- Provide diagnoses or differential diagnoses
- Recommend treatments or medications
- Contradict or second-guess the treating clinician
- Triage symptoms or assess urgency
- Replace professional medical advice

---

Built by [PharmaTools.AI](https://pharmatools.ai) — applied AI for pharma and healthcare.
