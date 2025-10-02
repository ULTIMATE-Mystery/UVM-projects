module tb;
  reg clk = 0;
  reg wr  = 0;
  reg rd  = 0;
  reg rst = 0;
  reg [7:0] din = 0;
  wire [7:0] dout;
  wire empty, full;
  
  FIFO dut (clk, rst, wr, rd, din, dout, empty, full);
  
  always #5 clk = ~clk;
  
  integer i = 0;
  
  task write();
    for (i = 0; i < 20; i++) begin  
      wr  = 1'b1;
      rd  = 1'b0;
      din = $urandom();
      @(posedge clk); 
      $display("wr: %0d, addr : %0d, din : %0d full:%0d", wr, i, din, full);
      wr = 0;
      @(posedge clk);
    end  
  endtask
  
  task read();
    for (i = 0; i < 20; i++) begin   
      wr  = 1'b0;
      rd  = 1'b1;
      din = 0;
      @(posedge clk);
      rd = 1'b0;
      @(posedge clk);
      $display("rd: %0d, addr : %0d, dout : %0d empty : %0d", rd, i, dout, empty);
    end  
  endtask
  
  initial begin
    rst = 1;
    wr  = 0;
    rd  = 0;
    repeat (5) @(posedge clk);
    rst = 0;
    write();
    read();
  end
  
  /////////////////////////////////////
  covergroup c @(posedge clk);
    option.per_instance = 1;
    
    coverpoint empty {
      bins empty_l = {0};
      bins empty_h = {1};
    }
   
    coverpoint full {
      bins full_l = {0};
      bins full_h = {1};
    }
  
    coverpoint rst {
      bins rst_l = {0};
      bins rst_h = {1};
    }
  
    coverpoint wr {
      bins wr_l = {0};
      bins wr_h = {1};
    }
  
    coverpoint rd {
      bins rd_l = {0};
      bins rd_h = {1};
    }
  
    coverpoint din {
      bins lower = {[0:84]};
      bins mid   = {[85:169]};
      bins high  = {[170:255]};
    }
   
    coverpoint dout {
      bins lower = {[0:84]};
      bins mid   = {[85:169]};
      bins high  = {[170:255]};
    }
  
    cross_rst_wr: cross rst, wr {
      ignore_bins unused_rst = binsof(rst) intersect {1};
      ignore_bins unused_wr  = binsof(wr)  intersect {0};
    }
    
    cross_rst_rd: cross rst, rd {
      ignore_bins unused_rst = binsof(rst) intersect {1};
      ignore_bins unused_rd  = binsof(rd)  intersect {0};
    }
    
    cross_Wr_din: cross rst, wr, din {
      ignore_bins unused_rst = binsof(rst) intersect {1};
      ignore_bins unused_wr  = binsof(wr)  intersect {0};
    }
  
    cross_rd_dout: cross rst, rd, dout {
      ignore_bins unused_rst = binsof(rst) intersect {1};
      ignore_bins unused_rd  = binsof(rd)  intersect {0};
    }
    
    cross_wr_full: cross rst, wr, full {
      ignore_bins unused_rst  = binsof(rst)  intersect {1};
      ignore_bins unused_wr   = binsof(wr)   intersect {0};
      ignore_bins unused_full = binsof(full) intersect {0};
    }
          
    cross_rd_empty: cross rst, rd, empty {
      ignore_bins unused_rst   = binsof(rst)   intersect {1};
      ignore_bins unused_rd    = binsof(rd)    intersect {0};
      ignore_bins unused_empty = binsof(empty) intersect {0};
    }
  endgroup
  
  c ci = new();
  
  /////////////////////////////
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #1200;
    $finish();
  end
  
endmodule