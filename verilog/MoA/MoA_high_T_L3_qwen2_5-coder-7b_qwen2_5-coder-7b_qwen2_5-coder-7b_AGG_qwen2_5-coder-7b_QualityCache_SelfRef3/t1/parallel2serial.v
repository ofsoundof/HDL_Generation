module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);

reg [3:0] data;
reg [1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 4'b0000;
        cnt <= 2'b00;
        valid_out <= 1'b0;
    end else begin
        case (cnt)
            2'b00: begin
                dout <= d[3];
                cnt <= 2'b01;
            end
            2'b01: begin
                dout <= d[2];
                cnt <= 2'b10;
            end
            2'b10: begin
                dout <= d[1];
                cnt <= 2'b11;
            end
            2'b11: begin
                dout <= d[0];
                valid_out <= 1'b1;
                cnt <= 2'b00;
            end
            default: begin
                dout <= data[3];
                valid_out <= 1'b0;
                cnt <= cnt + 1;
            end
        endcase
    end
end

endmodule