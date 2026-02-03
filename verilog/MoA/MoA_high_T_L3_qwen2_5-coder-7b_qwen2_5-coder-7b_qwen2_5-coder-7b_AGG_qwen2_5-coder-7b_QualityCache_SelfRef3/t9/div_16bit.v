module div_16bit(A, B, result, odd);
    input [15:0] A;
    input [7:0] B;
    output reg [15:0] result;
    output reg [15:0] odd;

    always @(*) begin
        if (B == 0) begin
            result = 16'hFFFF;
            odd = A;
        end else begin
            result = 0;
            odd = A;
            for (int i = 15; i >= 8; i--) begin
                odd = {odd[7:0], odd[15:8]};
                if (odd[15:8] >= B) begin
                    odd = odd - B;
                    result[i] = 1;
                end
            end
        end
    end

endmodule