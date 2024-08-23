module Exercise1 #(parameter ADDR_WIDTH=10,
                   parameter DATA_WIDTH=8)
            (rst_n,clk,start,ADDR,DATA,MAX,MIN,done, min_temp, max_temp, value_temp);
  input   logic rst_n;  
  input   logic clk;    
  input   logic start;
  output   logic [ADDR_WIDTH-1:0]ADDR;
  input   logic [DATA_WIDTH-1:0]DATA;
  output    logic [DATA_WIDTH-1:0]MIN;
  output   logic [DATA_WIDTH-1:0]MAX;
  output   logic done;
  output  logic [7:0]min_temp;
  output  logic [7:0]max_temp;
  output  logic [7:0]value_temp;
  
  logic lt_1024;
  logic comp_max;
  logic comp_min;
  logic count_rst;
  logic count_ld;
  logic value_rst;
  logic  value_ld;
  logic max_rst;
  logic max_update;
  logic max_ld;
  logic min_ld;
  logic min_set;
  logic min_update;
  
  logic [9:0]count_temp;
  logic [7:0]value_reg_out;
  logic [7:0]max_temp_out;
  logic [7:0]min_temp_out;
  
  assign min_temp= min_temp_out;
  assign max_temp= max_temp_out;
  assign value_temp= value_reg_out;
  register #(10) count_reg (.rst(count_rst),
	  		    .en(count_ld),
			    .set(1'b0),
			    .clk(clk),
			    .D(count_temp),
			    .Q(ADDR));

                    
  adder #(10) adder_countup_1 (.A(ADDR),
                      .S(count_temp));
                     
  register #(8) value_reg (.rst(value_rst),
                    .en(value_ld),
                    .set(1'b0),
                    .clk(clk),
                    .D(DATA),
                    .Q(value_reg_out));
                    
  register #(8) max_temp_reg (.rst(max_rst),
                    .en(max_update),
                    .set(1'b0),
                    .clk(clk),
                    .D(value_reg_out),
                    .Q(max_temp_out));
                    
  register #(8) min_temp_reg (.rst(1'b0),
                    .en(min_update),
                    .set(min_set),
                    .clk(clk),
                    .D(value_reg_out),
                    .Q(min_temp_out));
                    
  register #(8) max_reg (.rst(max_rst),
                    .en(max_ld),
                    .set(1'b0),
                    .clk(clk),
                    .D(max_temp_out),
                    .Q(MAX));    
        
   register #(8) min_reg (.rst(max_rst),
                    .en(min_ld),
                    .set(1'b0),
                    .clk(clk),
                    .D(min_temp_out),
                    .Q(MIN));  
    
  compare_A_lt_B #(8)  compare_min  (.A(min_temp_out),
                          .B(value_reg_out),
                          .A_lt_B(comp_min));
                     
  compare_A_lt_B #(8)  compare_max  (.B(value_reg_out),
                          .A(max_temp_out),
                          .A_lt_B(comp_max));                   
                     
  compare_A_lt_B #(10)  compare_1024    (.A( ADDR),
                            .B(10'd1023),
                            .A_lt_B(lt_1024));    
                      
  FSM       fsm  (.rst_n(rst_n),
             .clk(clk),
             .start(start),
             .lt_1024(lt_1024),
             .comp_max(comp_max),
             .comp_min(comp_min),
             .count_rst(count_rst),
             .count_ld(count_ld),
             .value_rst(value_rst),
             .value_ld(value_ld),
             .max_rst(max_rst),
             .max_update(max_update),
             .max_ld(max_ld),
             .min_ld(min_ld),
             .min_set(min_set),
             .min_update(min_update),
             .done(done));
endmodule

