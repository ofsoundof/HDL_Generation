module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output wire A_greater,
    output wire A_equal,
    output wire A_less
);

reg borrow;
reg [3:0] diff;

assign {borrow, diff} = A - B;

assign A_greater = !borrow && (diff != 4'b0000);
assign A_equal = (diff == 4'b0000);
assign A_less = borrow && (diff != 4'b0000);

endmodule