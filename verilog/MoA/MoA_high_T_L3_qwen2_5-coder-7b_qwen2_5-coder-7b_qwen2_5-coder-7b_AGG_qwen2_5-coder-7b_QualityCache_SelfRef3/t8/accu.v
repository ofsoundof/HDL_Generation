module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [3:0] counter;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 4'b0;
        sum <= 10'b0;
        valid_out <= 1'b0;
    end else begin
        if (valid_in) begin
            sum <= sum + data_in;
            counter <= counter + 1;
        end
        
        if (counter == 4'b1100) begin
            data_out <= sum;
            valid_out <= 1'b1;
            counter <= 4'b0;
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule