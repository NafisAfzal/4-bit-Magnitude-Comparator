# 4-bit Magnitude Comparator

A 4-bit magnitude comparator designed and verified as a group project for **CSE345 — Digital Logic
Design** (Summer 2025, Section 6), Department of Computer Science and Engineering, East West
University. Submitted September 2nd, 2025 to Nishat Tasnim.

The circuit compares two 4-bit unsigned inputs, `A` and `B`, and produces three mutually exclusive
outputs: `GT` (`A > B`), `EQ` (`A = B`) and `LT` (`A < B`).

## Team

- Nafis Afzal
- Anik Saha
- Ashiqur Rahman Sohan
- Raiyan Fardin Haque

## Design

Comparison is resolved from the most significant bit downwards; the first differing bit pair
decides the result. Each bit pair is compared with XNOR for equality, and the greater/less-than
terms are qualified by the equality of all higher bits. Exactly one output is high for every input
pair (`GT + EQ + LT = 1`).

The original project implemented the function as a gate-level circuit and with a 74LS85 comparator
IC, both simulated in Proteus and prototyped on a breadboard. Two Verilog descriptions, reconstructed
from the code printed in the 2025 report, are provided here:

| File | Description |
|---|---|
| [`src/rtl/comparator_4bit_procedural.v`](src/rtl/comparator_4bit_procedural.v) | Procedural model using an `always @(*)` block |
| [`src/rtl/comparator_4bit_dataflow.v`](src/rtl/comparator_4bit_dataflow.v) | Dataflow model using continuous `assign` statements |
| [`src/tb/comparator_4bit_tb.v`](src/tb/comparator_4bit_tb.v) | Self-checking testbench (added in 2026 by Nafis Afzal; not part of the 2025 submission) |

## Running the simulation

Requires [Icarus Verilog](https://steveicarus.github.io/iverilog/) (tested with version 12.0).

```bash
iverilog -g2005 -Wno-timescale -o build/comparator_4bit_tb.vvp \
         src/rtl/comparator_4bit_procedural.v \
         src/rtl/comparator_4bit_dataflow.v \
         src/tb/comparator_4bit_tb.v
vvp build/comparator_4bit_tb.vvp
```

## Verification

The testbench was compiled and run freshly with Icarus Verilog 12.0 (devel). Both commands exited
with status 0 and no warnings under `-Wno-timescale`.

| Check | Result |
|---|---|
| Exhaustive sweep of all 16 × 16 = 256 input pairs, both models | 256 / 256 correct |
| Regression vectors from the original Proteus captures | 13 cases, all correct |
| Checks performed | 256 |
| Errors | 0 |
| Result | `TESTBENCH RESULT: PASS` |

These results verify the **Verilog source models only**. They are not a verification of the
Proteus schematics (no gate-level netlist is available) and are not physical-hardware testing of
the breadboard prototype.

## Reports

| File | Description |
|---|---|
| [`reports/01_Original_Submitted_Report_2025-09-02.pdf`](reports/01_Original_Submitted_Report_2025-09-02.pdf) | The original submitted report, 16 pages, with student identifiers removed for repository distribution. |
| [`reports/02_Revised_Report_2026-11-17.pdf`](reports/02_Revised_Report_2026-11-17.pdf) | The revised report, 19 pages — the current edition. |

The two PDFs are distinct editions: the first is the historical 2025 record (technical content
unchanged except for identifier removal), and the second is the current revised report.

## Repository structure

```
README.md
.gitignore
reports/
  01_Original_Submitted_Report_2025-09-02.pdf
  02_Revised_Report_2026-11-17.pdf
src/
  rtl/comparator_4bit_procedural.v
  rtl/comparator_4bit_dataflow.v
  tb/comparator_4bit_tb.v
```

## Licensing

This is collaborative academic coursework. No open-source licence has been granted; the contents
are provided for academic review and reference only.
