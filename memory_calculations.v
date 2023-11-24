

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

            ra=RAM[a][31:16];
            rb=RAM[a][15:0];
    end



endmodule

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





module button_counter(output wire [15:0] producto, input   clk , rst  , NEXT);

reg [2:0] state , next_state;
reg [31:0] counter;
parameter hold =2'b00 , pressed_buttom = 2'b01 , released_buttom = 2'b10;
wire [15:0] A , B ;
wire snan, qnan, inf, zero, subnormal, normal;

memo OPERANDS_REGISTER(clk , rst , counter , A , B );
FP_mul MULTIPLICA(.producto(producto),.na(A) , .nb(B)  , .snan(snan) , .qnan(qnan) , .inf(inf) , .zero(zero) , .subnormal(subnormal) , .normal(normal));

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