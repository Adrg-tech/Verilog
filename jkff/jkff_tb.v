`timescale 1ns/1ps

module jkff_tb;

reg j;
reg k;
reg clk;
wire q;

jkff dut(
    .j(j),
    .k(k),
    .clk(clk),
    .q(q)
);

initial begin
    clk=0;
    forever #5 clk=~clk;
end

initial begin
    $dumpfile("jkff.vcd");
    $dumpvars(0,jkff_tb);

    j=1'b0;
    k=1'b0;
    #10; //Expected to "hold", but since no prior value given, expected to "hold" X

    j=1'b0;
    k=1'b1;
    #10;  //q=0

    j=1'b1;
    k=1'b0;
    #10;  //q=1

    j=1'b0;
    k=1'b0;
    #10;  //q=1 (hold)

    j=1'b1;
    k=1'b1;
    #10;  //q=0 (compliment of held q val)

    $finish;

end

endmodule