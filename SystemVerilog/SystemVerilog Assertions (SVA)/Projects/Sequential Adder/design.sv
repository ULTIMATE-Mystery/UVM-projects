`timescale 1ns/1ps
 
module add(
 input [7:0] a,b,input clk,
 output reg [8:0] sum 
);
 
  always@(posedge clk) begin
    sum <= a + b;
  end
 
endmodule
 
 
interface add_intf();
logic clk;  
logic [7:0] a;
logic [7:0] b;
logic [8:0] sum;
endinterface