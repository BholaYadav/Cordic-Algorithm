`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2020 11:38:44 AM
// Design Name: 
// Module Name: Cordic
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
//Angle theta between 0 to 2pi is scaled to fit into 32 bit signed register for eg 45 degree=(45/360)*2^32 which result in resoltion of 2^-30
//The angle vary from 0 to pi or 0 to -pi since we have used signed representation of angle
// the quadrant of angle theta can be determined using the two msb (including signed bit) 00-> first quad, 11-> fourth quad 01-> second 10->third
//////////////////////////////////////////////////////////////////////////////////


module Cordic(clk,theta,xin,yin,xout,yout);
parameter bw=32;
localparam stg=bw;  // no of stages/iteration same as word length of x,y since after that no chnage will occur in x and y
input clk;
input signed [31:0] theta; 
input signed [bw-1:0] xin,yin;
output signed [bw:0] xout,yout;  //
//output signed [31:0] zout;
//######################## Arc(tan(2^-i)) lut #####################
wire signed [31:0] atan [0:30];
assign atan[00]=32'b00100000000000000000000000000000;
assign atan[01]=32'b00010010111001000000010100011110;
assign atan[02]=32'b00001001111110110011100001011011;
assign atan[03]=32'b00000101000100010001000111010100;
assign atan[04]=32'b00000010100010110000110101000011;
assign atan[05]=32'b00000001010001011101011111100001;
assign atan[06]=32'b00000000101000101111011000011110;
assign atan[07]=32'b00000000010100010111110001010101;
assign atan[08]=32'b00000000001010001011111001010011;
assign atan[09]=32'b00000000000101000101111100101111;
assign atan[10]=32'b00000000000010100010111110011000;
assign atan[11]=32'b00000000000001010001011111001100;
assign atan[12]=32'b00000000000000101000101111100110;
assign atan[13]=32'b00000000000000010100010111110011;
assign atan[14]=32'b00000000000000001010001011111010;
assign atan[15]=32'b00000000000000000101000101111101;
assign atan[16]=32'b00000000000000000010100010111110;
assign atan[17]=32'b00000000000000000001010001011111;
assign atan[18]=32'b00000000000000000000101000110000;
assign atan[19]=32'b00000000000000000000010100011000;
assign atan[20]=32'b00000000000000000000001010001100;
assign atan[21]=32'b00000000000000000000000101000110;
assign atan[22]=32'b00000000000000000000000010100011;
assign atan[23]=32'b00000000000000000000000001010001;
assign atan[24]=32'b00000000000000000000000000101001;
assign atan[25]=32'b00000000000000000000000000010100;
assign atan[26]=32'b00000000000000000000000000001010;
assign atan[27]=32'b00000000000000000000000000000101;
assign atan[28]=32'b00000000000000000000000000000011;
assign atan[29]=32'b00000000000000000000000000000001;
assign atan[30]=32'b00000000000000000000000000000001;

reg signed [bw:0] X [0:stg-1];
reg signed [bw:0] Y [0:stg-1];
reg signed [31:0] Z [0:stg-1];



////################### stage 0###############

wire [1:0] quad;
assign quad=theta[31:30];
always@(posedge clk)
    begin
    case(quad)
    2'b00,2'b11:
        begin
        X[0]<=xin;
        Y[0]<=yin;
        Z[0]<=theta;
        end
    2'b01:               ///// angle is between pi/2 to pi
        begin
        X[0]<=-yin;
        Y[0]<=xin;
        Z[0]<={2'b00,theta[29:0]};
        end
    2'b10: // third quad
        begin
        X[0]<=yin;
        Y[0]<=-xin;
        Z[0]<={2'b11,theta[29:0]};
        end
    default:
        begin
        X[0]<=xin;
        Y[0]<=yin;
        Z[0]<=theta;
        end
        
    endcase
    
    end  // end of always

///#################### stage 1

genvar i;
generate
for(i=0;i<(stg-1);i=i+1)
begin:XYZ
wire z_sign;
wire signed [bw:0] X_shr,Y_shr;
assign X_shr=X[i]>>>(i);  // arithmetic right shift
assign Y_shr=Y[i]>>>(i);
assign z_sign=Z[i][31];  // z_sign=1 for z<0
always@(posedge clk)
    begin
    X[i+1]<=z_sign? (X[i]+Y_shr):(X[i]-Y_shr);
    Y[i+1]<=z_sign? (Y[i]-X_shr):(Y[i]+X_shr);
    Z[i+1]<=z_sign? (Z[i]+atan[i]):(Z[i]-atan[i]);
    end
 end // end of for loop
 endgenerate
assign xout=X[stg-1];
assign yout=Y[stg-1];
//assign zout=Z[stg-2];     

endmodule
