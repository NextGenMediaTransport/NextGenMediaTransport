---
title: "Phase 1 — Foundation and Forking"
phase: 1
status: done
---

## Overview

Phase 1 establishes the **GitHub organization**, **essential forks** from Open Media Transport, **cross-platform CI/CD**, **permissive licensing**, **automated documentation pipelines**, and **repository-wide rules** so contributors and agents keep docs aligned with code from day one.

## GitHub organization

### Goals

- Create a dedicated organization (e.g. **NextGenMediaTransport**) to host core libraries, transport, codecs, bindings, and integrations under one umbrella.
- Keep the org **lean**: prefer a small set of maintained repositories over importing every experimental upstream repo.

### Repository naming (initial mapping)

Verify upstream slugs on [openmediatransport — repositories](https://github.com/orgs/openmediatransport/repositories). Older placeholder names (`omt-core`, `omt-transport-quic`, `omt-codec-vmx`) are **not** present there and must not be used in `gh repo fork`.

| Upstream (GitHub) | NGMT repository | Purpose |
| --- | --- | --- |
| [`openmediatransport/libomtnet`](https://github.com/openmediatransport/libomtnet) | `ngmt-core` | Multiplexing and foundational OMT protocol logic (reference .NET implementation). |
| [`openmediatransport/libvmx`](https://github.com/openmediatransport/libvmx) | `ngmt-codec` | AV1/VMX-oriented video and audio codec stack. |
| *(none — first-party)* | `ngmt-transport` | WAN-oriented **QUIC** network layer. **Not a fork:** upstream OMT uses TCP on the LAN ([`PROTOCOL.md`](https://github.com/openmediatransport/libomtnet/blob/master/PROTOCOL.md)); QUIC is implemented in NGMT. |
| [`openmediatransport`](https://github.com/orgs/openmediatransport/repositories) (TBD) | `ngmt-bindings` (optional in first wave) | C++, Rust, and/or Python wrappers. |

**GitHub CLI (examples):** fork core and codec from `openmediatransport`; create a new org repo for transport:

```bash
gh repo fork openmediatransport/libomtnet --org NextGenMediaTransport --fork-name ngmt-core --clone
gh repo fork openmediatransport/libvmx --org NextGenMediaTransport --fork-name ngmt-codec --clone
gh repo create NextGenMediaTransport/ngmt-transport --public --description "NGMT QUIC/WAN transport (first-party implementation)"
```

Details: [docs/contributing/fork-upstream-repos.md](../contributing/fork-upstream-repos.md).

Additional repos (e.g. `ngmt-obs-plugin`) are introduced in later phases; Phase 1 focuses on **forking and licensing** the protocol stack where upstream exists, and **scaffolding** the `ngmt-transport` repo for QUIC work.

## Strategic forking

### Scope

- Fork **critical** upstream repositories: **core protocol** (`libomtnet` → `ngmt-core`) and **codec** (`libvmx` → `ngmt-codec`).
- **Do not** fork a QUIC transport from upstream OMT — it does not exist; **create** `ngmt-transport` as a first-party repository.
- **Defer** non-essential upstream experiments until there is a clear maintainer and CI coverage.
- **Defer** abandoned experiments and duplicate tooling until there is a clear maintainer and CI coverage.
- **Clean the slate:** remove or quarantine legacy paths so new work starts from a coherent baseline (detailed build unification continues in Phase 2).

## CI/CD (cross-platform)

### Requirements

- **Matrix builds** on **Windows**, **macOS**, and **Linux** for every primary repository that ships code.
- **Pull-request gates:** compile (and minimal smoke tests where available) must pass before merge.
- **Artifacts:** versioned build outputs or logs as appropriate for debugging cross-platform failures.

Automation platforms (e.g. GitHub Actions) should be configured early so regressions are caught before they spread across repos.

## Licensing (MIT or Apache-2.0)

### Policy

- Apply a **single permissive choice** (MIT **or** Apache-2.0) consistently across forked repositories so contributors and commercial adopters have clarity.
- Add **LICENSE** files at repository roots; align **SPDX** identifiers and copyright headers in source files per project convention.
- Document any third-party code and its licenses; resolve incompatibilities before declaring a release.

Permissive licensing supports commercial and hardware adoption in **Phase 5** (integrations) and **Phase 6** (hardware and outreach).

## Automated documentation pipelines

### Goals

- Integrate documentation into **CI/CD** (e.g. GitHub Actions): on merge, refresh generated API docs, changelogs, or other generated artifacts as the stack matures.
- Configure **agent-friendly** steps (prompts or scripts) so documentation updates are part of the merge workflow, not an occasional manual pass.
- **Interactive quick-starts** (copy-paste sender/receiver examples) are expanded in Phase 2+ once builds are unified; Phase 1 defines the **pipeline hooks** and ownership.

## System-wide agent rules (`.cursor/rules/`)

### Requirement

- Maintain **`.cursor/rules/`** (for example [`documentation.mdc`](../../.cursor/rules/documentation.mdc) with `alwaysApply: true`) so agents **autonomously update and generate documentation** whenever the codebase evolves (API refs, architecture notes, changelogs, integration guides).
- This complements [00-Master-Roadmap.md](./00-Master-Roadmap.md): always-applied rules load even when work happens in a single submodule (e.g. transport).

## Definition of Done

- [ ] GitHub organization exists and naming matches the planned repo map (`ngmt-core`, `ngmt-transport`, `ngmt-codec`, etc.).
- [ ] Essential repositories are forked; non-essential upstream experiments are not blocking the baseline.
- [ ] CI runs on **Windows**, **macOS**, and **Linux** with PR gates for primary repos.
- [ ] **MIT** or **Apache-2.0** applied consistently; LICENSE and SPDX/header policy documented.
- [ ] Documentation automation is **wired in CI** (workflows merged, documented how to extend them).
- [ ] **`.cursor/rules/`** includes an always-applied rule (e.g. `documentation.mdc`) that states the documentation maintenance mandate.
- [ ] [Master roadmap](./00-Master-Roadmap.md) remains the human-facing index; governance points here and to `.cursor/rules/`.
