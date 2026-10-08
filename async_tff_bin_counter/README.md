# Asynchronous T Flip-Flop Binary Counter (ATBC)

A 4-bit asynchronous binary counter implemented in Verilog using T flip-flops.

## Current Design

The counter is built from four T flip-flops connected in a ripple configuration.

The design uses:

- Four TFFs with their toggle inputs tied to logic HIGH (`1'b1`)
- A `generate` loop to instantiate the higher-order flip-flops
- The output of each stage as the clock input of the next stage
- An asynchronous, active-high reset
- Negative-edge-triggered flip-flops

The counter has four output bits:

`q[3:0]`

## Files

- `tff.v` — Negative-edge-triggered T flip-flop with asynchronous reset
- `atbc.v` — 4-bit asynchronous ripple counter
- `atbc_tb.v` — Testbench
- `Waveforms/` — Waveform files/screenshots inspected using Surfer

## Verification

The testbench verifies:

- Initial reset to `0000`
- Counter operation across multiple falling edges of the external clock
- Ripple behavior between successive flip-flop stages
- Asynchronous reset assertion during simulation
- Counter operation after reset is deasserted
- Waveform behavior inspected using Surfer

The testbench generates a 20 ns clock period and applies reset twice during the simulation.

## Notes

- `negedge clk` makes each TFF negative-edge-triggered.
- `posedge rst` allows the asynchronous reset to take effect independently of the clock.
- The reset is active-high: `rst = 1` forces `q = 0`.
- All T inputs are tied to `1'b1`, so each flip-flop toggles on its active clock edge.
- The LSB flip-flop is clocked by the external clock. Each subsequent flip-flop is clocked by the preceding stage's output.
- The counter is asynchronous because the flip-flops do not share a common clock; transitions propagate through the stages.
- The `initial` block sets the flip-flop output to `0` at simulation startup. This is separate from the asynchronous reset mechanism.
- The actual count sequence depends on the triggering edge and clock connections. The waveform should be used to verify the implemented circuit's behavior rather than assuming a conventional binary up-count sequence.

## Tools

- Verilog
- Icarus Verilog
- Surfer
