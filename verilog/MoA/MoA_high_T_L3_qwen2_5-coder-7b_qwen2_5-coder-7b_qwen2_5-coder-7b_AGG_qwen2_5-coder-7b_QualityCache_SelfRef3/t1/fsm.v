module fsm (
    input wire CLK,
    input wire RST,
    input wire IN,
    output reg MATCH
);

reg [3:0] state, next_state;

always @(posedge CLK or posedge RST) begin
    if (RST)
        state <= 4'b0000;
    else
        state <= next_state;
end

always @(*) begin
    MATCH = 0;
    case (state)
        4'b0000: begin // IDLE
            if (IN == 1) 
                next_state = 4'b0001; // GO_TO_0
            else
                next_state = state; // Stay in IDLE
        end
        4'b0001: begin // GO_TO_0
            if (IN == 0) 
                next_state = 4'b0010; // GO_TO_00
            else
                next_state = state; // Stay in GO_TO_0
        end
        4'b0010: begin // GO_TO_00
            if (IN == 0) 
                next_state = 4'b0011; // GO_TO_000
            else
                next_state = state; // Stay in GO_TO_00
        end
        4'b0011: begin // GO_TO_000
            if (IN == 1) 
                next_state = 4'b0100; // MATCH
            else
                next_state = state; // Stay in GO_TO_000
        end
        4'b0100: begin // MATCH
            MATCH = 1; // Set MATCH to 1 when in MATCH state
            if (IN == 1) 
                next_state = 4'b0001; // GO_TO_0 if IN is 1
            else
                next_state = 4'b0000; // Stay in IDLE if IN is 0
        end
    endcase
end

endmodule