module jkff(
    input j,
    input k,
    input clk,
    output reg q
);

always @ (posedge clk) begin
    case ({j,k}) 
        2'b01: q<= 1'b0;
        2'b10: q<=1'b1;
        2'b11: q<=~q;
    endcase
end

endmodule
