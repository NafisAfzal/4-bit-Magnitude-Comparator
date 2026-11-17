# Licensing and Usage

[← Back to README](../README.md)

This document separates what is **verified** in the repository from what remains an **unresolved**
permission question. It does not grant any new licence.

## Verified facts

| Item | Finding |
|---|---|
| Licence files | No `LICENSE`, `LICENCE`, `COPYING`, `NOTICE` or `AUTHORS` file exists in the repository. |
| Existing statement | `README.md` states: collaborative academic coursework; no open-source licence has been granted; contents are provided for academic review and reference only. |
| Report PDFs | The original and revised PDFs contain no copyright line in their text layers. They name Proteus, the SN74LS85, Labcenter, Texas Instruments and Icarus Verilog in the body text. |
| Reports' provenance | The original PDF is the September 2025 submission with four student identifiers removed for distribution; the revised PDF is the later editorial edition. Neither was modified for licensing purposes. |
| Images | All 17 published PNG assets are genuine project images extracted from the original report. No stock or generated imagery is included. |
| Third-party references | The SN74LS85 datasheet, Proteus Design Suite and IEEE 1364-2005 are referenced, not redistributed. The university logo appears only inside the report PDFs. |
| Badges | Four static badges reference tools actually used and are served by an external badge service; they are not project images. |
| Team | Four named Group 7 members; no individual ownership split is recorded in the original report. |

## Unresolved permission questions

- Permission from **all four contributors** to apply an explicit open-source licence has not been
  established. Repository ownership does not by itself establish exclusive ownership of every
  team contribution.
- The Proteus captures are images of a licensed third-party application's output. They may depict
  software interfaces owned by Labcenter Electronics, and the team may not be able to relicense
  those images.
- The datasheet and IEEE standard are referenced only; any rights in them belong to their
  respective owners and are not granted here.
- The original report was a collaborative academic submission. No document in the repository
  records an assignment of copyright or a licence grant from each member.

## Recommendation

**Retain the repository without an explicit open-source licence for now.** This matches the existing
README notice and avoids implying permissions that have not been verified.

- Do **not** add MIT, Apache-2.0, GPL, Creative Commons or any other licence to the whole repository
  on the assumption that the repository owner can license every contribution.
- Keep the existing copyright and usage notice in the README; do not remove or weaken it.
- Do not relicense the report PDFs, Proteus screenshots, block diagrams or breadboard photographs.
- If a licence is wanted later, obtain explicit agreement from all four contributors, then confirm
  whether third-party software imagery may be included under that licence.
- A narrower, file-specific licence for later original material (for example the 2026 testbench or
  newly written documentation) could be considered separately, but only with clear file-level
  boundaries and the contributor's agreement. No such licence is granted here.

## Usage guidance

These materials are provided for academic review and educational reference. Redistribution,
relicensing or reuse as the basis of another project requires the agreement of all four
contributors. The project is not endorsed by, and does not grant rights to, the vendors of the tools
or software depicted in the screenshots.
