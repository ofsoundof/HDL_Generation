module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg <= A;
    b_reg <= B;
end

always @(*) begin
    if (b_reg == 0) begin
        result = 16'b0;
        odd = A;
    end else begin
        reg [15:0] quotient;
        reg [15:0] remainder;
        reg [31:0] dividend;

        dividend = {8'b0, a_reg};
        quotient = 16'b0;
        remainder = 8'b0;

        for (int i = 15; i >= 0; i--) begin
            remainder <<= 1;
            remainder[0] = dividend[i];
            if (remainder >= b_reg) begin
                remainder -= b_reg;
                quotient[i] = 1;
            end
        end

        result = quotient;
        odd = remainder;
    end
end

endmodule