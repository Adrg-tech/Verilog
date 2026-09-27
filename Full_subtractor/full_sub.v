module FS(
    input a,
    input b,
    input c,
    output diff,
    output borrow
);

assign diff= a ^ b ^ c;
assign borrow=(~a&b)|(~a&c)|(b&c);

endmodule