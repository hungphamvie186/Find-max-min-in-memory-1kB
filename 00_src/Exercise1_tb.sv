`timescale 1ps/1ps

module Exercise1_tb();
    logic clk;
    logic rst_n;
    logic start;
    logic done;
    logic [9:0] ADDR;
    logic [7:0] DATA;
    logic [7:0] MAX;
    logic [7:0] MIN;
    
    logic [7:0] MEM[0:1023];
    integer i;
    
    Exercise1 #(10,8) DUT(
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .ADDR(ADDR),
        .DATA(DATA),
        .MIN(MIN),
        .MAX(MAX),
        .done(done)
    );
    
    assign DATA = MEM[ADDR];
    
    initial begin    
        clk = 0;
        rst_n = 0;
        start = 0;
        #6 rst_n = 1;
        #5 start = 1;
        for (i = 0; i < 1024; i = i + 1) begin
            MEM[i] = $urandom_range(0, 255);
        end
    end
    
    always begin
        #5 clk = ~clk;
    end
endmodule
