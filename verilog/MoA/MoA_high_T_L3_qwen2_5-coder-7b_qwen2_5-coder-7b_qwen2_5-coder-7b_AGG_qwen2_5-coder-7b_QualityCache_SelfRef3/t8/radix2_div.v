module radix2_div(
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
    reg [7:0] neg_divisor;
    reg [8:0] SR;
    reg [2:0] cnt;
    reg start_cnt;
    wire [7:0] sub_result;
    wire carry_out;

    assign abs_dividend = sign ? -dividend : dividend;
    assign neg_divisor = sign ? -abs_divisor : abs_divisor;
    assign sub_result = SR[8:1] - neg_divisor;
    assign carry_out = (SR[8:1] < neg_divisor) ? 1'b1 : 1'b0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            SR <= {abs_dividend, 1'b0};
            cnt <= 3'b000;
            start_cnt <= 1'b0;
            result <= 16'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                abs_divisor <= dividend[7] ? -abs_dividend : abs_dividend;
                neg_divisor <= sign ? -abs_dividend : abs_dividend;
                SR <= {abs_dividend, 1'b0};
                cnt <= 3'b001;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 8'b1000) begin
                    SR[7:0] <= SR[8:1];
                    cnt <= 3'b000;
                    start_cnt <= 1'b0;
                    result <= {SR, 8'b0};
                    res_valid <= 1'b1;
                end else begin
                    SR[7:0] <= SR[8:1];
                    if (carry_out) begin
                        SR[8] <= 1'b0;
                        cnt <= cnt + 3'b001;
                    end else begin
                        SR[8] <= carry_out;
                        result[15 - cnt -: 8] <= neg_divisor[7:0];
                        cnt <= cnt + 3'b001;
                    end
                end
            end
        end
    end

endmodule