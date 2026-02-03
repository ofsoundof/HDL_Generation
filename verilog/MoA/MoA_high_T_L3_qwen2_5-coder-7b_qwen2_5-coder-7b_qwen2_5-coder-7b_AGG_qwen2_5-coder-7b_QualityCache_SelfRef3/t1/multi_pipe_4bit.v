module multi_pipe_4bit (
    input wire clk,
    input wire rst_n,
    input wire [3:0] mul_a,
    input wire [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;
reg [7:0] partial_products[size-1:0];
reg [7:0] sum;

// Calculate partial products
generate
    for (genvar i = 0; i < size; i++) begin : gen_partial_products
        assign partial_products[i] = (mul_b[i] == 1'b1) ? mul_a << i : 8'd0;
    end
endgenerate

// Register to store the sum of partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        sum <= 8'd0;
    else begin
        sum <= partial_products[3] + partial_products[2] + partial_products[1] + partial_products[0];
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_out <= 8'd0;
    else
        mul_out <= sum;
end

endmodule