module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output reg [7:0] y,
    output reg Cout
);

assign {y, Cout} = a + b + Cin;

endmodule