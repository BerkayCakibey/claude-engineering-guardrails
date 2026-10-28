---
name: benchmark
description: >-
  Measure baseline and comparative performance signals before and after changes with reproducible evidence.
---

# Skill: benchmark

## Purpose
Turn "it feels faster" into repeatable before/after evidence.

## Use When
- A change claims performance improvement.
- A latency, throughput, or frontend speed regression is suspected.
- You need to compare alternatives under the same measurement shape.

## Measurement Rules
1. Define the metric before running the measurement.
2. Capture baseline first.
3. Keep the environment, payload size, and warm/cold assumptions explicit.
4. Report relative change and the test shape together.
5. Do not oversell noisy one-off runs as stable results.

## Output Requirements
```markdown
## Benchmark Shape
- [metric, environment, dataset, warm/cold assumption]

## Baseline
- [measured value]

## Candidate Result
- [measured value]

## Interpretation
- [real win, noise, or inconclusive]

## Follow-up
- [repeat runs or deeper profiling needed]
```

## Group
Product Design And QA
