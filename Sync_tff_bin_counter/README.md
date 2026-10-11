# Synchronous TFF Binary Counter

## Overview

A 4-bit synchronous binary up-counter implemented using T flip-flops (TFFs). All four flip-flops share the same clock and update on its rising edge.

Each stage toggles when its corresponding T input is high. The least significant bit toggles on every clock edge, while each higher bit toggles when all lower-order bits are high.

The counter supports a **synchronous, active-high reset**, which clears all four bits to `0000` on the next rising clock edge.

## Design

- **Counter width:** 4 bits
- **Flip-flop type:** Positive-edge-triggered T flip-flop
- **Counting sequence:** `0000` → `0001` → `0010` → ... → `1111` → `0000`
- **Reset:** Synchronous, active-high
- **Architecture:** Synchronous counter; all flip-flops share a common clock
- **Toggle conditions:**
  - `t[0] = 1'b1` — LSB toggles on every rising clock edge
  - `t[1] = q[0]` — Bit 1 toggles when bit 0 is high
  - `t[2] = &q[1:0]` — Bit 2 toggles when both lower bits are high
  - `t[3] = &q[2:0]` — Bit 3 toggles when all three lower bits are high
- **Implementation:** Parameter-free, generate-based instantiation of four TFFs

## Files

- `tff.v` — Positive-edge-triggered T flip-flop with synchronous, active-high reset
- `atbc.v` — Top-level 4-bit synchronous binary up-counter using generated TFF instances
- `atbc_tb.v` — Testbench with stimulus, reference model, and automated output checker
- `Waveform/atbc1_waveform.png` — Captured simulation waveform
- `.gitignore` — Excludes generated simulation artifacts

## Verification

The testbench verifies the counter against a reference model that increments on each rising clock edge and resets synchronously when `rst` is asserted.

An automated checker compares the DUT output against the reference model on the falling clock edge, half a cycle after the rising-edge updates.

### Test scenarios

- Initial reset to establish a known counter state
- Normal binary up-counting
- Mid-count synchronous reset
- Continued counting after reset deassertion
- Output comparison against the reference model
- Error counting and final `PASS` / `FAIL` report

The checker uses case inequality (`!==`) so that unknown (`X`) and high-impedance (`Z`) output bits are also detected as mismatches.

The testbench generates a 20 ns clock period, with a 50% duty cycle. It also generates an `atbc.vcd` waveform for inspection.

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


## What changed from commit 2(asynch)->3(synch)
What I changed and why
- tff: negedge clk to posedge clk. The negedge trick only existed for the ripple chain. In a synchronous design everything shares one clock, so use the normal rising edge.
- tff: deleted the initial block. It was unreliable (the time-0 race), and the reset
now does that job.
- atbc: removed the ripple chain. All four flops get .clk(clk).
- atbc: added the t wires. This is what makes counting work without ripple. Bit 0 always toggles, bit 1 toggles when q[0] is 1, bit 2 when q[1:0] is 11, and bit 3 when q[2:0] is 111. That's the carry, computed combinationally.
- Testbench: the reference model is now synchronous. The old model had always @(posedge rst), which is async behavior and would make correct hardware fail the check.
- Testbench: rst changes on negedge clk. The DUT samples on posedge, so changing rst half a cycle away avoids any race. It's also held for 2 edges, since a synchronous reset needs to be high at a rising edge.
- Testbench: the checker samples on negedge. The DUT and model both update on posedge, so they've settled by the next negedge.
- Cleaned the leftover comments. The old ones said "asynch" and "ripple".
- Progression: 1st commit and 2nd commit had asynch, 3 had synch
- An observation: WF assertation for rst ends when the 3rd clk negedge starts (for: "rst = 1;
repeat (2) @(negedge clk)"
). It doesnt end on the posedge- meaning the negedge is the decider