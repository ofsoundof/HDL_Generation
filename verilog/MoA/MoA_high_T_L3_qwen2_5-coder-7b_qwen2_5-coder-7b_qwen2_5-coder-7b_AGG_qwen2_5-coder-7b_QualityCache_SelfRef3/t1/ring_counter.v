module ring_counter (
    input wire clk,
    input wire reset,
    output reg [7:0] out
);

reg [3:0] state;

always @(posedge clk or posedge reset) begin
    if (reset)
        state <= 4'b0001;
    else
        state <= {state[2:0], state[3]};
end

assign out = 8'b1 << state;

endmodule