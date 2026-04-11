# Building NGMT on Fedora (Workstation)

This guide targets **Fedora Workstation** (x86_64 or AArch64), **Fedora 40+** (including **43** used in the impairment lab). It covers **Rust** siblings: **`ngmt-transport`**, **`ngmt-studio`** (Generator + Monitor), and optional **`ngmt-core`**. It does **not** replace per-repo READMEs; it maps **Fedora packages** to what CI installs on **Ubuntu** for Linux GUI builds, then **[clones the GitHub org repos](#3-clone-the-git-repositories)** listed under [NextGenMediaTransport on GitHub](https://github.com/orgs/NextGenMediaTransport/repositories).

## 1. Base tooling

Install a C/C++ toolchain, CMake, and Git (needed for **`ngmt-codec`** via **`ngmt-vmx-sys`** and for **`ngmt-core`**):

```bash
sudo dnf install @development-tools cmake ninja-build git pkgconf-pkg-config
```

Use **`rustup`** for Rust (recommended so your toolchain matches upstream CI and you can switch `stable` easily):

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
rustup default stable
```

Fedora’s **`rust` / `cargo` RPMs** can work for a quick try, but `rustup` avoids version skew with `edition` / MSRV in the repos.

## 2. Studio (egui / eframe) — native GUI dependencies

Meta-repo CI on Ubuntu installs:

- `libgtk-3-dev`
- `libxcb-shape0-dev`
- `libxcb-xfixes0-dev`

On Fedora, install GTK 3, X11/XCB, input, OpenGL, and **ALSA** ( **`ngmt-generator`** uses **`cpal`** for audio device enumeration; link failures are common without **`alsa-lib-devel`** ):

```bash
sudo dnf install gtk3-devel libxcb-devel libX11-devel libXrandr-devel libXi-devel \
  libXcursor-devel mesa-libGL-devel libxkbcommon-devel wayland-devel \
  alsa-lib-devel
```

If **`cargo check`** in **`ngmt-studio`** still complains about a missing **`pkg-config`** package, install the RPM that provides the named `.pc` file (see [Troubleshooting](#5-troubleshooting)).

**Wayland vs X11:** Fedora defaults to Wayland; these packages cover both paths for **`winit`** / **`eframe`**. For a minimal X11-only session, the same set usually suffices.

## 3. Clone the Git repositories

Official NGMT repositories live under the **[NextGenMediaTransport](https://github.com/NextGenMediaTransport)** GitHub organization. Browse them at **[github.com/orgs/NextGenMediaTransport/repositories](https://github.com/orgs/NextGenMediaTransport/repositories)** (meta docs, **`ngmt-transport`**, **`ngmt-codec`**, **`ngmt-core`**, **`ngmt-studio`**, etc.).

### Recommended layout (meta repo as parent folder)

Clone the **meta** repository first, then clone each **code** repo **into** that directory so **`ngmt-studio`**, **`ngmt-transport`**, and **`ngmt-codec`** are **siblings** (required by **`ngmt-vmx-sys`** and the Studio workspace). Nested folders are typically **gitignored** inside the meta checkout but remain on disk for local builds — same pattern as [Fork upstream repos](../contributing/fork-upstream-repos.md).

```bash
git clone https://github.com/NextGenMediaTransport/NextGenMediaTransport.git
cd NextGenMediaTransport

git clone https://github.com/NextGenMediaTransport/ngmt-transport.git
git clone https://github.com/NextGenMediaTransport/ngmt-codec.git
git clone https://github.com/NextGenMediaTransport/ngmt-studio.git
# optional — C++ core / CMake
git clone https://github.com/NextGenMediaTransport/ngmt-core.git
```

**With [GitHub CLI](https://cli.github.com/)** (`gh auth login`):

```bash
gh repo clone NextGenMediaTransport/NextGenMediaTransport
cd NextGenMediaTransport
gh repo clone NextGenMediaTransport/ngmt-transport
gh repo clone NextGenMediaTransport/ngmt-codec
gh repo clone NextGenMediaTransport/ngmt-studio
# optional — C++ core / CMake
gh repo clone NextGenMediaTransport/ngmt-core
```

Forks, **`upstream`** remotes, and org policies are described in [Fork upstream repos](../contributing/fork-upstream-repos.md).

### Directory layout after clone

```text
NextGenMediaTransport/          # meta — docs/, docs/build/linux-fedora.md, .github/, …
  ngmt-transport/
  ngmt-codec/
  ngmt-studio/
  ngmt-core/                    # optional
```

From here, **`cargo`** commands for Studio use **`ngmt-studio/`** as the working directory; **`../ngmt-codec`** and **`../ngmt-transport`** resolve relative to that crate workspace.

## 4. Build and run

Use a shell whose **current directory** is the **meta** checkout root — the folder that **contains** `ngmt-transport/`, `ngmt-codec/`, `ngmt-studio/` (and optionally `ngmt-core/`) as in [§3](#3-clone-the-git-repositories).

### `ngmt-transport`

```bash
cd ngmt-transport
cargo build --release
cargo test
cd ..
```

### `ngmt-studio` (requires **`../ngmt-codec`** and **`../ngmt-transport`**)

```bash
cd ngmt-studio
cargo build --release
cargo run --release --bin ngmt-generator
# other terminal:
cargo run --release --bin ngmt-monitor
cd ..
```

The first **`ngmt-codec`** build can take several minutes (CMake **Release** VMX library).

**Optional file logging** (impairment / audit): set **`NGMT_LOG_FILE`** before each process; use **two paths** if Generator and Monitor run on the same host — see [Harness setup](../testing/harness_setup.md).

### `ngmt-core` (optional CMake)

Skip this block if you did not clone **`ngmt-core`**.

```bash
cd ngmt-core
cmake -B build -S . -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
cd ..
```

## 5. Troubleshooting

| Symptom | What to try |
|--------|-------------|
| **`failed to run custom build command`** for **`ngmt-vmx-sys`** / **`ngmt-codec`** | Confirm **`ngmt-codec`** is a **sibling** of **`ngmt-studio`**, **`cmake`** and **`gcc-c++`** are installed, and the tree is on a path **without spaces** if CMake scripts misbehave (spaces are supported on many setups but are a common footgun). |
| **Missing `libngmt-codec.so`** at runtime | Rebuild **`ngmt-studio`**; **`ngmt-vmx-sys`** sets **rpath** to the CMake output for **Linux** debug/release binaries. Run from **`ngmt-studio/`** with `cargo run` so the working tree matches the build. |
| **GTK / XCB / GL** link errors when building **`eframe`** | Install the Studio package set in [§2](#2-studio-egui--eframe--native-gui-dependencies); run `dnf provides */foo.pc` if **`pkg-config`** names a missing module. |
| **`alsa`** / **`cpal`** link errors | `sudo dnf install alsa-lib-devel`. |

## 6. Related docs

- [Harness setup](../testing/harness_setup.md) — **`tc` / `netem`** on Fedora for **2% / 5% / 10%** loss methodology.
- [WLAN simulation](../testing/wlan-simulation.md) — baseline vs impaired methodology.
- [ngmt-studio README](https://github.com/NextGenMediaTransport/ngmt-studio/blob/main/README.md) — app behavior, VMX path, **`NGMT_LOG_FILE`**.

Ubuntu equivalents for CI are in [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml) (**`ngmt-studio`** step).
