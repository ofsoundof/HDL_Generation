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
    reg [3:0] cnt, start_cnt;

    wire [7:0] sub_result;
    wire carry_out;
    reg [15:0] tmp_result;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 0;
            result <= 0;
            abs_dividend <= 0;
            abs_divisor <= 0;
            SR <= 0;
            cnt <= 0;
            start_cnt <= 0;
            tmp_result <= 0;
        end else if (opn_valid && !res_valid) begin
            abs_dividend <= sign ? -dividend : dividend;
            abs_divisor <= sign ? -divisor : divisor;
            SR <= {abs_dividend, 1'b0};
            NEG_DIVISOR <= ~abs_divisor + 1;
            cnt <= 4'd1;
            start_cnt <= 4'd1;
        end else if (start_cnt) begin
            if (cnt == 4'd8) begin
                SR <= {abs_dividend, 1'b0};
                cnt <= 4'd0;
                start_cnt <= 0;
                tmp_result[7:0] <= SR[7:0];
                tmp_result[15:8] <= SR[15:8];
                res_valid <= 1;
            end else begin
                sub_result <= SR - abs_divisor;
                carry_out <= ~sub_result[0];
                if (carry_out) begin
                    SR[7:0] <= SR[6:0];
                end else begin
                    SR[7:0] <= {SR[6:1], 1'b1};
                end
                cnt <= cnt + 4'd1;
            end
        end
    end

endmodule