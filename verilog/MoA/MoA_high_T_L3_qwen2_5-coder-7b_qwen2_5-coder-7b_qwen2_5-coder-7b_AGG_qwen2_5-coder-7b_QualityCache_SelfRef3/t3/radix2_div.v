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

reg signed [8:0] abs_dividend;
reg signed [8:0] neg_divisor;
wire signed [9:0] sub_result;
reg [7:0] SR;
reg [2:0] cnt;
reg start_cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
        result <= 16'b0;
    end else begin
        if (opn_valid && !res_valid) begin
            abs_dividend <= sign ? -dividend : dividend;
            neg_divisor <= sign ? -divisor : divisor;
            SR <= {abs_dividend, 1'b0};
            cnt <= 3'b0;
            start_cnt <= 1'b1;
        end else if (start_cnt) begin
            if (cnt == 3'b100) begin
                cnt <= 3'b0;
                start_cnt <= 1'b0;
                res_valid <= 1'b1;
                result <= {SR[9:8], SR[7:0]};
            end else begin
                sub_result = SR - neg_divisor;
                if (sub_result >= 0) begin
                    SR <= {sub_result[8:0], 1'b1};
                end else begin
                    SR <= {sub_result[8:0], 1'b0};
                end
                cnt <= cnt + 3'b001;
            end
        end else if (res_valid) begin
            res_valid <= 1'b0;
        end
    end
end

endmodule