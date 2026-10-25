`timescale 1ns/1ps
module tff(
    input t,
    input clk,
    input rst,
    output reg q
);

always @(posedge clk) begin
    if (rst)    q <= 1'b0;
    else if (t) q <= ~q;
end

endmodule