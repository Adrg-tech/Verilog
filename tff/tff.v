module tff(
    input t,
    input clk,
    input rst,
    output reg q
);

initial begin
    q<=1'b0;
end

always @ (posedge clk) begin
    if (rst) begin
        q<=1'b0;
    end
    else begin
        if (t) begin
            q<=~q; //toggle
        end
    end
end

endmodule