`timescale 1ns/1ps

module dff_tb;

reg d;
reg clk;
reg rst;
wire q;

dff dut(
    .d(d),
    .clk(clk),
    .rst(rst),
    .q(q)
);

initial begin
    clk=0;
    forever #5 clk=~clk;
end

initial begin
    $dumpfile("dff.vcd");
    $dumpvars(0,dff_tb);
    #0 rst=1'b1;
    #10 d=1'b1;   //10
    #10 rst=1'b0; //20
    #10 d=1'b0;   //30
    #10 d=1'b1;   //40
    #10 rst=1'b1; //50
    #10 rst=1'b0; //60
    #10 d=1'b0;   //70
    $finish;
end

endmodule

