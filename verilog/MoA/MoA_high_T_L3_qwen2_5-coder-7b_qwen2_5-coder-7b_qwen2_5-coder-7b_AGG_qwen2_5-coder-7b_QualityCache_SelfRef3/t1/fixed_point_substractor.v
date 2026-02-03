module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)
(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg sign_a, sign_b;
reg [Q-1:0] int_part_a, frac_part_a;
reg [Q-1:0] int_part_b, frac_part_b;
reg [N-Q-1:0] abs_a_int, abs_b_int;

assign sign_a = a[N-1];
assign sign_b = b[N-1];

assign int_part_a = a[N-2:Q];
assign frac_part_a = a[Q-1:0];
assign int_part_b = b[N-2:Q];
assign frac_part_b = b[Q-1:0];

assign abs_a_int = (sign_a) ? ~int_part_a + 1 : int_part_a;
assign abs_b_int = (sign_b) ? ~int_part_b + 1 : int_part_b;

reg [N-1:0] res;

always @(*) begin
    if (sign_a == sign_b) begin
        res = sign_a ? a - b : b - a;
    end else begin
        if (abs_a_int > abs_b_int || (abs_a_int == abs_b_int && frac_part_a >= frac_part_b)) begin
            res = a - b;
        end else begin
            res = -(b - a);
        end
    end

    // Handling zero result
    if (res[N-2:0] == 0) begin
        c = {1'b0, {N-2{1'b0}}};
    end else begin
        c[N-1] = res[N-1];
        c[N-2:N-Q] = res[N-2:N-Q];
        c[Q-1:0] = res[Q-1:0];
    end
end

endmodule