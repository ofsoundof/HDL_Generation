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
    reg [7:0] ABS_DIVISOR;
    reg [3:0] cnt;
    reg start_cnt;
    reg NEG_DIVISOR;
    reg [7:0] temp_sub;
    reg carry_out;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 9'b0;
            ABS_DIVISOR <= 8'b0;
            cnt <= 4'b0;
            start_cnt <= 1'b0;
            NEG_DIVISOR <= 1'b0;
            temp_sub <= 8'b0;
            carry_out <= 1'b0;
            res_valid <= 1'b0;
        end else if (opn_valid && !res_valid) begin
            SR[8:1] <= sign ? {~dividend[7], dividend} : {dividend, 1'b0};
            ABS_DIVISOR <= sign ? {~divisor[7], divisor} : divisor;
            cnt <= 4'b1;
            start_cnt <= 1'b1;
            NEG_DIVISOR <= sign ? 1'b1 : 1'b0;
        end else if (start_cnt) begin
            if (cnt == 8'd7) begin
                SR[8:1] <= temp_sub;
                res_valid <= 1'b1;
                start_cnt <= 1'b0;
            end else begin
                cnt <= cnt + 1;
                SR <= {carry_out, SR[8:1]};
                temp_sub <= SR - ABS_DIVISOR;
                carry_out <= temp_sub[8];
            end
        end
    end

endmodule