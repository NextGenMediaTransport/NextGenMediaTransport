# Fork upstream Open Media Transport repositories

Use the **GitHub CLI (`gh`)** for org forks and new repos. Confirm slugs on [openmediatransport — repositories](https://github.com/orgs/openmediatransport/repositories) before running commands. Legacy names like `omt-core`, `omt-transport-quic`, and `omt-codec-vmx` are **not** on that listing and will return **HTTP 404** if used with `gh repo fork`.

## Prerequisites

- [GitHub CLI](https://cli.github.com/) (`gh`) installed.
- `gh auth login` with an account that can create repositories in the **NextGenMediaTransport** org.

## Forks (from `openmediatransport`)

```bash
# Core — OMT protocol reference implementation (.NET) → ngmt-core
gh repo fork openmediatransport/libomtnet --org NextGenMediaTransport --fork-name ngmt-core --clone

# Codec — VMX → ngmt-codec
gh repo fork openmediatransport/libvmx --org NextGenMediaTransport --fork-name ngmt-codec --clone
```

## New repository (no upstream fork)

Upstream OMT uses **TCP** for media ([`PROTOCOL.md`](https://github.com/openmediatransport/libomtnet/blob/master/PROTOCOL.md)); there is **no** QUIC transport repo to fork. **`ngmt-transport`** is a **first-party** NGMT repository for QUIC/WAN work:

```bash
gh repo create NextGenMediaTransport/ngmt-transport --public --description "NGMT QUIC/WAN transport (first-party implementation)"
```

Clone locally if needed: `gh repo clone NextGenMediaTransport/ngmt-transport`.

## Local layout (inside this workspace)

Clone the org repos **into the root of this meta repository** (alongside `docs/`, `.github/`, etc.):

```text
NextGenMediaTransport/       # meta: docs, CI, roadmap (this tree)
  docs/
  .github/
  ngmt-core/                 # fork — origin → org, upstream → openmediatransport/libomtnet
  ngmt-codec/                # fork — origin → org, upstream → openmediatransport/libvmx
  ngmt-transport/            # first-party (may be empty until first commit)
```

Clone from the meta repo root:

```bash
cd /path/to/NextGenMediaTransport
gh repo clone NextGenMediaTransport/ngmt-core
gh repo clone NextGenMediaTransport/ngmt-codec
gh repo clone NextGenMediaTransport/ngmt-transport
```

Forks created with `gh repo fork … --clone` run from that same directory place the new folder next to `docs/`. `gh repo clone` checks out `origin` (the org fork) and, for forks, configures **`upstream`** to the Open Media Transport repository for pulls.

Nested clones are listed in `.gitignore` so the meta repository does not commit upstream fork contents; keep working copies on disk only (or use Git submodules later if you adopt that workflow).

## After forks

Apply baseline hygiene per repo (`LICENSE`, `.github/workflows/`, `README.md`, `CHANGELOG.md`) consistent with the NGMT meta-repo; Phase 2 unifies CMake/Cargo builds.
