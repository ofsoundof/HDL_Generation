module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg [9:0] data_out,
    output reg valid_out
);

reg [2:0] count;
wire [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 3'b000;
        sum <= 10'b0000000000;
        valid_out <= 1'b0;
        data_out <= 10'b0000000000;
    end else begin
        if (valid_in) begin
            sum <= sum + data_in;
            count <= count + 1'b1;
            if (count == 3'b111) begin
                valid_out <= 1'b1;
                data_out <= sum;
                count <= 3'b000;
                sum <= 10'b0000000000;
            end else begin
                valid_out <= 1'b0;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule