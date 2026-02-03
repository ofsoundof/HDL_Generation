module instr_reg (
    input wire clk,
    input wire rst,
    input wire [1:0] fetch,
    input wire [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

reg [7:0] ins_p1;
reg [7:0] ins_p2;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        ins_p1 <= 8'd0;
        ins_p2 <= 8'd0;
    end else begin
        case (fetch)
            2'b01: ins_p1 <= data;
            2'b10: ins_p2 <= data;
            default: ;
        endcase
    end
end

assign ins = fetch == 2'b01 ? ins_p1[2:0] : ins_p2[2:0];
assign ad1 = fetch == 2'b01 ? ins_p1[4:0] : ins_p2[4:0];
assign ad2 = fetch == 2'b01 ? ins_p2 : ins_p1;

endmodule