`timescale 1ns/1ps
module atbc(
    input rst,
    input clk,
    output [3:0] q
); // Synchronous binary up counter, TFF based

wire [3:0] t;

assign t[0] = 1'b1;
assign t[1] = q[0];
assign t[2] = &q[1:0];
assign t[3] = &q[2:0];

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : stage
        tff inst (
            .t(t[i]),
            .clk(clk),
            .rst(rst),
            .q(q[i])
        );
    end
endgenerate

endmodule