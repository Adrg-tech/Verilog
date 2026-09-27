`timescale 1ns/1ps;

module FS_tb;

reg a;
reg b;
reg c;
wire diff;
wire borrow;
integer i;
integer j;
integer k;

FS uut(
    .a(a),
    .b(b),
    .c(c),
    .diff(diff),
    .borrow(borrow)
);

initial begin
    $dumpfile("Full_sub.vcd");
    $dumpvars(0,FS_tb);

    for (i=0;i<2;i+=1) begin
        a=i;
        for (j=0;j<2;j+=1) begin
            b=j;
            for (k=0;k<2;k+=1) begin
                c=k;
                #10;
            end
        end
    end
end

endmodule