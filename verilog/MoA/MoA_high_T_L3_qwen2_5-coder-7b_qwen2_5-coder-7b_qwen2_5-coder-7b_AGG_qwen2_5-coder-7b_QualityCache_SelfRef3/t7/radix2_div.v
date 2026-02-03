module radix2_div (
    clk,
    rst,
    sign,
    dividend,
    divisor,
    opn_valid,
    res_valid,
    result
);
    input clk, rst, sign, opn_valid;
    input [7:0] dividend, divisor;
    output reg res_valid;
    output reg [15:0] result;

    wire signed [8:0] abs_dividend = sign ? {1'b0, -dividend} : dividend;
    wire signed [8:0] abs_divisor = sign ? {1'b0, -divisor} : divisor;
    reg signed [15:0] SR;
    reg [2:0] cnt;
    reg start_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 0;
            result <= 0;
            SR <= {16{4'b0}};
            cnt <= 3'b000;
            start_cnt <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                SR <= {abs_dividend, 1'b0};
                start_cnt <= 1'b1;
            end else if (start_cnt) begin
                if (cnt == 3'b100) begin
                    cnt <= 3'b000;
                    start_cnt <= 1'b0;
                    result[15:8] <= SR[15:8];
                    result[7:0] <= SR[7:0];
                end else begin
                    if (SR[15:8] >= abs_divisor) begin
                        SR <= {SR[7:0], 1'b0};
                        SR[15:9] <= SR[15:9] - abs_divisor;
                    end else begin
                        SR <= {SR[7:0], 1'b1};
                        SR[15:9] <= SR[15:9] + abs_divisor;
                    end
                    cnt <= cnt + 1;
                end
            end
        end
    end

endmodule