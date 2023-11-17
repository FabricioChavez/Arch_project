module mem_tb;

reg clk ,we , byte_src;
reg [31:0] address , data2write;
wire [31:0]read_data;
always #5 clk= ~ clk ;
mem memoria(.clk(clk) , .we(we) , .byte_src(byte_src), .a(address) , .wd(data2write),
.rd(read_data));

initial begin
clk = 0;
byte_src = 1;
#3
address = 32'h0;
#10
we=0;
address = 32'h1;
#10
address = 32'h2;
#10
address = 32'h3;
#10
address = 32'h4;
#10
byte_src = 0;
address = 32'h4;
#10
address = 32'h8;
#10
address = 32'h8;

#10
$finish;
end

always @(negedge clk)
begin
$display("Addresss: %h | read_data: %h | data2write: %h" ,{address} , {read_data} , {data2write});
end


endmodule