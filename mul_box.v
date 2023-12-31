module mul_box(output reg [15:0] product ,output reg inf , zero , normal ,input [15:0] na , nb ); // Se asumen que los numeros que entran o son normales (ya normalizados)
//O se han  normalizado para operar en el caso de normal x subnormal 


reg [21:0] partialResult ; //Asumiendo que ya estan normalizados ambos se tentda maximo un producto con 22 bits (10 bits explicitos mas el uno implicito)
wire sign = na[15] ^ nb[15]; //Se calcula el signo haciendo xor de ambos bits 
reg [4:0]expa;
reg [4:0]expb;
parameter bias = 15 ; //el bias de los exponentes en IEEE 754 para 16 bits 
reg exponent ; 
always @ *
begin
partialResult = {1'b1,na[9:0]} *{ 1'b1,nb[9:0]}; // se multiplica la mantisa con la parte implicita y con el uno implicito 
expa = na[14:10]-bias;
expb = nb[14:10]-bias;
exponent = na+nb;
if(partialResult[21])// Como el valor maximo que se puede multiplicar en mantisas es (1.111..)^2 y esto produce 22 valores solo nos preocupa elm ultimo valor
//si es uno debemos normalizar el resultado
begin
    partialResult = partialResult<<1;
    exponent = exponent +1 ;
end //Ya esta normalizado el resultado

if(exponent > 15 ) // El prducto es muy grande para ser representado y se devuelve infinito
begin
product ={sign , 5'b1 , 10'b0};
inf = 1;
end else if (exponent < -14 ) // El valor es pequeño devolver zero
begin 
product = {sign , 15'b0};    
zero = 1;
end else begin 
product = {sign ,exponent+bias ,partialResult[21:12]};
normal =1;
end
end



endmodule