module rca #(parameter width=4)(
    input [width-1:0]a,
    input [width-1:0]b,
    input cin,
    output [width-1:0] sum,
    output carry
);

wire [width:0] cout_intermediate;
genvar i;
assign cout_intermediate[0]=cin;
assign carry=cout_intermediate[width];

generate 
    for (i=0;i<width;i = i + 1) begin
        FA inst(
            .a(a[i]),
            .b(b[i]),
            .c(cout_intermediate[i]),
            .sum(sum[i]),
            .carry(cout_intermediate[i+1])
        );
    end
endgenerate

endmodule;