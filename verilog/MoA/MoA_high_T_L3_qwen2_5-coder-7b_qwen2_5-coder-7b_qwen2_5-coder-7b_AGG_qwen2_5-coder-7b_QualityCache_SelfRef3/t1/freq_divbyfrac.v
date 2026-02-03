module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

localparam MUL2_DIV_CLK = 7;
reg [2:0] counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
        clk_div <= 1'b0;
    end else begin
        case (counter)
            3'b000: begin
                clk_div <= 1'b1;
            end
            3'b001: begin
                clk_div <= 1'b0;
            end
            3'b010: begin
                clk_div <= 1'b1;
            end
            3'b011: begin
                clk_div <= 1'b0;
            end
            3'b100: begin
                clk_div <= 1'b1;
            end
            3'b101: begin
                clk_div <= 1'b0;
            end
            3'b110: begin
                clk_div <= 1'b1;
            end
            default: begin
                counter <= 3'b000;
            end
        endcase
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule