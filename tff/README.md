# T Flip-Flop

## Overview

Implemented a positive-edge-triggered T (Toggle) flip-flop in Verilog.

The T flip-flop has two possible behaviors:

- `T = 0` → hold the current state
- `T = 1` → toggle the current state

The flip-flop updates `q` only on the rising edge of `clk`.

A synchronous reset is also implemented. When `rst` is high at a rising clock edge, `q` is reset to `0`.

## Behavior

| T | Reset | Q(next) |
|---|-------|---------|
| X | 1     | 0       |
| 0 | 0     | Q       |
| 1 | 0     | ~Q      |

Reset has priority over the T input.

## Files

- `tff.v` — T flip-flop RTL
- `tff_tb.v` — testbench
- `Waveform/` — waveform output inspected using Surfer

## Verification

The testbench verifies:

- The flip-flop initially starts with `q = 0`.
- `T = 0` holds the current state.
- `T = 1` toggles the state on each rising clock edge.
- Asserted `rst` resets `q` to `0` on the next rising clock edge.
- While `rst` remains high, the reset takes priority over toggling.
- After `rst` is deasserted, `T = 1` resumes toggling.
- The waveform was inspected using Surfer.

## Notes

- `posedge clk` makes the flip-flop positive-edge-triggered.
- `T = 0` requires no explicit RTL assignment because the absence of an assignment preserves the current stored value.
- `T = 1` toggles the output using `q <= ~q`.
- `rst` is synchronous because it is evaluated inside the `posedge clk` block.
- The `initial` block establishes `q = 0` at simulation startup. This is separate from the synchronous reset mechanism.
- `q` is declared as `reg` because it is assigned procedurally inside the DUT.