# SR Flip-Flop

## Overview
Implemented a positive-edge-triggered SR flip-flop in Verilog.

The flip-flop updates its stored state on the rising edge of `clk`.

## SR Behavior

| S | R | Q(next) | Operation |
|---|---|---------|-----------|
| 0 | 0 | Q       | Hold      |
| 0 | 1 | 0       | Reset     |
| 1 | 0 | 1       | Set       |
| 1 | 1 | X       | Invalid   |

## Files

- `srff.v` — SR flip-flop RTL
- `srff_tb.v` — testbench

## Verification

The testbench cycles through all four S/R input combinations and applies clock transitions to verify the flip-flop's behavior.

The waveform was inspected using Surfer.

## Notes

- `posedge clk` makes the storage element edge-triggered.
- `00` preserves the existing state.
- `11` is an invalid SR condition and is represented as `X` in simulation.