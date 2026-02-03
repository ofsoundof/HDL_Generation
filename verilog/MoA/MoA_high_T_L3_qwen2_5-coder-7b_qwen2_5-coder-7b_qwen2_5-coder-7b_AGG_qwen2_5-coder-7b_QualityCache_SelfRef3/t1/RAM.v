module RAM (
    input wire clk,
    input wire rst_n,
    input wire write_en,
    input wire [5:0] write_addr,
    input wire [5:0] write_data,
    input wire read_en,
    input wire [5:0] read_addr,
    output reg [5:0] read_data
);

parameter WIDTH = 6;
parameter DEPTH = 8;

reg [WIDTH-1:0] RAM [DEPTH-1:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer i = 0; i < DEPTH; i = i + 1) begin
            RAM[i] <= 6'b0;
        end
        read_data <= 6'b0;
    end else begin
        if (write_en) begin
            RAM[write_addr] <= write_data;
        end
        if (read_en) begin
            read_data <= RAM[read_addr];
        end else begin
            read_data <= 6'b0; // Clear read_data when not reading
        end
    end
end

endmodule