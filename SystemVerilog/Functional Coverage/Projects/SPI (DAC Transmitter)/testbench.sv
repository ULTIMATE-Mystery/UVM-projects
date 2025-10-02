module tb();
 
  reg clk = 0, start = 0;
  reg [11:0] din;
  wire mosi;
  wire cs;
  integer i = 0;
  
  dac dut (clk, din, start, mosi, cs);
 
  always #5 clk = ~clk;
 
  initial begin
    #20;
    start = 1;
    #1000;
    start = 0;
  end
  
  initial begin
    for (i = 0; i < 200; i++) begin
      @(posedge clk);
      din = $urandom();
    end
  end
 
  covergroup c @(posedge clk);
    option.per_instance = 1;

    coverpoint dut.state {
      bins out_of_idle     = (dut.idle => dut.init);
      bins setup_data_send = (dut.idle => dut.init[*33] => dut.data_gen);
      bins user_data_send  = (dut.data_gen => dut.send[*33] => dut.cont);
      bins stay_send_33    = (dut.send[*33]);
      bins stay_init_33    = (dut.init[*33]);
      bins start_deassert  = (dut.send => dut.cont => dut.idle);
    }
  endgroup
 
  c ci;
  
  initial begin
    ci = new();
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #2000;
    $finish();
  end

endmodule