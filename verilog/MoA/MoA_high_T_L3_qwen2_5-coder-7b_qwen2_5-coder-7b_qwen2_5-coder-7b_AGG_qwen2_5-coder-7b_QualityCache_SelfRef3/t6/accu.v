module accu(
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg [9:0] data_out,
    output reg valid_out
);

reg [11:0] accumulator;
reg [2:0] count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accumulator <= 12'b0;
        count <= 3'b0;
        valid_out <= 0;
    end else begin
        if (valid_in && count < 3'b100) begin
            accumulator <= accumulator + data_in;
            count <= count + 1;
        end
        if (count == 3'b100) begin
            data_out <= accumulator;
            valid_out <= 1;
            count <= 0;
            accumulator <= 12'b0;
        end else begin
            valid_out <= 0;
        end
    end
end

endmodule