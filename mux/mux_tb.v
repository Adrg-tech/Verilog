`timescale 1ns/1ps

module mux_tb;
reg [3:0] I;
reg [1:0]S;
wire O;
integer i;
integer s;

mux utt(
    .I(I),
    .S(S),
    .O(O)
);

initial begin 

    $dumpfile("mux.vcd");
    $dumpvars(0,mux_tb);

    for (i=0;i<16;i+=1) begin
        for (s=0;s<4;s+=1) begin
            I=i;
            S=s;
            #10;
        end
    end

end

endmodule