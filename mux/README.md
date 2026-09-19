# 4:1 Multiplexer

A 4:1 multiplexer designed in Verilog and verified using an exhaustive testbench.

## Files

- `mux.v` — Verilog RTL implementation of the 4:1 multiplexer
- `mux_tb.v` — Testbench used to simulate and verify the multiplexer
- `.gitignore` — Prevents generated simulation files from being tracked

## How it works

The multiplexer has:

- 4 data inputs: `I[3:0]`
- 2 select inputs: `S[1:0]`
- 1 output: `O`

The select signal determines which input is passed to the output:

| S | O |
|---|---|
| `00` | `I[0]` |
| `01` | `I[1] |
| `10` | `I[2] |
| `11` | `I[3] |

## Simulation

The project was compiled and simulated using Icarus Verilog.

Compile:

```bash
iverilog -o mux_sim mux.v mux_tb.v