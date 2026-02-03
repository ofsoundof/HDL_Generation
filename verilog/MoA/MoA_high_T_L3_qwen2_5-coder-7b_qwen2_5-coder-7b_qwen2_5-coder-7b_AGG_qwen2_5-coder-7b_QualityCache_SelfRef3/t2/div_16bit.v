module div_16bit (
    input  [15:0] A,
    input  [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [16:0] quotient;
reg [16:0] remainder;

always @(A or B) begin
    a_reg <= A;
    b_reg <= B;
end

always @(*) begin
    quotient = 0;
    remainder = {8'b0, a_reg};
    for (int i = 15; i >= 0; i--) begin
        if (remainder[16:9] >= b_reg) begin
            result[i] = 1;
            remainder[16:9] = remainder[16:9] - b_reg;
        end else begin
            result[i] = 0;
        end
    end
end

assign odd = remainder;

endmodule