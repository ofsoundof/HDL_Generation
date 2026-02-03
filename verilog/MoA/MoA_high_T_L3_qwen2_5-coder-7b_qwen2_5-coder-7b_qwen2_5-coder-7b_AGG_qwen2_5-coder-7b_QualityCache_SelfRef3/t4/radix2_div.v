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

reg signed [8:0] SR;
reg signed [8:0] abs_dividend, abs_divisor;
reg signed [8:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        SR <= 9'b0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        neg_divisor <= 0;
        cnt <= 3'b0;
        start_cnt <= 0;
        result <= 16'b0;
    end else begin
        if (opn_valid && ~res_valid) begin
            abs_dividend <= sign ? ((dividend[7] == 1'b1) ? ~dividend + 1 : dividend) << 1 : dividend << 1;
            abs_divisor <= sign ? ((divisor[7] == 1'b1) ? ~divisor + 1 : divisor) : divisor;
            neg_divisor <= -abs_divisor;
            cnt <= 3'b001;
            start_cnt <= 1;
        end else if (start_cnt && ~opn_valid) begin
            if (cnt == 8'b1000) begin
                SR[9:1] <= {result[7], result};
                SR[0] <= abs_dividend[7];
                res_valid <= 1;
                cnt <= 3'b000;
                start_cnt <= 0;
            end else begin
                SR[8:0] <= SR[7:0] - neg_divisor;
                if (SR[9]) begin
                    SR[8:0] <= SR[7:0] + neg_divisor;
                    result[cnt + 3'b100] <= 1;
                end else begin
                    result[cnt + 3'b100] <= 0;
                end
                SR <= {SR[9], SR[8:1]};
                cnt <= cnt + 3'b001;
            end
        end
    end
end

endmodule