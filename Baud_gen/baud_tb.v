`timescale 1ns/1ps
module baud_tb;

//localparam W = 3;

reg rst;
reg clk;
localparam baud=12_500_000;               //Change baud here!!
localparam f_clk=300_000_000;      //Change f_clk here!!
localparam ovs=2;                 //Change Oversampling here!!
localparam N=f_clk/(baud*ovs);
wire [$clog2(N+1)-1:0] q;
wire baud_tick;

initial $display("N = %0d", N);

reg [$clog2(N+1)-1:0] expected;
reg checking = 0;
integer errors = 0;

bg #(
    .baud(baud),
    .f_clk(f_clk),       
    .ovs(ovs)
) dut (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .q(q)
);

localparam real hc=1e9/f_clk/2;        //Half cycle of clk timing calculated here!!

initial begin
    clk = 0;                   
    forever #(hc) clk = ~clk;          
end

// reference model
always @(posedge clk) begin
    if (rst || expected == N-1) expected <= 0;
    else expected <= expected + 1;
end

wire ebt = (expected == N-1);    //"ebt- Expected baud tick". Reads as "ebt is a wire that is always equal to the result of expected == N-1".expected == N-1 is a comparison. It gives 1 if expected equals N-1, and 0 otherwise.
//Its best not to use "always @(posedge clk)     if (expected == N-1) ebt <= 1;", but the line above cuz that would update late (onlyl next clk cycle), but wires would update right away. So, if it were a reg, ebt would assert only when expected==0 ,one clk cycle late, which is not intended...

// checker
always @(negedge clk)
    if (checking && (expected!== q || baud_tick !== ebt)) begin
        $display("ERROR t=%0t: q=%b expected=%b tick=%b ref=%b  ",
                     $time, q, expected, baud_tick, ebt);
        errors = errors + 1;
    end

initial begin
    $dumpfile("baud.vcd");
    $dumpvars(0, baud_tb);

    rst = 0;
    @(negedge clk) rst = 1;
    @(negedge clk) rst = 0;
    checking = 1;

    repeat (4) @(negedge clk);
    @(negedge clk) rst = 1;      // mid-count reset
    @(negedge clk) rst = 0;
    repeat (3*N) @(negedge clk);  //3*N checks multiple loops

    if (errors == 0) $display("PASS");
    else             $display("FAIL: %0d errors", errors);
    $finish;
end

endmodule