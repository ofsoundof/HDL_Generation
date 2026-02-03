module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

always @(*) begin
    reg [4:0] sum_bin;
    sum_bin = A + B + Cin;
    if (sum_bin > 9) begin
        Sum = sum_bin + 6;
        if (Sum > 15)
            Sum = Sum - 6;
        Cout = 1'b1;
    end else begin
        Sum = sum_bin;
        Cout = 1'b0;
    end
end

endmodule