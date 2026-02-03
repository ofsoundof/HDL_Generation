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

reg [15:0] SR;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] NEG_DIVISOR;
reg [7:0] abs_dividend;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        SR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        NEG_DIVISOR <= 0;
        abs_dividend <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            if (sign == 1'b1) begin
                abs_dividend <= {1'b0, dividend};
                NEG_DIVISOR <= {1'b0, ~divisor} + 1;
            end else begin
                abs_dividend <= dividend;
                NEG_DIVISOR <= ~divisor + 1;
            end
            SR <= {abs_dividend, 1'b0};
            cnt <= 3'd0;
            start_cnt <= 1'b1;
        end else if (start_cnt) begin
            if (cnt == 3'd7) begin
                start_cnt <= 1'b0;
                res_valid <= 1;
                result[15:8] <= SR[7:0];
                result[7:0] <= SR[15:8];
            end else begin
                cnt <= cnt + 1;
                if (SR[15:8] >= NEG_DIVISOR) begin
                    SR <= {SR[7], SR[14:0], 1'b0};
                end else begin
                    SR <= {SR[6:0], 1'b1, 1'b0};
                end
            end
        end else if (res_valid && !/* result has been consumed */) begin
            res_valid <= 0;
        end
    end
end

endmodule