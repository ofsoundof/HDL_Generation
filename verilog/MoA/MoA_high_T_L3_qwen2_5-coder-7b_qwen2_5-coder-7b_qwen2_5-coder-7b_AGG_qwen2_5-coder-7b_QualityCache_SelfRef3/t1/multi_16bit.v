module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i;
reg [15:0] areg, breg;
reg [31:0] yout_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done <= 0;
    end else begin
        if (start) begin
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
            end else if (i < 17 && areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1));
            end
            i <= i + 1;
        end else begin
            i <= 0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        done <= 0;
    else
        done <= (i == 16);
end

assign yout = yout_r;

endmodule