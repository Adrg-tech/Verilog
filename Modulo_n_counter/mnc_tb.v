`timescale 1ns/1ps
module mnc_tb;

localparam W = 3;

reg rst;
reg clk;
reg  [W-1:0] N;
wire [W-1:0] q;
wire baud_tick;

reg [W-1:0] expected;
reg checking = 0;
integer errors = 0;

mnc #(.baud_width(W)) dut(
    .rst(rst), .clk(clk), .N(N), .q(q), .baud_tick(baud_tick)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// reference model
always @(posedge clk) begin
    if (rst || expected == N-1) expected <= 0;
    else                        expected <= expected + 1;
end
wire ref_tick = (expected == N-1);

// checker
always @(negedge clk)
    if (checking && (q !== expected || baud_tick !== ref_tick)) begin
        $display("ERROR t=%0t: q=%b exp=%b tick=%b ref=%b",
                 $time, q, expected, baud_tick, ref_tick);
        errors = errors + 1;
    end

initial begin
    $dumpfile("mnc.vcd");
    $dumpvars(0, mnc_tb);

    N = 5;
    rst = 0;
    @(negedge clk) rst = 1;
    @(negedge clk) rst = 0;
    checking = 1;

    repeat (20) @(negedge clk);
    @(negedge clk) rst = 1;      // mid-count reset
    @(negedge clk) rst = 0;
    repeat (20) @(negedge clk);

    if (errors == 0) $display("PASS");
    else             $display("FAIL: %0d errors", errors);
    $finish;
end

endmodule