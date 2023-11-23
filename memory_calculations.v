module memo(
        input logic clk , rst ,
        input logic [31:0] a, 
        output  reg [15:0] ra,
        output reg [15:0] rb 

    );
        logic [32:0] RAM[20:0];
        integer i;
        initial begin
            $readmemh("calculations.dat", RAM);
            
        end

    always  @(*)
    begin

           // ra=RAM[31:16][a];
            //rb=RAM[15:0][a];
    end



endmodule


module button_counter(output reg [15:0] producto, input   clk , rst  , NEXT);

reg [2:0] state , next_state;
reg [32:0] counter;
parameter hold =2'b00 , pressed_buttom = 2'b01 , released_buttom = 2'b10;
reg [15:0] A , B ;


always @*
begin

case(state)

hold: begin
    if(NEXT) next_state = pressed_buttom;
    else next_state = hold;
end
pressed_buttom :  begin
    if(!NEXT) next_state = released_buttom;
    else next_state = pressed_buttom;
    end
released_buttom: begin
    if(NEXT) next_state = hold;
else next_state = released_buttom;
end
endcase



end



always @(posedge clk , posedge rst)
begin

if(rst) begin
 counter<=0;
 state<=hold;
end
else begin
state<=next_state;
if(state== pressed_buttom && next_state == released_buttom)
 counter<=counter+1;
  

end


end



endmodule