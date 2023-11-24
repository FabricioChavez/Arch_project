    module mem(
        input logic clk, we,byte_src,
        input logic [31:0] a, 
        input logic [31:0] wd, 
        output  reg [31:0] rd 

    );
        logic [7:0] RAM[255:0];
        integer i;
        initial begin
            $readmemh("MEMO.dat", RAM);
            
        end 

    always  @(*)
    begin

        if(byte_src)
            rd  = RAM[a[31:0]];
        else rd= {RAM[a[31:0]],RAM[a[31:0]+1], RAM[a[31:0]+2], RAM[a[31:0]+3]};
    end

    always @ ( posedge clk )
    begin
    if(we & !byte_src) 
       {RAM[a[31:0]],RAM[a[31:0]+1], RAM[a[31:0]+2], RAM[a[31:0]+3]}<= wd;
    else if(we & byte_src)
      RAM[a[31:0]]=wd[7:0];

    end 

    endmodule
