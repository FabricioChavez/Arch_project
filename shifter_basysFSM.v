module shifter_basysFSM(
    input wire clk,           // Reloj
    input wire rst,           // Reset
	input wire [7:0] a,			// input
	input wire [ 4:0] shamt,		// shift cantidad
	input wire [ 1:0] shtype,		// 00=LSL, 01=LSR
	output reg [7:0] y);			// output

reg[7:0] reg_current, reg_next;
always @(posedge clk) begin
    if (rst) begin
        reg_current <= 8'b0;  // Reset del registro
    end else begin
        reg_current <= reg_next;
    end
end

always @(*) begin
    reg_next = reg_current;
    case (shtype)
        2'b00: reg_next = a << shamt;	// LSL
        2'b01: reg_next = a >> shamt;	// LSR
        default: reg_next = a;
    endcase
end

assign y = reg_current;
endmodule