module Exercise1_tb;

    logic clk;
    logic rst_n;
    logic start;
    logic done;
    logic [9:0] ADDR;
    logic [7:0] DATA;
    logic [7:0] MAX;
    logic [7:0] MIN;
    logic [7:0] min_temp;
    logic [7:0] max_temp;
    logic [7:0] value_temp;

    logic [7:0] MEM[0:1023];

    Exercise1 #(10,8) DUT(
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .ADDR(ADDR),
        .DATA(DATA),
        .MIN(MIN),
        .MAX(MAX),
        .done(done),
	.min_temp(min_temp),
	.value_temp(value_temp),
	.max_temp(max_temp)
    );
    initial begin 
        $shm_open("waves.shm");
        $shm_probe("ASM");
    end

    // Clock generation
    always #5 clk = ~clk;

    // Testbench logic
    initial begin
        // Initialize inputs
        rst_n = 0;
        clk = 0;
        start = 0;

        // Reset the UUT
        #10;
        rst_n = 1;

        // Fill memory with test data
        for (int i = 0; i < 1024; i = i + 1) begin
            MEM[i] = $urandom_range(8'd5, 8'd255);
        end

        // Apply the start signal

        #10;
        start = 1;
        #10;
        start = 0;

        // Wait for completion
        wait(done);
        #100;

        // Display the results
        $display("MIN: %d", MIN);
        $display("MAX: %d", MAX);

        // End simulation
        $finish;
    end

    // Memory data feeding
    always @(ADDR) begin
        DATA = MEM[ADDR];
    end


endmodule


