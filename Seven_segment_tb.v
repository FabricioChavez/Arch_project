
module Seven_segment_tb;

    // Inputs
    reg [15:0] producto;
    reg clk;
    reg rst;

    // Outputs
    wire [6:0] LED_out;
    wire d0, d1, d2, d3;

    // Instantiate the Unit Under Test (UUT)
    Seven_segment uut (
        .producto(producto), 
        .clk(clk), 
        .rst(rst), 
        .LED_out(LED_out), 
        .d0(d0), 
        .d1(d1), 
        .d2(d2), 
        .d3(d3)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 10 ns
    end

    // Test cases
    initial begin
          $dumpfile("seven.vcd ");
        $dumpvars(0, Seven_segment_tb);
     
        rst = 1;
        producto = 16'h123F; 
        #10;
        rst = 0;
        #100;               
        $finish;
    end

 

endmodule
