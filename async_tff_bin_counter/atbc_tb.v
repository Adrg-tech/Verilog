`timescale 1ns/1ps

module atbc_tb;

reg rst;
reg clk;
wire [3:0] q;

atbc dut(
    .rst(rst),
    .clk(clk),
    .q(q)
);

initial begin
    clk=0;
    forever #10 clk=~clk;
end

initial begin
    $dumpfile("atbc.vcd");
    $dumpvars(0,atbc_tb);

    #5;
    rst=1'b1; //tried it without reset ,but even with the q<=1'b0; line in the tff, q dint become 0 -  thats cuz q<=~q; could fire off @ time 0, (and q=x, uknown), I got q=x in the WF. SO to prevent that and not rely solely on the initial block in tff (which dint work anyway lol), Js did a quick rst @ the beggining...
    #10;

    rst=1'b0;
    repeat (11) @(negedge clk);
    #5;
    rst=1'b1;
    #10;
    rst=1'b0;
    #10;
    repeat (17) @(negedge clk);

    $finish;
    
end

endmodule