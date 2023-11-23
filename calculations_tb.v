
module button_counter_tb;

    // Entradas
    reg clk;
    reg rst;
    reg NEXT;

    // Salidas
    wire [15:0] producto;

    // Instancia del módulo a probar
    button_counter uut (
        .producto(producto), 
        .clk(clk), 
        .rst(rst), 
        .NEXT(NEXT)
    );

    // Generación de la señal de reloj
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Cambia el estado cada 10 ns
    end

    // Proceso de prueba
    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0,button_counter_tb);
        // Inicialización
        rst = 1;
        NEXT = 0;

        // Reinicio del sistema
        #20;
        rst = 0;

        // Simula el botón presionado
        #30 NEXT = 1;
        #20 NEXT = 0;

        // Simula el botón presionado de nuevo
        #40 NEXT = 1;
        #20 NEXT = 0;

        // Simula el botón presionado una vez más
        #50 NEXT = 1;
        #20 NEXT = 0;

        // Finaliza la simulación
        #100 $finish;
    end
      
endmodule
