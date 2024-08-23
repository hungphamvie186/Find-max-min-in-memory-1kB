module adder #(parameter WIDTH=10)
            (A,S);
    
  input   logic [WIDTH -1:0]A;
  output   logic [WIDTH -1:0]S;
  
     assign S=A+ 10'd1;
endmodule
