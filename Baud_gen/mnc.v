`timescale 1ns/1ps
module mnc #(parameter baud_width=4)(
    input rst,
    input clk,
    input [baud_width-1:0] N,
    output [baud_width-1:0] q,
    output baud_tick
);

wire [baud_width-1:0] t;
wire wrap = (q == N-1);        // terminal count
wire clr  = rst | wrap;        // clear on reset OR terminal count

genvar i;
generate
    for (i = 0; i < baud_width; i = i + 1) begin : stage
        if (i == 0) begin : g_t
            assign t[i] = 1'b1;
        end else begin : g_t
            assign t[i] = &q[i-1:0];
        end

        tff inst (
            .t(t[i]),
            .clk(clk),
            .rst(clr),
            .q(q[i])
        );
    end
endgenerate

assign baud_tick = wrap;       // 1-cycle pulse on the last count

endmodule