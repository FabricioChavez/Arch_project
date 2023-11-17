module Fp_clasifier_tb;

reg [15:0] float ;
wire snan , qnan , inf , zero , subnormal , normal;

integer Csnan , Cqnan , Cinf , Czero , Csubnormal , Cnormal , i;

Fp_clasifier clasificador_flotantes(float ,snan , qnan , inf , zero , subnormal , normal);

initial begin
assign float =0;
Csnan =0 ;   
Cqnan  =0 ; 
Cinf =0 ; 
Czero =0 ; 
Csubnormal =0 ; 
Cnormal =0 ; 
end


always @(*) begin

for(i=0 ; i < (1<<16) ; i=i+1) begin 
#10  float = i ;
if(  snan  & ~ qnan & ~ inf & ~ zero & ~ subnormal & ~ normal ) begin
    Csnan = Csnan+1;
end else if( ~ snan  &  qnan & ~ inf & ~ zero & ~ subnormal & ~ normal ) begin
    Cqnan = Cqnan +1;
end else if( ~ snan  &  ~ qnan &  inf & ~ zero & ~ subnormal & ~ normal ) begin
  Cinf = Cinf +1;
end else if( ~ snan  & ~ qnan & ~ inf &  zero & ~ subnormal & ~ normal ) begin
  Czero = Czero +1;
end else if( ~ snan  &  ~ qnan & ~ inf & ~ zero &  subnormal & ~ normal ) begin
 Csubnormal = Csubnormal +1;
end else if(  ~snan  &  ~qnan & ~ inf & ~ zero & ~ subnormal &  normal ) begin
  Cnormal = Cnormal +1;
end else begin 

$display("ERROR in iteration i=%d : f=%x , class=%b" ,i, float , {snan , qnan , inf , zero , subnormal , normal});
$stop;
end     


end 
#10


begin 

$display("Numero de NaN signados | %d" , Csnan);
$display("Numero de NaN quier    | %d" , Cqnan);
$display("Numero de infinitos    | %d" , Cinf);
$display("Numero de ceros        | %d" , Czero);
$display("Numero de subnormales  | %d" , Csubnormal);
$display("Numero de Normales     | %d" , Cnormal);
$display("Numero Total           | %d" , Csnan+Cqnan+Cinf+Czero+Csubnormal+Cnormal);
end
#10
$finish;
    
end


endmodule