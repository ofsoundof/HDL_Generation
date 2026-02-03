module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
wire [7:0] temp [0:7];
reg [15:0] sum;
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
        sum <= 0;
        mul_out_reg <= 0;
    end else begin
        mul_en_out_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
        temp[0] = mul_a_reg & mul_b_reg[7:0];
        temp[1] = mul_a_reg & (mul_b_reg[6:0] << 1);
        temp[2] = mul_a_reg & (mul_b_reg[5:0] << 2);
        temp[3] = mul_a_reg & (mul_b_reg[4:0] << 3);
        temp[4] = mul_a_reg & (mul_b_reg[3:0] << 4);
        temp[5] = mul_a_reg & (mul_b_reg[2:0] << 5);
        temp[6] = mul_a_reg & (mul_b_reg[1:0] << 6);
        temp[7] = mul_a_reg & (mul_b_reg[0] << 7);

        sum <= temp[0];
        for (integer i = 1; i < 8; i = i + 1) begin
            sum <= sum + temp[i];
        end

        if (mul_en_out_reg) begin
            mul_out_reg <= sum;
        end else begin
            mul_out_reg <= 16'b0;
        end
    end
end

assign mul_en_out = mul_en_out_reg[7];

assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule