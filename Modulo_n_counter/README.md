# Modulo-N Counter

## Overview

A parameterized modulo-N binary up-counter implemented using T flip-flops (TFFs). The counter increments on each rising clock edge and resets to `000...0` when the terminal count is reached.

The counter width is configurable through the `baud_width` parameter, while the modulus is supplied dynamically through the `N` input. The counter counts from `0` to `N-1`, then returns to `0`.

The design supports a **synchronous, active-high reset**, which clears the counter on the next rising clock edge when `rst` is asserted. A `baud_tick` output indicates when the counter reaches its terminal count.

## Design

- **Counter width:** Parameterized through `baud_width`
- **Modulus:** Dynamically configurable through the `N` input
- **Flip-flop type:** Positive-edge-triggered T flip-flop
- **Counting sequence:** `0` → `1` → `2` → ... → `N-1` → `0`
- **Reset:** Synchronous, active-high
- **Terminal count:** `q == N-1`
- **Output pulse:** `baud_tick = (q == N-1)`
- **Architecture:** Synchronous counter; all flip-flops share a common clock
- **Toggle conditions:**
  - `t[0] = 1'b1` — LSB toggles on every rising clock edge
  - `t[i] = &q[i-1:0]` for `i > 0` — Each higher bit toggles when all lower-order bits are high
- **Counter clearing:** `clr = rst | wrap`, where `wrap` indicates that the terminal count has been reached
- **Implementation:** Generate-based instantiation of parameterized TFF stages

## Files

- `tff.v` — Positive-edge-triggered T flip-flop with synchronous, active-high reset
- `mnc.v` — Parameterized modulo-N counter using generated TFF instances
- `mnc_tb.v` — Testbench with stimulus, reference model, and automated output checker
- `mnc.vcd` — Generated simulation waveform
- `.gitignore` — Excludes generated simulation artifacts

## Verification

The testbench verifies the counter against a reference model that increments on each rising clock edge and returns to zero when reset is asserted or the terminal count is reached.

An automated checker compares the DUT output against the reference model on the falling clock edge, half a cycle after the rising-edge updates.

The testbench uses a counter width of 3 bits and sets `N = 5` to verify modulo-5 operation.

### Test scenarios

- Initial reset to establish a known counter state
- Normal modulo-5 counting from `0` through `4`
- Automatic wraparound from `4` to `0`
- Mid-count reset
- Continued counting after reset deassertion
- Comparison of the DUT counter and `baud_tick` against the reference model
- Error counting and final `PASS` / `FAIL` report

The checker uses case inequality (`!==`) so that unknown (`X`) and high-impedance (`Z`) values are also detected as mismatches.

The testbench generates a 10 ns clock period, with a 50% duty cycle. It also generates an `mnc.vcd` waveform for inspection.

## Simulation

Using **Icarus Verilog**:

1. Compile the design and testbench:

   ```bash
   iverilog -Wall -o mnc_sim mnc.v tff.v mnc_tb.v
   ```

2. Run the simulation:

   ```bash
   vvp mnc_sim
   ```

   Alternatively, run both steps using the provided shell script:

   ```bash
   bash run.sh
   ```

3. Open the generated `mnc.vcd` waveform in **Surfer** to inspect the clock, reset, counter output, terminal-count pulse, reference value, and checking behavior.

   ```bash
   surfer ./mnc.vcd
   ```

## Tools

- Verilog HDL
- Icarus Verilog
- Surfer (waveform inspection)

