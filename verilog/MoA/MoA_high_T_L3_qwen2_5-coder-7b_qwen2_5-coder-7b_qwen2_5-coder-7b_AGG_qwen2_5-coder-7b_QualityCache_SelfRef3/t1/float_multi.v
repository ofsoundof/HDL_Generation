module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, product_mantissa;
reg [9:0] a_exponent, b_exponent;
reg a_sign, b_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        a_mantissa <= 24'b0;
        b_mantissa <= 24'b0;
        product_mantissa <= 24'b0;
        a_exponent <= 10'b0;
        b_exponent <= 10'b0;
        product <= 50'b0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
    end else begin
        case (counter)
            3'b000: begin
                a_mantissa <= {a[22:0], 1'b0};
                b_mantissa <= {b[22:0], 1'b0};
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
            end
            3'b001: begin
                product <= (a_mantissa * b_mantissa);
                product_mantissa <= {product[49], product[48:26]};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
            end
            3'b010: begin
                sticky <= |product[25:0];
                guard_bit <= product[24];
                round_bit <= product[23];
                if (round_bit && (guard_bit || sticky)) begin
                    product_mantissa <= product_mantissa + 1;
                end
                if (product_mantissa[23]) begin
                    z_exponent <= z_exponent + 1;
                    product_mantissa <= product_mantissa >> 1;
                end
            end
            default: begin
                counter <= 3'b000;
            end
        endcase
    end
end

always @(*) begin
    if (z_exponent > 255) begin
        z = {1'b1, 8'b11111111, 23'b0}; // Overflow
    end else if (z_exponent < 0) begin
        z = {1'b0, 8'b00000000, 23'b0}; // Underflow
    end else begin
        z = {z_sign, z_exponent[7:0], product_mantissa};
    end
end

endmodule