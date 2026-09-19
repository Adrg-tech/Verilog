`timescale 1ns/1ps;

module FA_tb;

reg a;
reg b;
reg c;
wire sum;
wire carry;
integer i;
integer j;
integer k;

FA uut(
    .a(a),
    .b(b),
    .c(c),
    .sum(sum),
    .carry(carry)
);

initial begin
    $dumpfile("Full_adder.vcd");
    $dumpvars(0,FA_tb);

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