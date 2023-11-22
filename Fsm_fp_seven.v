

module Fp_clasifier
(input [15:0] float , 
output snan , qnan , inf , zero , subnormal , normal );

wire expOnes , expZeroes , sigZeroes ; 

assign expOnes = &float[14:10];
assign expZeroes = ~|float[14:10];
assign sigZeroes = ~|float[9:0];

assign snan = expOnes & ~sigZeroes & ~float[9];
assign qnan = expOnes & float[9];
assign inf  = expOnes & sigZeroes;
assign zero = expZeroes & sigZeroes;
assign subnormal = expZeroes & ~sigZeroes;
assign normal = ~expOnes &  ~expZeroes;

endmodule

module FP_mul(output wire [15:0] producto, input [15:0] na, nb, output reg snan, qnan, inf, zero, subnormal, normal);

    wire Asnan, Aqnan, Ainf, Azero, Asubnormal, Anormal;
    wire Bsnan, Bqnan, Binf, Bzero, Bsubnormal, Bnormal;
    reg [15:0] productoTemp, product;
    reg [15:0] Signo;
    Fp_clasifier A(na, Asnan, Aqnan, Ainf, Azero, Asubnormal, Anormal);
    Fp_clasifier B(nb, Bsnan, Bqnan, Binf, Bzero, Bsubnormal, Bnormal);

    reg [21:0] partialResult; 
    reg [4:0] expa;
    reg [4:0] expb;
    parameter bias = 15; 
    reg [5:0] exponent;

    always @(*) begin
        {snan, qnan, inf, zero, subnormal, normal} = 6'b0;
        Signo = na[15] ^ nb[15];

        if (Asnan | Bsnan) begin
            productoTemp = Asnan ? na : nb;
            snan = 1;
        end else if (Aqnan | Bqnan) begin
            productoTemp = Aqnan ? na : nb;
            qnan = 1;
        end else if (Ainf | Binf) begin
            if (Azero | Bzero) begin
                productoTemp = {Signo, {5{1'b1}}, 1'b1, 9'b1};
                qnan = 1;
            end else begin
                productoTemp = {Signo, {5{1'b1}}, 10'b0};
                inf = 1;
            end
        end else if (Azero | Bzero || (Asubnormal & Bsubnormal)) begin
            productoTemp = {Signo, 15'b0};
            zero = 1;
        end else begin
            expa = na[14:10] - bias;
            expb = nb[14:10] - bias;
            exponent = expa + expb + bias; // Corregido para sumar el bias después de la suma de los exponentes
            partialResult = {1'b1, na[9:0]} * {1'b1, nb[9:0]};

            if (partialResult[21]) begin
                partialResult = partialResult >> 1
                ;
                exponent = exponent + 1;
            end

            if (exponent > 30) begin // Corregido para considerar el rango correcto del exponente
                productoTemp = {Signo, 5'b11111, 10'b0};
                inf = 1;
            end else if (exponent < 1) begin // Corregido para el rango inferior del exponente
                productoTemp = {Signo, 15'b0};
                zero = 1;
            end else begin
                productoTemp = {Signo, exponent[4:0], partialResult[19:10]}; // Ajustado para seleccionar los bits correctos de partialResult
                normal = 1; 
            end
        end
    end

    assign producto = productoTemp; // Asigna productoTemp a la salida producto
endmodule


module Fp_mul_fsm(output reg [15:0] producto, input [15:0] na,input   clk , rst  , SAVE);

wire qnan, inf, zero, subnormal, normal;
reg [1:0 ]state , next_state;
parameter save_a = 2'b00 , save_b=2'b01 , save_none = 2'b11  ;
reg [15:0]  current_a , current_b ;
wire[15:0] product;
FP_mul mod(.producto(product), .na(current_a) , .nb(current_b)  , .snan(snan) , .qnan(qnan) , .inf(inf) , .zero(zero) , .subnormal(subnormal) , .normal(normal));

//next stage logic O TUTORIAL PARA RODRIGO

always @*  //Pones el valor de a en los switches , SAVE  --> estaras guardando ese valor y pasaras al valor de save B (lo q tengas puesto ahi se estara guardando) una vez presionas SAVE
//el valor de B se quedara pegado y debera mostrarse el valor en los leds

begin

case (state)

        save_a:
            if(SAVE) begin
                next_state = save_b;
                
            end
            else next_state =save_a;
        save_b: 
            if(SAVE) begin
               next_state= save_none;
            
            end
             else  begin next_state = save_b; end
    
        save_none:
            if(SAVE)
             next_state = save_a;
            else next_state = save_none;     
endcase



end 

// Lógica secuencial para el manejo de estados y registros
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= save_none;
            current_a <= 0;
            current_b <= 0;
        end else begin
     
            if (state == save_none && next_state == save_a) begin
                current_a <= na;
            end
            if (state == save_a && next_state == save_b) begin
                current_b <= na;
            end

                   state <= next_state;
        end
    end

    // Lógica de salida
    always @* begin
        case (state)
            save_a: producto = current_a;
            save_b: producto = current_b;
            save_none: producto = product;
            default: producto = 16'b0;
        endcase
    end
        
endmodule



module Seven_segment(input [15:0] na , input clk , rst  , output reg [6:0] LED_out , output reg d0 , d1 , d2 ,d3);


reg [1:0] state , next_state;
parameter s3 = 2'b11, s2 = 2'b10, s1 = 2'b01, s0 = 2'b00;
wire [15:0] producto;
Fp_mul_fsm sub_unit(.producto(producto), .na(na) , .clk(clk) , .rst(rst));

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