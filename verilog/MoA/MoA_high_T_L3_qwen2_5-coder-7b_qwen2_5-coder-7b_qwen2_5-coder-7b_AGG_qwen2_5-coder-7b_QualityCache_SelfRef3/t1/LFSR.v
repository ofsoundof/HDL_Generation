module LFSR (
    input  wire clk,
    input  wire rst,
    output reg [3:0] out
);

reg [3:0] lfsr;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        lfsr <= 4'b0000;
        out <= 4'b0000;
    end else begin
        lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
        out <= lfsr;
    end
end

endmodule