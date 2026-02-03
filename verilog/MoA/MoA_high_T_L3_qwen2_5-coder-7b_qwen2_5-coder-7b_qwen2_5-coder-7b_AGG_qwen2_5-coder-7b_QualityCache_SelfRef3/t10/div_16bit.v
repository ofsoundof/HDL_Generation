module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [23:0] a_reg;
reg [7:0] b_reg;
reg [15:0] remainder;
reg [15:0] quotient;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    if (b_reg == 0) begin
        result = 16'b0;
        odd = a_reg;
    end else begin
        remainder = a_reg;
        quotient = 16'b0;
        for (int i = 15; i >= 0; i--) begin
            if (remainder[23:8] >= b_reg) begin
                quotient[i] = 1;
                remainder = {remainder[7], remainder[23:9]} - b_reg;
            end else begin
                remainder = {remainder[7], remainder[23:9]};
            end
        end
        odd = {remainder, a_reg[7:0]};
    end
end

endmodule