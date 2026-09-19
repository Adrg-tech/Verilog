module mux(
    input wire [3:0]I,
    input wire [1:0]S,
    output reg O
);
always @(*) begin
    case(S)
    2'b00: O=I[0];
    2'b01: O=I[1];
    2'b10: O=I[2];
    2'b11: O=I[3];
    default:O=1'b0;
    endcase
    end
endmodule
