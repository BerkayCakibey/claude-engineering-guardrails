# MCP Evaluation Guide

Use this guide after the server implementation is stable enough to evaluate
real tool usage.

## Purpose

Measure whether an MCP server helps a model complete realistic read-only tasks
with accurate answers, clear tool usage, and actionable tool feedback.

## Evaluation Workflow

1. Inspect the available tools and confirm the server boots cleanly.
2. Build a small set of realistic, independent questions that require tool use.
3. Verify each expected answer yourself before running the harness.
4. Save the question/answer pairs in the XML format used by
   `scripts/example_evaluation.xml`.
5. Run the evaluation harness with `scripts/evaluation.py`.
6. Review both answer accuracy and the feedback block for tool-design issues.

## Question Design Rules

- Keep tasks read-only unless a destructive workflow is the explicit subject of
  the server and can be safely isolated.
- Prefer questions that require multiple tool calls or filtered exploration.
- Avoid answers that change rapidly over time unless the evaluation is designed
  around a fixed fixture.
- Use exact, verifiable answers whenever possible.

## Output Expectations

Each evaluation result should make it easy to inspect:

- the expected answer
- the actual answer
- whether the answer matched
- which tools were called
- the model's summary of its approach
- feedback on tool naming, descriptions, and parameter quality

## Supporting Files

- XML example: [../scripts/example_evaluation.xml](../scripts/example_evaluation.xml)
- Harness entry point: [../scripts/evaluation.py](../scripts/evaluation.py)
