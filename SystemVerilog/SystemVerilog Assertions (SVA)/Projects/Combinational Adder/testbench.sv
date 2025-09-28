module adder_assert(
  input [3:0] a,b,
  input [4:0] y
);
 
A1: assert #0 (y == a + b) $info("Suc @ %0t", $time);
 
endmodule

/////////////////////////////////////////////////////

module tb;
  
  reg [3:0] a = 0,b = 0;
  wire [4:0] y;
  
  adder dut (a,b,y);
  
  bind adder adder_assert dut2 (a,b,y);
  
  
  initial begin
    for(int i =0; i < 15; i++)
      begin
        a = $urandom();
        b = $urandom();
        #20;
      end
  end
  
  initial begin
   $dumpfile("dump.vcd");
   $dumpvars;
   $assertvacuousoff(0);
   #350;
   $finish;
 end
      
endmodule