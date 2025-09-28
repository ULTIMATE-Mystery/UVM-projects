module tb;
  //reg [3:0] a = 4'b0000;
  
  reg clk = 0;
  reg req = 0;
  reg ack = 0;
  reg rst = 0;
  
 always #5 clk = ~clk;
 
initial begin
rst = 1;
#50;
rst = 0;
end
 
initial begin
#30;
req = 1;
#10;
req = 0;
#30;
req = 1;
#10;
req = 0;
ack = 1;
#10;
ack = 0;
end
  
///////////////Ways to disable Check for Concurrent assertions
 
  A2: assert property ( @(posedge clk) disable iff(rst)    req |=> ack )$info("Suc at %0t",$time);
  
  
  initial begin
    #100;
    $finish();
  end
 
endmodule