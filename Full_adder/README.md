# 1-Bit Full Adder

A 1-bit full adder designed in Verilog and verified using an exhaustive testbench.

## Files

- `FA.v` — Verilog RTL implementation of the 1-bit full adder
- `FA_tb.v` — Testbench used to simulate and verify the full adder
- `.gitignore` — Prevents generated simulation files from being tracked

## How It Works

A full adder adds three 1-bit inputs:

- `a` — first input bit
- `b` — second input bit
- `c` — carry-in

It produces two outputs:

- `sum` — result bit
- `carry` — carry-out bit

The logic is:

```text
sum   = a ⊕ b ⊕ c
carry = (a · b) + (c · (a ⊕ b))
```
Truth Table
a	b	c	sum	carry
0	0	0	0	0
0	0	1	1	0
0	1	0	1	0
0	1	1	0	1
1	0	0	1	0
1	0	1	0	1
1	1	0	0	1
1	1	1	1	1
## Simulation

The project was compiled and simulated using Icarus Verilog.

Compile:

`iverilog -o FA_sim FA.v FA_tb.v`

Run:

`vvp FA_sim`

The testbench generates a VCD waveform file (Full_adder.vcd), which can be viewed using a waveform viewer such as Surfer.

## Verification

The testbench exhaustively tests all 8 possible combinations of the three 1-bit inputs.

The generated waveform was inspected to verify that sum and carry match the expected full-adder behavior.



