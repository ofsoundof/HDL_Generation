module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg [3:0] dataOut,
    output reg EMPTY,
    output reg FULL
);

reg [1:0] SP;
reg [15:0] stack_mem;

always @(posedge Clk) begin
    if (Rst) begin
        SP <= 2'd4;
        stack_mem <= {16{4'b0}};
        dataOut <= 4'b0;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        if (!FULL && !RW) begin
            stack_mem[SP*4 +: 4] <= dataIn;
            SP <= SP - 1;
            FULL <= (SP == 2'd0);
            EMPTY <= (SP == 4'd4);
        end else if (!EMPTY && RW) begin
            dataOut <= stack_mem[SP*4 +: 4];
            stack_mem[SP*4 +: 4] <= 4'b0;
            SP <= SP + 1;
            EMPTY <= (SP == 4'd4);
            FULL <= (SP == 2'd0);
        end
    end else begin
        dataOut <= stack_mem[SP];
        EMPTY <= (SP == 4'd4);
        FULL <= (SP == 2'd0);
    end
end

endmodule