module shifter_basys(
    input wire clk,           // Reloj
    input wire rst,           // Reset
	input wire [7:0] a,			// input
	input wire [ 4:0] shamt,		// shift cantidad
	input wire [ 1:0] shtype,		// 00=LSL, 01=LSR
	output reg [7:0] y);			// output
always @(posedge clk) begin
	case (shtype)
		2'b00: y <= a << shamt;	// LSL
		2'b01: y <= a >> shamt;	// LSR
		default: y <= a;
	endcase
end
endmodule