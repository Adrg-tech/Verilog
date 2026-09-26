`timescale 1ns/1ps

module srff_tb;

reg s;
reg r;
reg clk;
wire q;
integer i,j,k;

srff dut(
    .s(s),
    .r(r),
    .clk(clk),
    .q(q)
);

initial begin
    clk=0;
    forever #5 clk=~clk;
end

initial begin
    $dumpfile("srff.vcd");
    $dumpvars(0,srff_tb);
    for (i=0;i<2;i=i+1) begin
        for (j=0;j<2;j=j+1) begin
            s=i;
            r=j;
            #10;
        end
    end
    $finish;
end

endmodule;