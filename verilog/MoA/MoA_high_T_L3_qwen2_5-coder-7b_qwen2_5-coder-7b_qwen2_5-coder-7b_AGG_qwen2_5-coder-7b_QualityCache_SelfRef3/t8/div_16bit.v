module div_16bit (
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

always @(*) begin
    reg [15:0] a_reg, b_reg;
    reg [15:0] quotient = 0;
    reg [15:0] remainder = 0;
    
    a_reg = A;
    b_reg = B;
    
    for (int i = 15; i >= 8; i--) begin
        if (remainder[7:0] >= b_reg) begin
            quotient[i - 8] = 1;
            remainder[7:0] = remainder[7:0] - b_reg;
        end
        remainder = {1'b0, remainder[15:8]};
    end
    
    result = quotient;
    odd = remainder;
end

endmodule