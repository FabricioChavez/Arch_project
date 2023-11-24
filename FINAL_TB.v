
module Fp_mul_fsm_tb;

    reg [15:0] na;
    reg clk, rst, SAVE;
    wire [6:0] LED_out ;
    wire d0 , d1 , d2 ,d3;

    // Instancia del módulo Fp_mul_fsm
    Seven_segment_fsm uut (.na(na), .clk(clk), .rst(rst), .SAVE(SAVE) ,.LED_out(LED_out),.d0(d0),.d1(d1),.d2(d2),.d3(d3));

    // Generación del reloj
    always #5 clk = ~clk;  // Cambia cada 5 ns, frecuencia = 100 MHz

    // Test
    initial begin
        $dumpfile("Mul_fsm.vcd");
        $dumpvars(0,Fp_mul_fsm_tb);
        // Inicialización
        clk = 0;
        rst = 1;
        SAVE = 0; 
        #2
        na = 16'h4000; // 2
        SAVE = 1; //pasas al estado para guardar A
        rst =0;
        #1
        // Cargar valores de prueba
        rst = 0;
         SAVE =0; // No se esta guardando esto te permite ingresar A 
         #10
           SAVE = 1;    // Guardar A --> pasas a estado guardar b
         #10
        SAVE = 0; //A se holdea y no se guarda lo que pongas en B , aca puedes ingresar el valor de B
        na = 16'h4200; // 3
        #10
        SAVE = 1;      // Guardar B y pasas a calcular se mostrara el valor de producto estaras en el estado de save_none
        #10;
            SAVE =0; //No cambias y se va a mostrar el resultado
             na = 16'h5FD1;//ESTE VALOR SE GUARDA EN A
            #10
            SAVE =1; //pasar a estado guardar A 
            #10
            na = 16'h5BAD; //ESTE VALOR SE GUARDA EN B
            SAVE = 0;
            #10
             SAVE =1;//pasar a guardar B 
             #10
             SAVE=0;// ACA DEBERIA MOSTRARSE EL RESULTADO
             #10
        $finish;
    end

endmodule
