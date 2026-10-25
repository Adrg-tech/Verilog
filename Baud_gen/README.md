# Baud Rate Tick Generator

## Overview

A parameterized baud-rate tick generator implemented using a modulo-N binary counter built from T flip-flops (TFFs).

The generator derives the required counter modulus from the system clock frequency (`f_clk`), the desired baud rate (`baud`), and the oversampling factor (`ovs`). The counter increments on each rising clock edge and returns to zero after reaching its terminal count.

The output `baud_tick` indicates the terminal-count condition, producing a one-clock-cycle pulse every N clock cycles under normal operation.

The design is modular, separating baud-rate configuration, modulo-N counting, and T flip-flop implementation.

## Design

- **Baud-rate configuration:** Parameterized through `baud`
- **Clock frequency:** Parameterized through `f_clk`
- **Oversampling:** Parameterized through `ovs`
- **Counter modulus:** `N = f_clk / (baud * ovs)`
- **Counter width:** `$clog2(N+1)`
- **Counting sequence:** `0` → `1` → `2` → ... → `N-1` → `0`
- **Flip-flop type:** Positive-edge-triggered T flip-flop
- **Reset:** Synchronous, active-high
- **Terminal count:** `q == N-1`
- **Output pulse:** `baud_tick = wrap`, where `wrap` indicates the terminal-count condition
- **Architecture:** Synchronous counter; all flip-flops share a common clock
- **Toggle conditions:**
  - `t[0] = 1'b1` — The LSB toggles on every rising clock edge.
  - `t[i] = &q[i-1:0]` for `i > 0` — Each higher-order bit toggles when all lower-order bits are high.
- **Counter clearing:** The counter clears on reset or terminal count, using `clr = rst | wrap`.
- **Implementation:** Generate-based instantiation of parameterized TFF stages.

### Baud-rate relationship

The counter modulus is calculated as:

`N = f_clk / (baud * ovs)`

Where:

- `f_clk` is the input clock frequency in Hz.
- `baud` is the desired baud rate in baud/s.
- `ovs` is the oversampling factor.
- `N` is the number of input-clock cycles per generated tick.

For example, with `f_clk = 100 MHz`, `baud = 12.5 MHz`, and `ovs = 1`:

`N = 100,000,000 / (12,500,000 * 1) = 8`

The counter therefore counts from `0` through `7`, then returns to `0`, generating a tick every 8 input-clock cycles.

**Note:** This implementation uses integer division. The chosen parameters should produce the intended integer modulus. Otherwise, the generated tick rate may differ from the requested baud rate.

## Files

- `bg.v` — Baud-rate generator; calculates the modulus and instantiates the modulo-N counter.
- `mnc.v` — Parameterized modulo-N counter using generated TFF instances.
- `tff.v` — Positive-edge-triggered T flip-flop with synchronous, active-high reset.
- `baud_tb.v` — Testbench containing clock generation, stimulus, a reference model, and an automated output checker.
- `baud.vcd` — Generated simulation waveform.
- `.gitignore` — Excludes generated simulation artifacts, if configured.

## Verification

The testbench verifies the DUT against an independent reference counter.

The reference model increments on each rising clock edge and returns to zero when reset is asserted or the terminal count is reached. Its value is compared against the DUT's counter output, while a continuously evaluated reference tick (`ebt`) checks the DUT's `baud_tick` output.

The checker runs on the falling clock edge, half a clock cycle after the rising-edge updates. This allows the counter outputs and reference model to settle before comparison.

### Test scenarios

- Initial reset to establish a known counter state.
- Normal modulo-N counting.
- Automatic wraparound from `N-1` to `0`.
- Mid-count reset.
- Continued counting after reset deassertion.
- Verification across multiple counting cycles (`3*N` falling-edge checks after the mid-count reset).
- Comparison of the DUT counter and `baud_tick` against the reference model.
- Error counting and final `PASS` / `FAIL` report.

The checker uses case inequality (`!==`) so that unknown (`X`) and high-impedance (`Z`) values are also detected as mismatches.

The testbench generates a 10 ns clock period using a real-valued half-period calculation. It also generates `baud.vcd` for waveform inspection.

## Simulation

Using **Icarus Verilog**:

1. Compile the design and testbench:

   ```bash
   iverilog -Wall -o baud_sim bg.v mnc.v tff.v baud_tb.v
   ```

2. Run the simulation:

   ```bash
   vvp baud_sim
   ```

3. Inspect the generated waveform in **Surfer**:

   ```bash
   surfer ./baud.vcd
   ```

Observe the clock, reset, counter output `q`, terminal-count pulse `baud_tick`, reference counter `expected`, reference tick `ebt`, and checking behavior.

A successful simulation should print `PASS`. If mismatches occur, the testbench reports the simulation time, actual and expected counter values, and actual and reference tick values before printing the final error count.

### Configuration notes

To change the operating point, modify the `baud`, `f_clk`, and `ovs` parameters in the testbench and ensure the same configuration reaches the DUT.

The selected parameters must also produce a valid positive integer modulus, and the counter width must accommodate the range from `0` through `N-1`.

## Tools

- Verilog HDL
- Icarus Verilog
- Surfer (waveform inspection)

## Things learnt over the course of the design:

- Param and localparam are buildtime consts, but wires or regs (signals in general) are runtime values
- A clk input port and f_clk parameter may look redundant- but one is the actual hardware with the signal, the other is a design choice metric that influences timing. Bottom line: we cant figure out f_clk from i/p clk signal, but vice verca is possible (cuz freq of clk influences clk i/p port's signal, whose half cycle is determined by the parameter "f_clk" )
Another takeaway:anything that sets a width must be a parameter or localparam, never a signal...
- Ref mnc instantiation, baud.v code; the $clog() arguement has N+1, not N, cuz that accounts for powers of 2. Say ,N=8; clog2(N) is 3 ([3-1:0] gives [2:0]; 3 bits as needed) BUT, 8 requires 4 bits (1000).&#x20;
- (Ref `localparam hc`; file: **\*\*baud_tb.v\*\***)
`0.5*(1/f_clk)` evaluates `1/f_clk` as integer division first, which gives 0. A real-valued, ns-scaled expression is needed, like `localparam real HALF_NS = 1e9 / f_clk / 2;`. The half-period becomes 0 otherwise, and the clock never advances in time. 1e9 is 1*10^9, ie, 1 sec converted to ns (the unit used by the timescale). "Real" ensures its a decimal val, not int (which would make it 0).
- (Ref reference model, `ebt`; file: **\*\*baud_tb.v\*\***)
The DUT's `baud_tick` is a wire computed from `q` (`q == N-1`). If `ebt` is assigned with `<=` in an `always @(posedge clk)`, it updates one clock later and the checker flags false errors. Make `ebt = (expected == N-1)` a continuous assignment instead, so the two line up in time. GENERALLY SPEAKING, its best to design assertation of a ctrl signal like this, to avoid (unintended) delays
Fun fact: An analogy from C: it’s closer to a macro or a live formula than to a one-time assignment. In C, int ebt = (expected == N-1); computes once and stores the result. Here, ebt is like a spreadsheet cell with the formula =expected==N-1. Change expected and the cell updates by itself.

## Limitations
- Does NOT handle the following edge case: baud>clk
- Does not compute error percentage and chose appropriate N ,for a decimal value of N; takes floor by default, even if ceiling might have a lower error percentage

## Waveforms
- WF 1 tests for N=10
- WF 2 tests for N=8 (edge case- power of 2)
- WF 3 tests for N=12, and with ovs=2 as well (ovs remained the default 1 in the above 2 test cases)