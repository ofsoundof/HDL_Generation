module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);

wire [7:0] shifted4, shifted2, shifted1;

// Shift by 4 positions
assign shifted4 = {in[3:0], in[7:4]};

// Shift by 2 positions
assign shifted2 = {in[5:0], in[7:6]};

// Shift by 1 position
assign shifted1 = {in[6:0], in[7]};

// Mux to select the final output based on ctrl signals
always @(*) begin
    case (ctrl)
        3'b100: out = shifted4;
        3'b010: out = shifted2;
        3'b001: out = shifted1;
        default: out = in;
    endcase
end

endmodule