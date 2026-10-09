# Asynchronous TFF Binary Counter

## Overview
A 4-bit asynchronous (ripple) binary up-counter implemented using T flip-flops (TFFs). Each stage toggles on the falling edge of its clock input, with the output of one stage driving the clock of the next stage.

The counter supports an **asynchronous, active-high reset**, which clears all four bits to `0000`.

## Design
- **Counter width:** 4 bits
- **Flip-flop type:** Negative-edge-triggered T flip-flop
- **Counting sequence:** `0000` → `0001` → `0010` → ... → `1111` → `0000`
- **Reset:** Asynchronous, active-high
- **Architecture:** Ripple counter; each stage is clocked by the preceding stage's output

## Files
- `tff.v` — T flip-flop with asynchronous reset
- `atbc.v` — Top-level 4-bit asynchronous binary counter
- `atbc_tb.v` — Testbench with stimulus, reference model, and output checker
- `Waveform/atbc1_waveform.png` — Captured simulation waveform
- `.gitignore` — Excludes generated simulation artifacts

## Verification

The testbench verifies the counter using a reference model and an automated checker.

### Test scenarios
- Initial reset to establish a known counter state
- Normal counting operation
- Mid-count asynchronous reset, asserted between clock edges
- Continued counting after reset
- Output comparison against the reference model
- Error counting and final `PASS` / `FAIL` report

The checker uses case inequality (`!==`) so that unknown (`X`) or high-impedance (`Z`) output bits are also detected as mismatches.

## Simulation

Using **Icarus Verilog**:

1. Compile the design and testbench:
   ```bash
   iverilog -g2012 -o atbc_sim tff.v atbc.v atbc_tb.v
   ```

2. Run the simulation:
   ```bash
   vvp atbc_sim
   ```

3. Open the generated `atbc.vcd` waveform in **Surfer** to inspect the clock, reset, counter output, reference value, and checking behavior.

## Tools
- Verilog HDL
- Icarus Verilog
- Surfer (waveform inspection)