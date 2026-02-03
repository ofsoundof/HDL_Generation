module sequence_detector(clk, reset_n, data_in, sequence_detected);
  input clk, reset_n, data_in;
  output reg sequence_detected;

  reg [1:0] state, next_state;

  parameter IDLE = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
      state <= IDLE;
    else
      state <= next_state;
  end

  always @(*) begin
    next_state = state;
    sequence_detected = 0;

    case (state)
      IDLE: begin
        if (data_in == 1'b1)
          next_state = S1;
      end
      S1: begin
        if (data_in == 1'b0)
          next_state = S2;
        else
          next_state = IDLE;
      end
      S2: begin
        if (data_in == 1'b0)
          next_state = S3;
        else
          next_state = IDLE;
      end
      S3: begin
        if (data_in == 1'b1) begin
          next_state = IDLE;
          sequence_detected = 1;
        end else
          next_state = IDLE;
      end
    endcase
  end

endmodule