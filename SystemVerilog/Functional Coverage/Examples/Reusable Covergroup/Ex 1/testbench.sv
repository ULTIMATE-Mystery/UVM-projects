module tb; 
  reg [3:0] a,b;
  reg [2:0] op;
  wire [4:0] y;
   
  integer i = 0;  
  
  ////////////// covergrop for verifying ranges of input and output  
  covergroup c_var (ref reg [3:0] varn,input string var_id, input int low, input int mid, input int high);
    option.per_instance = 1;
    option.name = var_id;
    
    coverpoint varn
    {
      bins lower_value = {[0:low]};
      bins mid_value =   {[low+1 : mid]};
      bins high_value =  {[mid+1 : high]};        
    }
    
  endgroup 
  
  /////////////////covergroup for verifying all the possible values from different categories      
  covergroup c_op (ref reg [2:0] varn,input string var_id, input int low, input int high);
    option.per_instance = 1;
    option.name = var_id;
    
   coverpoint varn
    {
      bins op_type[] = {[low:high]};
    }
    
  endgroup 
  
  ////////////////////////////////////////// 
  c_var cia = new(a, "Input data bus a", 3, 10, 15);
  c_var cib = new(b, "Input data bus b", 3, 10, 15);
  c_op  ciar = new(op, "Arithmetic Oper", 0,3);
  c_op  cilo = new(op, "Logical Oper", 4,7);
  
  initial begin 
    
    for (i = 0; i <50; i++) begin
      a = $urandom();
      b = $urandom();
      op = $urandom();
      cia.sample();
      cib.sample();
      ciar.sample();
      cilo.sample();
      #10;
      
    end
        
  end
        
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #500;
    $finish();
  end
      
endmodule