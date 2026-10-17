---
name: clinical-message-entity-extraction
description: 提供从患者消息提取症状、用药、检验和诊断实体的方法与调用指南；用于处理带优先级、时间和正文的患者消息JSON。
license: MIT
metadata:
  author: NAPSTER AI
  maintainer: NAPSTER AI
  openclaw:
    requires:
      bins: []
---

# Medical Entity Extractor

## Codex 调用

- **选择**：请求涉及“从患者消息提取症状、用药、检验和诊断实体”时使用；显式调用 `$clinical-message-entity-extraction`。
- **输入**：带优先级、时间和正文的患者消息JSON。
- **预期产物**：结构化实体、摘要和行动项JSON；按正文的方法约束和质量检查核对本次输入与产物。
- **执行方式**：由当前 Codex 根据正文完成所述分析、设计或文档任务；需要计算或实时信息的环节必须使用实际可用的工具，不能用文字生成代替执行。
- **执行记录**：对照上述输入与预期产物报告 `PASS`、`FAIL`、`BLOCKED` 或 `NOT_RUN`；注明是源代码执行、按指南运行还是方案说明。

Extract structured medical information from unstructured patient messages.

## What This Skill Does

1. **Symptom Extraction**: Identifies symptoms, severity, duration, and progression
2. **Medication Extraction**: Finds medication names, dosages, frequencies, and side effects
3. **Lab Value Extraction**: Parses lab results, vital signs, and measurements
4. **Diagnosis Extraction**: Identifies mentioned diagnoses and conditions
5. **Temporal Extraction**: Captures when symptoms started, how long they've lasted
6. **Action Items**: Identifies requested actions (appointments, refills, questions)

## Input Format

```json
[
  {
    "id": "msg-123",
    "priority_score": 78,
    "priority_bucket": "P1",
    "subject": "Medication side effects",
    "from": "patient@example.com",
    "date": "2026-02-27T10:30:00Z",
    "body": "I've been feeling dizzy since starting the new blood pressure medication (Lisinopril 10mg) three days ago. My BP this morning was 145/92."
  }
]
```

## Output Format

```json
[
  {
    "id": "msg-123",
    "entities": {
      "symptoms": [
        {
          "name": "dizziness",
          "severity": "moderate",
          "duration": "3 days",
          "onset": "since starting new medication"
        }
      ],
      "medications": [
        {
          "name": "Lisinopril",
          "dosage": "10mg",
          "frequency": null,
          "context": "new medication"
        }
      ],
      "lab_values": [
        {
          "type": "blood_pressure",
          "value": "145/92",
          "unit": "mmHg",
          "timestamp": "this morning"
        }
      ],
      "diagnoses": [
        {
          "name": "hypertension",
          "context": "implied by blood pressure medication"
        }
      ],
      "action_items": [
        {
          "type": "medication_review",
          "reason": "possible side effect (dizziness)"
        }
      ]
    },
    "summary": "Patient reports dizziness after starting Lisinopril 10mg 3 days ago. BP elevated at 145/92. Possible medication side effect requiring review."
  }
]
```

## Entity Types

### Symptoms
- Name, severity (mild/moderate/severe), duration, onset, progression (improving/stable/worsening)

### Medications
- Name, dosage, frequency, route, context (new/existing/stopped)

### Lab Values
- Type (BP, glucose, cholesterol, etc.), value, unit, timestamp, normal range

### Diagnoses
- Name, context (confirmed/suspected/ruled out)

### Vital Signs
- Temperature, heart rate, respiratory rate, oxygen saturation, blood pressure

### Action Items
- Type (appointment, refill, question, callback), urgency, reason

## Medical Terminology Handling

The skill recognizes:
- Common abbreviations (BP, HR, RR, O2 sat, etc.)
- Brand and generic medication names
- Lay terms for medical conditions ("sugar" → diabetes, "heart attack" → MI)
- Temporal expressions ("since yesterday", "for the past week")

## Integration

This skill can be invoked via the OpenClaw CLI:

```bash
openclaw skill run medical-entity-extractor --input '[{"id":"msg-1","priority_score":78,...}]' --json
```

Or programmatically:

```typescript
const result = await execFileAsync('openclaw', [
  'skill', 'run', 'medical-entity-extractor',
  '--input', JSON.stringify(scoredMessages),
  '--json'
]);
```

**Recommended Model**: Claude Sonnet 4.5 (`openclaw models set anthropic/claude-sonnet-4-5`)

## Privacy & Security

- All processing happens locally via OpenClaw
- No data is sent to external services (except Claude API for LLM processing)
- Extracted entities remain in your local environment

