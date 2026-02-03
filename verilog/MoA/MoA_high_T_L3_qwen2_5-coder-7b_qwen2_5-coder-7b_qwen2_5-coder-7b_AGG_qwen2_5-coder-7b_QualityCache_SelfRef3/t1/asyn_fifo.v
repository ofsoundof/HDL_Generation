module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire wclk,
    input wire rclk,
    input wire wrstn,
    input wire rrstn,
    input wire winc,
    input wire rinc,
    input wire [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

wire [$clog2(DEPTH)-1:0] waddr, raddr;
reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin, wptr, rptr, wptr_syn, rptr_syn;
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;

wire wen, ren;

dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .rclk(rclk),
    .wenc(wen),
    .wdata(wdata),
    .renc(ren),
    .waddr(waddr_bin),
    .raddr(raddr_bin),
    .rdata(rdata)
);

always @(posedge wclk or posedge wrstn) begin
    if (~wrstn) begin
        wptr <= 0;
        wptr_buff <= 0;
    end else begin
        if (winc && ~wfull) begin
            wptr <= wptr + 1;
            wptr_buff <= wptr;
        end
    end
end

always @(posedge rclk or posedge rrstn) begin
    if (~rrstn) begin
        rptr <= 0;
        rptr_buff <= 0;
    end else begin
        if (rinc && ~rempty) begin
            rptr <= rptr + 1;
            rptr_buff <= rptr;
        end
    end
end

assign waddr = wptr_syn;
assign raddr = rptr_syn;

always @(posedge wclk or posedge rrstn) begin
    if (~wrstn || ~rrstn) begin
        wptr_syn <= 0;
        rptr_syn <= 0;
    end else begin
        wptr_syn <= wptr_buff;
        rptr_syn <= rptr_buff;
    end
end

assign wen = winc && ~rempty && (wptr != rptr_syn);
assign ren = rinc && ~wfull && (rptr != wptr_syn);

always @(posedge wclk or posedge rrstn) begin
    if (~wrstn || ~rrstn) begin
        rempty <= 1;
    end else begin
        rempty <= (wptr_syn == rptr_syn);
    end
end

always @(posedge wclk or posedge rrstn) begin
    if (~wrstn || ~rrstn) begin
        wfull <= 0;
    end else begin
        wfull <= ((wptr_syn + 1 == rptr_syn) && (rptr_syn[$clog2(DEPTH):$clog2(DEPTH)] != wptr_syn[$clog2(DEPTH):$clog2(DEPTH)]));
    end
end

endmodule