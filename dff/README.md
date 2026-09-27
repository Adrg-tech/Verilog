# D Flip-Flop

## Overview

Implemented a positive-edge-triggered D flip-flop with synchronous reset in Verilog.

The flip-flop samples the value of `d` on the rising edge of `clk` and stores it in `q`.

When `rst` is asserted, `q` is reset to `0` on the next rising edge of `clk`.

## Behavior

| rst | At posedge clk | Q(next) |
|-----|----------------|---------|
| 1   | Reset          | 0       |
| 0   | Store D        | D       |

## Files

- `dff.v` — D flip-flop RTL
- `dff_tb.v` — testbench
- `Waveforms/` — waveform output inspected using Surfer

## Verification

The testbench applies different values of `d` and `rst` while generating an independent clock.

The waveform was inspected using Surfer to verify:

- Data is captured only on the rising edge of `clk`.
- `q` holds its previous value between clock edges.
- Synchronous reset forces `q` to `0` on a rising clock edge when `rst` is asserted.
- Reset does not directly modify `d`.

## Notes

- `posedge clk` makes the flip-flop positive-edge-triggered.
- The reset is **synchronous** because it is evaluated inside the `posedge clk` block.
- `<=` is used for the sequential assignment to `q`.
- `d` and `q` remain uninitialized/undefined at the start -which is done on purpose to study such behaviour
  
