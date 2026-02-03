module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

reg [1:0] state, next_state;

parameter IDLE = 2'b00;
parameter RISING = 2'b01;
parameter FALLING = 2'b10;
parameter PULSE_END = 2'b11;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = RISING;
                else
                    next_state = IDLE;
            end
            RISING: begin
                if (data_in == 1'b0)
                    next_state = FALLING;
                else
                    next_state = RISING;
            end
            FALLING: begin
                data_out <= 1;
                if (data_in == 1'b0)
                    next_state = PULSE_END;
                else
                    next_state = FALLING;
            end
            PULSE_END: begin
                data_out <= 1;
                if (data_in == 1'b0)
                    next_state = IDLE;
                else
                    next_state = PULSE_END;
            end
        endcase
    end
end

endmodule