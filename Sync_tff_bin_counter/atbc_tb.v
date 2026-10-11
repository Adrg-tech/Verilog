`timescale 1ns/1ps
module atbc_tb;

reg rst;
reg clk;
wire [3:0] q;

reg [3:0] expected;
reg checking = 0;
integer errors = 0;

atbc dut(.rst(rst), .clk(clk), .q(q));

initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

// reference model: same clock, same sync reset
always @(posedge clk) begin
    if (rst) expected <= 4'b0000;
    else     expected <= expected + 1;
end

// checker: samples on negedge, half a cycle after everything updates
always @(negedge clk)
    if (checking && q !== expected) begin
        $display("ERROR t=%0t: q=%b expected=%b", $time, q, expected);
        errors = errors + 1;
    end

initial begin
    $dumpfile("atbc.vcd");
    $dumpvars(0, atbc_tb);

    rst = 0;
    @(negedge clk) rst = 1;          // initial reset, held for 2 clock edges
    repeat (2) @(negedge clk);
    rst = 0;
    checking = 1;

    repeat (11) @(negedge clk);
    rst = 1;                         // mid-count reset
    repeat (2) @(negedge clk);
    rst = 0;

    repeat (20) @(negedge clk);

    if (errors == 0) $display("PASS");
    else             $display("FAIL: %0d errors", errors);
    $finish;
end

endmodule