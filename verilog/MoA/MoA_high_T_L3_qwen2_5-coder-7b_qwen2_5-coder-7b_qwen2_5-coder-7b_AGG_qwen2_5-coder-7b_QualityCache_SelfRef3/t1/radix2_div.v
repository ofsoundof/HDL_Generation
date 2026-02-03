module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [8:0] SR;
reg [2:0] cnt;
reg start_cnt;
reg [7:0] NEG_DIVISOR;
reg [7:0] remainder;
reg [7:0] quotient;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        SR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        NEG_DIVISOR <= 0;
        remainder <= 0;
        quotient <= 0;
    end else begin
        if (opn_valid && !res_valid) begin
            abs_dividend <= sign ? (dividend < 0 ? -dividend : dividend) : dividend;
            abs_divisor <= sign ? (divisor < 0 ? -divisor : divisor) : divisor;
            SR <= abs_dividend << 1;
            cnt <= 1;
            start_cnt <= 1;
            NEG_DIVISOR <= ~abs_divisor + 1;
        end else if (start_cnt) begin
            if (cnt == 8) begin
                res_valid <= 1;
                result[7:0] <= remainder;
                result[15:8] <= quotient;
                cnt <= 0;
                start_cnt <= 0;
                res_valid <= 0;
            end else begin
                if (SR < NEG_DIVISOR) begin
                    SR <= SR + abs_divisor << 1;
                    quotient <= quotient + 1 << (7 - cnt);
                end else begin
                    SR <= SR - abs_divisor << 1;
                    quotient <= quotient - 1 << (7 - cnt);
                end
                remainder <= {SR[6:0], SR[7] & ~SR[6]};
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule