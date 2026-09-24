`timescale 1ns/1ps

module rca_tb;

reg [3:0]a;
reg [3:0]b;
reg cin;
wire [3:0]sum;
wire carry;
integer i;
integer j;
integer k;

rca utt(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .carry(carry)
);

initial begin
    $dumpfile("rca.vcd");
    $dumpvars(0,rca_tb);
    for (i=0;i<16;i+=1) begin
        for (j=0;j<16;j+=1) begin
            for (k=0;k<2;k+=1) begin
                a=i;
                b=j;
                cin=k;
                #10;
            end
        end
    end
end

endmodule;