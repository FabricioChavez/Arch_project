
module top(input logic clk, reset,
output logic [31:0] WriteData, Adr,
output logic MemWrite);
logic [31:0] ReadData;
// instantiate processor and shared memory
arm arm(clk, reset, MemWrite, Adr,
WriteData, ReadData);
mem mem(clk, MemWrite, Adr, WriteData, ReadData);
endmodule


module mem(input logic clk, we,
input logic [31:0] a, wd,
output logic [31:0] rd);
logic [31:0] RAM[63:0];
initial
$readmemh("memfile.dat",RAM);
assign rd = RAM[a[31:2]]; // word aligned
always @(posedge clk)
if (we) RAM[a[31:2]] <= wd;
endmodule