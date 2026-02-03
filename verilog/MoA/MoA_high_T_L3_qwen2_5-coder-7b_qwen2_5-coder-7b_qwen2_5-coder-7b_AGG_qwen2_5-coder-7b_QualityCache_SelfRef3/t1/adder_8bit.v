module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output reg [7:0] sum,
    output reg cout
);

wire [8:0] carry;

assign carry[0] = cin;
generate
for (genvar i = 0; i < 8; i++) begin : full_adder_loop
    assign {carry[i+1], sum[i]} = a[i] + b[i] + carry[i];
end
endgenerate

assign cout = carry[8];

endmodule