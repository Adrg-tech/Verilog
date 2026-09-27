# Full Subtractor

## Overview

Implemented a full subtractor in Verilog.

A full subtractor performs binary subtraction of three inputs:

- `a` — minuend
- `b` — subtrahend
- `c` — borrow-in

It produces:

- `diff` — difference
- `borrow` — borrow-out

## Logic

### Difference
`diff = a ^ b ^ c`

### Borrow
`borrow = (~a & b) | (~a & c) | (b & c)`

## Files

- `FS.v` — Full subtractor RTL
- `FS_tb.v` — Testbench
- `Full_sub.vcd` — Simulation waveform

## Verification

The testbench exhaustively tests all 8 combinations of `a`, `b`, and `c`.

The resulting waveforms were inspected using Surfer to verify the expected difference and borrow outputs.