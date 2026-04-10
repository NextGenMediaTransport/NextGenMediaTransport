---
title: "Phase 2 — Refactor and Build Standardization"
phase: 2
status: planned
---

## Overview

Original OMT codebases can be fragmented. Phase 2 makes NextGenMediaTransport **build reliably** for every contributor: one clear build story, pruned dependencies, documented standards, and a **one-click** (or single-command) local developer experience on Windows, macOS, and Linux.

## Build system standardization

### CMake and Cargo

- **C++ components:** standardize on **CMake** with clear targets for core, transport, codec, and shared utilities.
- **Rust components (if present):** standardize on **Cargo** workspaces where appropriate, with documented interop boundaries to CMake-built artifacts.
- Deliver a **single top-level entry point** for developers—e.g. a documented `make build-all`, `cmake --build`, or workspace-level script—that builds core transport, codecs, and (where applicable) discovery modules in a predictable order.

### Cross-platform parity

- CI from Phase 1 must stay green as refactors land; fix platform-specific assumptions early (paths, threading, socket APIs).

## Dependency pruning

### Goals

- Remove **outdated or unused** third-party libraries.
- Replace heavy legacy networking pieces with **modern QUIC** and supporting stacks aligned with `ngmt-transport`.
- Document each retained dependency: purpose, version pin, and license.

## Coding standards

### Practices

- **Formatting:** `clang-format` for C++, `rustfmt` for Rust; config checked in.
- **Linting:** enable compiler warnings-as-policy where feasible; add `clippy` or C++ static analysis in CI as the codebase stabilizes.
- **Contributing:** CONTRIBUTING.md (or equivalent) describing branch workflow, review expectations, and license certification for contributions.

## One-click local build environment

### Goals

- **Documented prerequisites** per OS (compilers, SDKs, optional vcpkg/conan if used).
- Optional **devcontainer** or bootstrap scripts so a new developer can build without tribal knowledge.
- README quick-start: clone → install deps → one command → run tests/smoke binary.

## Definition of Done

- [ ] Unified build entry point documented; core + transport + codec build in CI on **Windows**, **macOS**, and **Linux**.
- [ ] Legacy/unused dependencies removed or replaced; dependency list and licenses reviewed.
- [ ] Formatting and linting standards are **enforced or documented**; CI checks exist where practical.
- [ ] New contributors can follow README/devcontainer to a **successful local build** without private steps.
- [ ] Documentation updated for build flags, feature toggles, and troubleshooting common platform issues.
