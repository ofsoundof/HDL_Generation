module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [3:0] count;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 4'b0000;
        sum <= 10'b0000000000;
        valid_out <= 0;
    end else begin
        if (valid_in) begin
            sum <= sum + data_in;
            count <= count + 1;

            if (count == 4'b0100) begin
                data_out <= sum;
                valid_out <= 1;
                count <= 4'b0000;
            end
        end else begin
            count <= 4'b0000;
            valid_out <= 0;
        end

        if (valid_out && clk) begin
            valid_out <= 0;
        end
    end
end

endmodule