module tb;
  reg clk = 0;
  reg  din = 0;
  reg rst = 0;
  wire dout;
  
  top dut (clk,rst,din,dout);
  
  always #5 clk = ~clk;
  
  initial begin
    #3;
    rst = 1;
    #30;
    rst = 0;
    din = 1;
    #45;
    din = 0;
    #25;
    rst = 1;
    #40;
    rst = 0;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    $assertvacuousoff(0);
    #180;
    $finish;    
  end
  
  ////////// (1) State is one hot encoded
  
  state_encoding : assert property (@(posedge clk) 1'b1 |-> $onehot(dut.state));
 
  ////////////// (2) Behavior on rst high
  
    state_rst_high:  assert property (@(posedge clk) rst |=> (dut.state == dut.idle));
  
  state_thr_rst_high:   assert property (@(posedge clk) $rose(rst) |=> (((dut.state == dut.idle)[*1:18]) within (rst[*1:18] ##1 !rst)));
  
/////////////////    (3) Behavior on rst low 
     
  sequence s1;
    (dut.next_state == dut.idle) ##1 (dut.next_state == dut.s0);    
  endsequence
 
   sequence s2;
     (dut.next_state == dut.s0) ##1 (dut.next_state == dut.s1);    
  endsequence
      
      
  sequence s3;
    (dut.next_state == dut.s1) ##1 (dut.next_state == dut.s0);    
  endsequence
      
    state_din_high: assert property (@(posedge clk) disable iff(rst) din |-> (s1 or s2 or s3));  
      
//////////////////////////////////////////////////////////////////////////////////////////////////      
   sequence s4;
     (dut.next_state == dut.idle) ##1 (dut.next_state == dut.s0);    
  endsequence
 
   sequence s5;
     (dut.next_state == dut.s0) ##1 (dut.next_state == dut.s0);    
  endsequence
      
      
  sequence s6;
    (dut.next_state == dut.s1) ##1 (dut.next_state == dut.s1);    
  endsequence 
      
      
      state_din_low: assert property (@(posedge clk) disable iff(rst) !din |-> (s4 or s5 or s6));    
   //////////////////////////////////////////////////////////////////////////////////////////////        
          
 property p1;
   @(posedge clk)
   if(din)
     (s1 or s2 or s3)
   else
     (s4 or s5 or s6);
 endproperty
    
      state_din: assert property (disable iff(rst) p1);
      
  /////////////////////////////////////////////////////////// 
                          
  ///////////////   (4) all states are cover
 
  initial assert property (@(posedge clk) (dut.state == dut.idle)[->1] |-> ##[1:18] (dut.state == dut.s0) ##[1:18] (dut.state == dut.s1)); 
                
    ////////////   (5)  Output check
  
    assert property (@(posedge clk) disable iff(rst) ((dut.next_state == dut.s0) && ($past(dut.next_state) == dut.s1)) |-> (dout == 1'b1) );
      
endmodule