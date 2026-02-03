module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

parameter idle = 2'b00, s1_red = 2'b01, s2_yellow = 2'b10, s3_green = 2'b11;
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

always @(*) begin
    case (state)
        idle: begin
            red = 0;
            yellow = 0;
            green = 0;
            next_state = s1_red;
        end
        s1_red: begin
            red = 1;
            yellow = 0;
            green = 0;
            if (cnt == 5'd3) next_state = s3_green;
            else next_state = s1_red;
        end
        s2_yellow: begin
            red = 0;
            yellow = 1;
            green = 0;
            if (cnt == 5'd3) next_state = s1_red;
            else next_state = s2_yellow;
        end
        s3_green: begin
            red = 0;
            yellow = 0;
            green = 1;
            if (cnt == 5'd3) next_state = s2_yellow;
            else next_state = s3_green;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        cnt <= 8'd10;
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end else begin
        state <= next_state;
        if (pass_request && green)
            if (cnt > 10)
                cnt <= 10;
            else
                cnt <= cnt;
        else if (!green && p_green)
            cnt <= 60;
        else if (!yellow && p_yellow)
            cnt <= 5;
        else if (!red && p_red)
            cnt <= 10;
        else
            cnt <= cnt - 1;

        {red, yellow, green} <= {p_red, p_yellow, p_green};
    end
end

assign clock = cnt;

endmodule