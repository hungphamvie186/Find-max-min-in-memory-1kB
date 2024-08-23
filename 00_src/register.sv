module register #(parameter WIDTH=8)
            (rst, set, en, clk, D, Q);
  input   logic rst;
  input   logic set;
  input   logic en;
  input   logic clk;    
  input   logic [WIDTH-1:0] D;
  output  logic [WIDTH-1:0] Q;

  always_ff @(posedge clk) begin  
      if (rst)
        Q <= 0;
      else if (set)
        Q <= 'hFF;
      else if (en)
        Q <= D;
    end
endmodule


