`timescale 1ns/1ps

module tff_tb;

reg t;
reg clk;
reg rst;
wire q;

tff dut(
    .t(t),
    .clk(clk),
    .rst(rst),
    .q(q)
);

initial begin
    clk=0;
    forever #5 clk=~clk;
end

initial begin
    $dumpfile("tff.vcd");
    $dumpvars(0,tff_tb);

    //q starts off @ 0, initialized beforehand

    t=1'b0; //hold- q=0
    #10;
    t=1'b1; //toggle- q=1
    #10;
    rst=1'b1; //reset active- q=0 @ posedge
    #10;
    t=1'b1; //toggle. Expected q=1, BUT reset is still high, ie; remains q=0 (Note that toggle remains high unless specified otherwise)
    #10;
    rst=1'b0; //reset low. Toggle still high, so on posedge, q=1
    #10;
    t=1'b0; //hold- q=1
    #10;
    t=1'b1; //toggle- q=0
    #10;

    $finish;

end

endmodule