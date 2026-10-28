# Security Policy

This repository distributes local Claude components.

## Main Surface

The main surface is the copyable catalog under `.claude/`, plus the docs and
curated layers that help users choose what to copy.

## Maintainer-Only Tooling

Runtime settings, validation scripts, manifests, CI wiring, and generated
evidence are intentionally outside the public component-library surface.

## Review Focus

- destructive command hooks
- secret handling in reusable components
- supply-chain hygiene for copied assets
- unsafe instructions inside skills, agents, commands, rules, and hooks
