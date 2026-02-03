module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [NUM_DIV-1:0] cnt;
wire [NUM_DIV-2:0] half_num_div;
assign half_num_div = (NUM_DIV / 2) - 1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else begin
        if (cnt == NUM_DIV - 2)
            clk_div <= ~clk_div;
        cnt <= cnt + 1;
    end
end

endmodule