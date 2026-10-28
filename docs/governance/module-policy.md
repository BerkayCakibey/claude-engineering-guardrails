# Module Policy

Main-surface files must support direct reuse by copy and paste.

## Keep In Main Surface

- skills
- agents
- commands
- hooks
- rules
- docs that explain how to consume those components

## Keep Out Of Main Surface

- runtime settings
- orchestration registries
- validation scripts
- generated manifests
- CI wiring
- evidence and QC output

## Decision Rule

If a file is primarily useful after cloning this repo and running it as a
system, it should stay out of the public component-library surface.

If a file is primarily useful after copying it into a user's own Claude setup,
it belongs on the main surface.
