module clkgenerator #(parameter PERIOD = 10) (
    output reg clk,
    input wire rst_n,
    input wire clk_in
);

reg [31:0] counter;

always @(posedge clk_in or negedge rst_n) begin
    if (!rst_n) begin
        clk <= 0;
        counter <= 0;
    end else begin
        counter <= counter + 1;
        if (counter >= PERIOD / 2 - 1)
            clk <= ~clk;
    end
end

endmodule