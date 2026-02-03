module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] abs_a;
reg [N-1:0] abs_b;
reg sign_c;

always @(*) begin
    abs_a = (a[N-1]) ? (~a + 1) : a; // Calculate absolute value of a
    abs_b = (b[N-1]) ? (~b + 1) : b; // Calculate absolute value of b

    if (a[N-1] == b[N-1]) begin
        c = abs_a + abs_b;
        sign_c = a[N-1];
    end else begin
        if (abs_a > abs_b) begin
            c = abs_a - abs_b;
            sign_c = 1'b0;
        end else begin
            c = abs_b - abs_a;
            sign_c = a[N-1];
        end
    end

    // Ensure the result fits within N bits
    if (c[N] == 1'b1) begin
        c = ~c + 1;
        sign_c = ~sign_c;
    end

    c[N-1] = sign_c; // Set the sign bit
end

endmodule