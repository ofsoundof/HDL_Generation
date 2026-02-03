module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [65:0] result,
    output reg o_en
);

reg [63:0] a_reg;
reg [63:0] b_reg;
wire [64:0] sum;
wire carry_out;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        if (i_en) begin
            a_reg <= adda;
            b_reg <= addb;
        end
        sum = a_reg + b_reg + carry_out;
        carry_out = sum[64];
        result = {carry_out, sum[63:0]};
        o_en <= i_en & (sum[64] | carry_out);
    end
end

assign carry_out = (a_reg[63] & b_reg[63]) | (a_reg[63] & sum[63]) | (b_reg[63] & sum[63]);

endmodule