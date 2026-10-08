module atbc(
    input rst,
    input clk,
    output [3:0] q
); //"Asynchronous TFF binary counter (ripple)"

genvar i;

tff inst0(
    .t(1'b1),
    .clk(clk),
    .rst(rst),
    .q(q[0])
);


generate
    for (i=1;i<4;i=i+1) begin : stage
        tff inst1 (
            .t(1'b1),
            .clk(q[i-1]),
            .rst(rst),
            .q(q[i])
        );
    end
endgenerate


endmodule