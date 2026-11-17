# Testing and Results — 4-bit Magnitude Comparator

[← Back to README](../README.md) · [Project Overview](PROJECT_OVERVIEW.md)

## Testbench methodology

The self-checking testbench [`src/tb/comparator_4bit_tb.v`](../src/tb/comparator_4bit_tb.v) was
added in 2026 by Nafis Afzal; it was not part of the September 2025 submission. It verifies both
reconstructed RTL models:

1. Drives all 16 × 16 = **256** input combinations of `A` and `B`.
2. Compares each model's outputs against an independent reference model (`A > B`, `A == B`,
   `A < B`) evaluated directly on the operand values.
3. Checks the one-hot property — exactly one of `GT`, `EQ`, `LT` is high — for every combination.
4. Re-runs the **13** input vectors from the original Proteus screenshots as a named regression
   list.

## Toolchain and command

```
Icarus Verilog version 12.0 (devel) (s20150603-1539-g2693dd32b)
```

```bash
iverilog -g2005 -Wno-timescale -o build/comparator_4bit_tb.vvp \
         src/rtl/comparator_4bit_procedural.v \
         src/rtl/comparator_4bit_dataflow.v \
         src/tb/comparator_4bit_tb.v
vvp build/comparator_4bit_tb.vvp
```

`-Wno-timescale` suppresses the advisory about the two RTL files having no timescale directive;
they are kept exactly as printed in the 2025 report and are purely combinational.

## Fresh result

| Metric | Result |
|---|---|
| Exhaustive input combinations | 256 |
| Regression cases re-run | 13 |
| Checks performed | 256 |
| Errors | 0 |
| Compile exit status | 0 (no warnings under `-Wno-timescale`) |
| Simulation exit status | 0 |
| Final line | `TESTBENCH RESULT: PASS` |

The regression list covers the same vectors shown in the Proteus captures: equal cases such as
`0 vs 0` and `15 vs 15`, greater-than cases such as `3 vs 1` and `12 vs 11`, and less-than cases
such as `3 vs 5` and `9 vs 10`.

## Proteus evidence

The thirteen genuine Proteus screenshots were checked by reading the switch levels and the lit LED
from each image; all thirteen agree with the expected comparison. They are spot checks, not an
exhaustive proof. See the [Simulation Guide](SIMULATION_GUIDE.md).

## What the results establish — and what they do not

| Verification layer | Evidence | Result |
|---|---|---|
| Verilog procedural model | Exhaustive HDL simulation | 256 / 256 correct |
| Verilog dataflow model | Exhaustive HDL simulation | 256 / 256 correct |
| One-hot property | Exhaustive HDL simulation | 0 violations |
| Proteus 74LS85 schematic | 10 genuine screenshots | 10 / 10 agree |
| Proteus gate-level schematic | 3 genuine screenshots | 3 / 3 agree |
| Physical breadboard | Photographs only | Assembly and powering documented; no specific comparison result established |

The HDL run verifies **source-level Verilog models only**. It does not verify the gate-level
Proteus schematic (no gate-level netlist exists) and is not physical-hardware testing. No timing or
propagation-delay analysis was performed.
