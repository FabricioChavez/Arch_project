module FP_mul(output [15:0] product ,input [15:0] na , nb , output reg snan , qnan , inf , zero , subnormal , normal);


wire Asnan , Aqnan , Ainf , Azero , Asubnormal , Anormal;
wire Bsnan , Bqnan , Binf , Bzero , Bsubnormal , Bnormal;
reg [15:0] productoTemp;
reg [15:0] Signo;
Fp_clasifier A(na , Asnan , Aqnan , Ainf , Azero , Asubnormal , Anormal);
Fp_clasifier B(nb , Asnan , Aqnan , Ainf , Azero , Asubnormal , Anormal);

always @(*) begin
    productoTemp = {1'b0 , {5{1'b1}} , 1'b0 , {9{1'b1}}}; //Temporalmente se declara el resultado como NAN
   {snan , qnan , inf , zero , subnormal , normal} = 6'b0; //Se inicializa los resultados con la flags de clasificaicon del tipo de numero
   Signo = na[15]^ nb[15]; //Se considera el signo del resultado dependiente del ultimo bit 
   //de ambos numeros
   if (Asnan | Bsnan) begin  //Producto de Nan con algo modo S
    productoTemp = Asnan ? na : nb;
    snan = 1;
end
else if (Aqnan | Bqnan) begin //Producto de Nan con algo modo quiet
    productoTemp = Aqnan ? na : nb;
    qnan = 1;
end
    else if(Ainf | Binf ) begin //Productodo de infinito por algo
        if( Azero | Bzero ) 
            begin
                //En caso el producto sea de un numero considerado infinito por un cero 
                //Se define que la respuesta es un quiet NaN segun el estandar IEEE 754
                productoTemp = {Signo , {5{1'b1}} , 1'b1 , 9'h02A}; //qNan

                qnan =1;
            end
        else begin
            //Cuando se tiene producto de algo con inf (salvo el caso anterior)
            //Se define como inf la respuesta segun IEEE 754 (el signo depende de ambos numeros)
            // existe +/- infinito para el estandar IEEE 754
            productoTemp = {Signo , {5{1'b1}}, 10'b0};
            inf =1;

        end

    end else if(Azero | Bzero  || (Asubnormal & Bsubnormal)) begin 
        //Si algo se multiplica por cero todo el numero se vuelve cero 
        // El otro caso es cuando se multiplican dos subnormales 
        //Como el exponente es demasiado pequeño para poder contenerse incluso
        // Se considera que su resultado es cero 
        productoTemp = {Signo , 15'b0};
        zero =1;
    end
     else begin  //caso de multiplicacion de normal por algo 
        
        
        
     end 



end



endmodule