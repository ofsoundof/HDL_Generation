module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    if (b_reg == 0) begin
        result = 16'b0;
        odd = A;
    end else begin
        reg [15:0] quotient = 0;
        reg [15:0] remainder = a_reg;

        for (integer i = 15; i >= 0; i--) begin
            remainder = {remainder[14:0], 1'b0};
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[i] = 1;
            end
        end

        result = quotient;
        odd = remainder;
    end
end

endmodule