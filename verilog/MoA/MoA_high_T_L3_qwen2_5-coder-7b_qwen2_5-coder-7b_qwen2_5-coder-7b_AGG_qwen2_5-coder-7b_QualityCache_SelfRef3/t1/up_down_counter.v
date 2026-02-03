module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 16'b0;
    else if (up_down && count != 16'hFFFF)
        count <= count + 1;
    else if (!up_down && count != 16'h0000)
        count <= count - 1;
end

endmodule