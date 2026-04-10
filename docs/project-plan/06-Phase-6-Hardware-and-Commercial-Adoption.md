---
title: "Phase 6 — Hardware and Commercial Adoption"
phase: 6
status: planned
---

## Overview

Phase 6 extends NGMT from software-only adoption to **deployable hardware** and **commercial ecosystems**: open **reference designs**, **protocol extensions** for PTZ and tally, and **outreach** so vendors can embed NGMT confidently.

## Open-source hardware reference designs

### Example direction

- Publish a **low-cost reference design** (e.g. **Raspberry Pi 5** with HDMI capture) that encodes to NGMT and streams over the LAN/WAN, with BOM, wiring, and software image or build instructions.
- Goal: prove real-world viability and give integrators a blueprint to clone or customize.

## PTZ control and tally lights

### Goals

- Define **versioned schemas** (or message formats) for **PTZ control** and **tally** state carried alongside or within the media transport protocol, as appropriate.
- Document extension points, backward compatibility, and security considerations (authentication, rate limits) for control-plane traffic.

## Commercial outreach and hardware integration

### Strategy

- Leverage **MIT** or **Apache-2.0** licensing (established in Phase 1) to reduce legal friction for **OEMs** and **hardware vendors**.
- Publish **clear** integration paths: SDKs (Phase 5), certification criteria (if any), and support channels.
- Engage **broadcast**, **pro-AV**, and **developer** communities through docs, demos, and reference hardware success stories.

## Definition of Done

- [ ] At least one **reference hardware** design documented (schematics, software, limitations).
- [ ] **PTZ** and **tally** schemas drafted, versioned, and stored in-repo with examples.
- [ ] **Outreach** materials exist (e.g. partner/commercial page, contact path, or contribution guide for vendors).
- [ ] Strategic alignment with [Phase 1](./01-Phase-1-Foundation-and-Forking.md) licensing and [Phase 5](./05-Phase-5-Integrations-and-Ecosystem.md) SDKs is explicit in published docs.
