// tạo bin61 statee_t chỉ nhận 1 trong 8 trạng thái vì vd 5 trạng thái thì cần 3 bit mà 3 bit thì có thể gán cho 8 trạng thái nên cần khai báo để tránh phần dư
module FSM( input logic rst_n, 
				input logic clk, 
				input logic start, 
				input logic lt_1024, 
				input logic comp_max, 
				input logic comp_min, 
				output logic count_rst, 
				output logic count_ld, 
				output logic value_rst, 
				output logic value_ld, 
				output logic max_rst, 
				output logic max_update, 
				output logic max_ld,
				output logic min_ld, 
				output logic min_set, 
				output logic min_update, 
				output logic done );
  parameter [2:0]  S0 =4'd0, 
	  	   S1 =4'd1, 
		   S2 =4'd2, 
		   S3 =4'd3, 
		   S4 =4'd4, 
		   S5 =4'd5, 
		   S6 =4'd6, 
		   S7 =4'd7; 
	 reg [2:0] state, next_state;
  
  always_ff @(posedge clk)
  begin
    if (!rst_n)   // đợi rst_n tích cực thì reset nếu rst chưa tích cực thì hệ thống hoạt động bình thường 
      state <= S0;
    else
      state <= next_state;
  end
  
  always @(state or  start or lt_1024 or comp_max or comp_min )
  begin
    case (state)
      S0: if (start)  next_state = S1;
          else        next_state = S0;
      S1: next_state = S2;
      S2: if (lt_1024) next_state = S3;
          else         next_state = S7;
      S3: if (comp_min && comp_max) next_state = S4; 
          else if (!comp_min && !comp_max) next_state = S5; 
          else if (!comp_min && comp_max) next_state = S6; 
          else next_state = S2; // This line was missing
      S4: next_state = S2;
      S5: next_state = S2;
      S6: next_state = S2;
      S7: next_state = S0;
    endcase
  end
  
  always_comb
  begin
    count_rst = 1'b0;
    count_ld = 1'b0;
    value_rst = 1'b0;
    value_ld = 1'b0;
    max_rst = 1'b0;
    max_update = 1'b0;
    max_ld = 1'b0;
    min_set = 1'b0;
    min_ld = 1'b0;
    min_update = 1'b0;
    done = 1'b0;
    case (state)
      S0: begin
           count_rst = 1'b0;
           count_ld = 1'b0;
           value_ld = 1'b0;
           value_rst = 1'b0;
           max_rst = 1'b0;
           max_update = 1'b0;
           max_ld = 1'b0;
           min_ld = 1'b0;
           min_set = 1'b0;
           min_update = 1'b0;
           done = 1'b0;
         end
      S1: begin //rest
           count_rst = 1'b1;//
           count_ld = 1'b0;
           value_ld = 1'b0;
           value_rst = 1'b1; //
           max_rst = 1'b1;//
           max_update = 1'b0;
           min_ld = 1'b0;
           min_set = 1'b1;// cho giá trị min lên FF
           min_update = 1'b0;
           max_ld = 1'b0;
           done = 1'b0;
         end
      S2: begin //count 0-->1023 la 1024 o nho
           count_rst = 1'b0;
           count_ld = 1'b0;
           value_ld = 1'b1;
           value_rst = 1'b0;
           max_rst = 1'b0;
           max_update = 1'b0;
           min_ld = 1'b0;
           min_set = 1'b0;
           min_update = 1'b0;
           max_ld = 1'b0;
           done = 1'b0;
         end
      S3: begin // doc value data va tang count
           count_rst = 1'b0;
           count_ld = 1'b1;  // cho phép công thêm 1 vào count 
           value_ld = 1'b1; // ld giá trị
           value_rst = 1'b0;
           max_rst = 1'b0;
           max_update = 1'b0;
           min_ld = 1'b0;
           min_set = 1'b0;
           min_update = 1'b0;
           max_ld = 1'b0;
           done = 1'b0;
         end
      S4: begin   // cập nhật max 
           count_rst = 1'b0;
           count_ld = 1'b0;
           value_ld = 1'b0;
           value_rst = 1'b0;
           max_rst = 1'b0;
           max_update = 1'b1;
           min_ld = 1'b0;
           min_set = 1'b0;
           min_update = 1'b0;
           max_ld = 1'b0;
           done = 1'b0;
         end
      S5: begin
           count_rst = 1'b0;
           count_ld = 1'b0;
           value_ld = 1'b0;
           value_rst = 1'b0;
           max_rst = 1'b0;
           max_update = 1'b0;
           min_ld = 1'b0;
           min_set = 1'b0;
           min_update = 1'b1;
           max_ld = 1'b0;
           done = 1'b0;
         end
      S6: begin
           count_rst = 1'b0;
           count_ld = 1'b0;
           value_ld = 1'b0;
           value_rst = 1'b0;
           max_rst = 1'b0;
           max_update = 1'b1;
           min_ld = 1'b0;
           min_set = 1'b0;
           min_update = 1'b1;
           max_ld = 1'b0;
           done = 1'b0;
         end
      S7: begin
           count_rst = 1'b0;
           count_ld = 1'b0;
           value_ld = 1'b0;
           value_rst = 1'b0;
           max_rst = 1'b0;
           max_update = 1'b0;
           min_ld = 1'b1;
           min_set = 1'b0;
           min_update = 1'b0;
           max_ld = 1'b1;
           done = 1'b1;
         end
    endcase
  end
endmodule
