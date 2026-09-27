# JK Flip-Flop

## Overview

Implemented a positive-edge-triggered JK flip-flop in Verilog.

The JK flip-flop extends the SR flip-flop by giving the `J=1, K=1` input combination a defined behavior: toggling the current output.

The flip-flop updates `q` only on the rising edge of `clk`.

## Behavior

| J | K | Q(next) |
|---|---|---------|
| 0 | 0 | Q (hold) |
| 0 | 1 | 0       |
| 1 | 0 | 1       |
| 1 | 1 | ~Q (toggle) |

## Files

- `jkff.v` — JK flip-flop RTL
- `jkff_tb.v` — testbench
- `Waveforms/` — waveform output inspected using Surfer

## Verification

The testbench applies all four JK input combinations while generating an independent clock.

The waveform was inspected using Surfer to verify:

- `q` updates only on the rising edge of `clk`.
- `J=0, K=1` resets `q` to `0`.
- `J=1, K=0` sets `q` to `1`.
- `J=0, K=0` holds the current value of `q`.
- `J=1, K=1` toggles `q`.
- An initially uninitialized `q` remains `X` while the flip-flop is commanded to hold until a set or reset operation establishes a known state.

## Notes

- `posedge clk` makes the flip-flop positive-edge-triggered.
- `00` requires no explicit RTL assignment because the absence of an assignment preserves the current stored value.
- `11` toggles the current output using `q <= ~q`.
- `q` is declared as `reg` because it is assigned inside an `always` block.
- The initial `X` state is intentionally observed in simulation rather than explicitly initialized.