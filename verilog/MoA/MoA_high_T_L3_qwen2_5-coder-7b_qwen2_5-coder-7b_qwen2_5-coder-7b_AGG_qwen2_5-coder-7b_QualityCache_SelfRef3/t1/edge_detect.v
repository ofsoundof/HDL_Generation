module edge_detect (
    input wire clk,
    input wire rst_n,
    input wire a,
    output reg rise,
    output reg down
);

reg [1:0] a_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 2'b00;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        a_reg <= {a_reg[0], a};
        if (a_reg == 2'b01)
            rise <= 1'b1;
        else
            rise <= 1'b0;

        if (a_reg == 2'b10)
            down <= 1'b1;
        else
            down <= 1'b0;
    end
end

endmodule