module carrylookahead_adder_16(A, B, S, C32);
    input [15:0] A;
    input [15:0] B;
    output reg [15:0] S;
    output reg C32;

    wire [15:0] C_in;
    wire [15:0] S_out;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : adder_16bit
            assign {C_in[i], S_out[i]} = A[i] + B[i];
        end
    endgenerate

    assign C32 = C_in[15];
    assign S = S_out;
endmodule