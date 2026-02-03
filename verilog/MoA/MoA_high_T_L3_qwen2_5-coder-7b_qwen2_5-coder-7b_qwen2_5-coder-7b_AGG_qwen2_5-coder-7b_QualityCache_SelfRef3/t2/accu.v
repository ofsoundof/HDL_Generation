module accu (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg [9:0] data_out,
    output reg valid_out
);

reg [1:0] counter;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 0;
        data_out <= 0;
        counter <= 0;
        sum <= 0;
    end else begin
        if (valid_in) begin
            sum <= sum + data_in;
            counter <= counter + 1;
        end
        if (counter == 3) begin
            valid_out <= 1;
            data_out <= sum;
            counter <= 0;
            sum <= 0;
            #1 valid_out <= 0;
        end else begin
            valid_out <= 0;
        end
    end
end

endmodule