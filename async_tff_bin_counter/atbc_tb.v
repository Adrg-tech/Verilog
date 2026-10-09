`timescale 1ns/1ps

module atbc_tb;

reg rst;
reg clk;
wire [3:0] q;

reg [3:0] expected;
reg checking = 0;
integer errors = 0;

atbc dut(.rst(rst), .clk(clk), .q(q));

// clock
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

// reference model
always @(posedge rst) expected = 4'b0000;
always @(negedge clk)
    if (!rst) expected <= expected + 1;

// checker
always @(posedge clk)
    if (checking && q !== expected) begin
        $display("ERROR t=%0t: q=%b expected=%b", $time, q, expected);
        errors = errors + 1;
    end

// stimulus
initial begin
    $dumpfile("atbc.vcd");
    $dumpvars(0, atbc_tb);

    rst = 0;
    #5  rst = 1;            // initial reset pulse
    #20 rst = 0;
    checking = 1;           // q is now known, start checking

    repeat (11) @(negedge clk);
    #5  rst = 1;            // mid-count reset, between clock edges
    #10 rst = 0;

    repeat (20) @(negedge clk);

    if (errors == 0) $display("PASS");
    else             $display("FAIL: %0d errors", errors);
    $finish;
end

endmodule