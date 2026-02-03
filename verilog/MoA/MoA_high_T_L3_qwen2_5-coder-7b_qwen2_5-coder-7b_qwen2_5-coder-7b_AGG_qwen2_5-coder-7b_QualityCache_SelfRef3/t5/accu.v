module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [3:0] count;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 4'b0000;
        sum <= 10'b0000000000;
        valid_out <= 1'b0;
    end else begin
        if (valid_in) begin
            sum <= sum + data_in;
            count <= count + 1;
        end
        if (count == 4'b1000) begin
            valid_out <= 1'b1;
            data_out <= sum;
            count <= 4'b0000;
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule