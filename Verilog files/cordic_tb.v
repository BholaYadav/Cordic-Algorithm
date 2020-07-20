`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2020 03:21:07 PM
// Design Name: 
// Module Name: cordic_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cordic_tb;
localparam size=32; 
reg clk;
reg signed [31:0] angle;
reg [size-1:0] xin,yin;
wire signed [size:0] xout,yout;


Cordic sin_cos1 (.clk(clk),.theta(angle),.xin(xin),.yin(yin),.xout(xout),.yout(yout));

localparam inv_gain=32'b01001101101110100111011011010100; // value of 1/gain 0.6072 

parameter period=10;
initial begin
clk=0;
forever #(period/2) clk=~clk;
end

localparam sf=2.0**-31.0;
reg signed [63:0] i;
real cos_theta,sin_theta;

initial begin
angle=0;
xin=inv_gain;
yin=0;
#1000;
for(i=0;i<360;i=i+1)
begin
@(posedge clk);
 angle=((1<<32)*i)/360;
//$display("angle=%d ,%h",i,angle);
//$display("cos(%d)=%f",i,($itor({15'b0,x_out}))*(2.0**-15.0))
cos_theta=($itor(xout))*sf;
sin_theta=($itor(yout))*sf;
#(32*period) $display("%f,%f",cos_theta,sin_theta);
end
#500;
$finish;
end

endmodule
