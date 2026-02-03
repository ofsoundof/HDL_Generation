module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [8:0] SR;
reg [7:0] abs_dividend, abs_divisor, NEG_DIVISOR;
reg [3:0] cnt;
reg start_cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        SR <= 9'b0;
        abs_dividend <= 8'b0;
        abs_divisor <= 8'b0;
        NEG_DIVISOR <= 8'b0;
        cnt <= 4'b0;
        start_cnt <= 1'b0;
    end else if (opn_valid && !res_valid) begin
        abs_dividend <= sign ? ((dividend[7] == 1'b1) ? dividend | 8'hFF : dividend) << 1 : dividend << 1;
        abs_divisor <= sign ? ((divisor[7] == 1'b1) ? divisor | 8'hFF : divisor) : divisor;
        NEG_DIVISOR <= ~abs_divisor + 1;
        SR <= {abs_dividend, 1'b0};
        cnt <= 4'b1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        if (cnt == 8'd8) begin
            SR[8:1] <= {9'b0};
            result[7:0] <= SR[7:0];
            result[15:8] <= SR[8:0];
            res_valid <= 1;
            start_cnt <= 1'b0;
        end else begin
            cnt <= cnt + 4'd1;
            if (SR[9]) begin
                SR <= {SR[8], SR[7:0]};
            end else begin
                SR <= {SR[8], SR[7:0]} - NEG_DIVISOR;
                if (SR[9]) begin
                    SR <= SR + NEG_DIVISOR;
                end
            end
        end
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
    end else if (!res_valid && !opn_valid && SR[7] == 1'b0) begin
        res_valid <= 1;
        result <= {SR[15:8], cnt};
    end
end

endmodule