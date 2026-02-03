module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [23:0] a_reg;
integer i;

always @(*) begin
    a_reg = {A, 8'b0};
    result = 16'b0;
end

always @(*) begin
    for (i = 0; i < 16; i = i + 1) begin
        if ((a_reg >> (15 - i)) >= B) begin
            result[i] = 1'b1;
            a_reg = (a_reg >> (15 - i)) - B << (15 - i);
        end else begin
            a_reg = a_reg << 1;
        end
    end
end

assign odd = a_reg;

endmodule