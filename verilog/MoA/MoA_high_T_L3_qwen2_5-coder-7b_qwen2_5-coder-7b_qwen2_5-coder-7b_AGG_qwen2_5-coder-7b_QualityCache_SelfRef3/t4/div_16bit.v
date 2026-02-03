module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [31:0] quotient, remainder;

always @(*) begin
    a_reg = A;
    b_reg = B;
    if (b_reg == 0) begin
        result = 16'b0;
        odd = a_reg;
    end else begin
        quotient = 0;
        remainder = {8'b0, a_reg};
        for (integer i = 15; i >= 0; i--) begin
            remainder = (remainder << 1) | (remainder[31] ^ b_reg);
            if (remainder[32:16] >= b_reg) begin
                quotient[i] = 1;
                remainder[31:16] -= b_reg;
            end
        end
        result = quotient;
        odd = remainder[15:0];
    end
end

endmodule