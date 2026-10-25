`timescale 1ns/1ps
module bg #(
    parameter baud=4,
    parameter f_clk=4,
    parameter ovs=1       //oversampling
) (
    input clk,
    input rst,
    output baud_tick,
    output [$clog2((f_clk/(baud*ovs))+1)-1:0]q
);

localparam N=(f_clk/(baud*ovs));

mnc #(.baud_width($clog2(N+1)))inst1(             //Note that clog arg is truncated. N+1 accounts for powers of N
    .rst(rst),
    .clk(clk),
    .N(N),
    .q(q),
    .baud_tick(baud_tick)
);



endmodule