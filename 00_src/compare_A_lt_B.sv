module compare_A_lt_B #(parameter WIDTH=8)
            (A,B,A_lt_B);
    
  input   logic [WIDTH -1:0]A;
  input   logic [WIDTH -1:0]B;
  output   logic A_lt_B;
  always_comb
    begin  
      if (A<B)
        A_lt_B =1;
      else 
	A_lt_B =0;
	end
endmodule
