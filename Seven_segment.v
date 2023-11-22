module Seven_segment(input [15:0] producto , input clk , rst  , output reg [6:0] LED_out , output reg d0 , d1 , d2 ,d3);


reg [1:0] state , next_state;
parameter s3 = 2'b11, s2 = 2'b10, s1 = 2'b01, s0 = 2'b00;


//next state logic 

always @ (*) begin

case(state)
  s0: next_state = s1;
  s1: next_state = s2;
  s2: next_state = s3;
  s3: next_state = s0;
endcase
end



always @(posedge clk , posedge rst )
begin

  if (rst) 
     state <= s0;
 else 
    state <= next_state;
    
end




always @(*) begin

    case(state)

    s0: begin
        d0=1; d1 =0 ; d2=0 ; d3 =0;

        case(producto[3:0])

        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        4'b1010: LED_out = 7'b0001000; // "A" 
        4'b1011: LED_out = 7'b0000000; // "B" 
        4'b1100: LED_out = 7'b0110001; // "C"
        4'b1101: LED_out = 7'b0000001; // "D"
        4'b1110: LED_out = 7'b0110000; // "E"
        4'b1111: LED_out = 7'b0111000; // "F"    



        endcase
    end
    s1:begin
         d0=0; d1 =1 ; d2=0 ; d3 =0;

        case(producto[7:4])

        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        4'b1010: LED_out = 7'b0001000; // "A" 
        4'b1011: LED_out = 7'b0000000; // "B" 
        4'b1100: LED_out = 7'b0110001; // "C"
        4'b1101: LED_out = 7'b0000001; // "D"
        4'b1110: LED_out = 7'b0110000; // "E"
        4'b1111: LED_out = 7'b0111000; // "F"    



        endcase
     end   
    s2:begin
        d0=0; d1 =0 ; d2=1 ; d3 =0;

        case(producto[11:8])

        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        4'b1010: LED_out = 7'b0001000; // "A" 
        4'b1011: LED_out = 7'b0000000; // "B" 
        4'b1100: LED_out = 7'b0110001; // "C"
        4'b1101: LED_out = 7'b0000001; // "D"
        4'b1110: LED_out = 7'b0110000; // "E"
        4'b1111: LED_out = 7'b0111000; // "F"    



        endcase
        end
    s3:begin
         d0=0; d1 =0 ; d2=0 ; d3 =1;

        case(producto[15:12])

        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        4'b1010: LED_out = 7'b0001000; // "A" 
        4'b1011: LED_out = 7'b0000000; // "B" 
        4'b1100: LED_out = 7'b0110001; // "C"
        4'b1101: LED_out = 7'b0000001; // "D"
        4'b1110: LED_out = 7'b0110000; // "E"
        4'b1111: LED_out = 7'b0111000; // "F"    



        endcase
    end

    endcase



end
endmodule