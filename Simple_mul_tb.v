module mul_box_tb;
//outputs
wire [15:0] product ;
wire snan , qnan , inf , zero , subnormal , normal ;
reg [21:0]partialResult ;
//Los dos numeros 
reg [15:0] na , nb ;

FP_mul mod(.producto(product), .na(na) , .nb(nb)  , .snan(snan) , .qnan(qnan) , .inf(inf) , .zero(zero) , .subnormal(subnormal) , .normal(normal));

initial begin
        na = 0;
        nb = 0;

     na = 16'h4000; // 2
     nb = 16'h4200 ;//3
     partialResult   = {1'b1, na[9:0]} * {1'b1, nb[9:0]} ;
     //result must be 0x4600
     #10
     na = 16'h409A; //2.3
     nb =  16'h3C66; //1.1
       partialResult ={1'b1, na[9:0]} * {1'b1, nb[9:0]};
     //result must be 0x410F
     #10
      na = 16'h7C00; // inf
     nb =  16'h3C66; // 1.1
      partialResult ={1'b1, na[9:0]} * {1'b1, nb[9:0]};
     //result must be 0x7C00 inf
     #10
      na = 16'h409A;//2.3
     nb =  16'h0000;//0
      partialResult ={1'b1, na[9:0]} * {1'b1, nb[9:0]};
     //result must be 0x0000
     #10
      na = 16'h7C00; //inf
     nb =  16'h0000; //0
      partialResult ={1'b1, na[9:0]} * {1'b1, nb[9:0]};
     //result must be 0xFFFF NAN (no le grabes a este caso en la basys )
     #10
      na = 16'h5C01; //256.3---------
     nb =  16'h4B2E; //14.36
      partialResult ={1'b1, na[9:0]} * {1'b1, nb[9:0]};
     //result must be 0x6B2F --> 0x6B30 Sale eso en IEEE calcualor , pero nosostros no redondeamos
     #10
      na = 16'h5FD1; // 500.3
     nb =  16'h5BAD; // 245.6
      partialResult ={1'b1, na[9:0]} * {1'b1, nb[9:0]};
     //result must be 0x7C00 inf
     #10
      na = 16'h49A6;//11.3
     nb =  16'h4A73; //12.9
      partialResult ={1'b1, na[9:0]} * {1'b1, nb[9:0]}>>1;
     //result must be 0x588E Sale 588d no usamos redondeo en nuestro caso
     #10
      na = 16'h4500; //5
     nb =  16'h4500;//5
      partialResult ={1'b1, na[9:0]} * {1'b1, nb[9:0]};
     //result must be 0x4E40 //25
     #10
      na = 16'hD0A0;// -37
     nb =  16'h4AA1;//13.26
      partialResult ={1'b1, na[9:0]} * {1'b1, nb[9:0]};
     //result must be 0xDFAA
     #10
     $finish;

end

always @*
begin
#1
$monitor("na = %h  * nb = %h ||  result =%h | parcial = %16b  ||| snan = %b, qnan = %b , inf = %b , zero = %b , subnormal = %b, normal  = %b" , na , nb ,product, partialResult  , snan , qnan , inf , zero , subnormal , normal);

end





endmodule