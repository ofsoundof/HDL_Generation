module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);
reg [15:0] a_reg;
reg [7:0] b_reg;

always @(A or B) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    if (b_reg == 0) begin
        result = 16'bFFFF; // Handling division by zero
        odd = 16'h0;
    end else begin
        reg [23:0] q, r;
        q = 24'b0;
        r = {8'b0, a_reg};
        for (integer i = 7; i >= 0; i--) begin
            if (r[i + 7:8] >= b_reg) begin
                r[i + 7:8] = r[i + 7:8] - b_reg;
                q[i] = 1'b1;
            end
        end
        result = {q[15:8], q[7:0]};
        odd = r[15:0];
    end
end

endmodule