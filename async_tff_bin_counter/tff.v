module tff(
    input t,
    input clk,
    input rst,
    output reg q
);//asynch,negedge active tff for counter

initial begin //start at a defined q value
    q<=1'b0;
end

always @ (negedge clk or posedge rst) begin //asynch rst for atbc. Negedge is used for up counter. If posedge is used, counting goes from 0000->1111->1110->1101...(Jumps to 15, starts decreasin...)
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