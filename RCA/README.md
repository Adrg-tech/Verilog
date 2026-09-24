# Ripple-Carry Adder (RCA)

A parameterized ripple-carry adder written in Verilog.

## Current Design

The RCA is built from 1-bit Full Adder modules connected in a ripple-carry chain.

The design uses:

- A `width` parameter to configure the RCA size
- A `generate` loop to instantiate the required number of Full Adders
- An intermediate carry bus to connect each Full Adder to the next

By default:


WIDTH = 4

The design can be instantiated with other widths.

## Files
Full_adder.v — 1-bit Full Adder
rca.v — parameterized Ripple-Carry Adder
rca_tb.v — testbench
Waveforms/ — waveform files/screenshots
Verification

The current testbench exhaustively tests all combinations of:

4-bit A
4-bit B
Cin

Total test cases:
`2^4 × 2^4 × 2 = 512`

## Tools
Verilog
Icarus Verilog
Surfer