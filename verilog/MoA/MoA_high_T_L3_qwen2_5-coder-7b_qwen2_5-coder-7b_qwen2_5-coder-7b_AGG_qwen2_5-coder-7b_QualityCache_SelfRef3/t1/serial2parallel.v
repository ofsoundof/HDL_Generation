module serial2parallel (
    input wire clk,
    input wire rst_n,
    input wire din_serial,
    input wire din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;
reg [7:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        shift_reg <= 8'b0;
        dout_parallel <= 8'b0;
        dout_valid <= 1'b0;
    end else begin
        if (din_valid && cnt < 4'b1000) begin
            shift_reg <= {shift_reg[6:0], din_serial};
            cnt <= cnt + 1;
        end

        if (cnt == 4'b1000) begin
            dout_parallel <= shift_reg;
            dout_valid <= 1'b1;
            cnt <= 4'b0;
        end else begin
            dout_valid <= 1'b0;
        end
    end
end

endmodule