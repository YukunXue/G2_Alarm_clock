`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/05 23:38:17
// Design Name: 
// Module Name: top
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


module top(
    input clk_200MHz_p,
    input clk_200MHz_n,
    input rst_n,
    
    output [4:0] vga_r,
    output [5:0] vga_g,
    output [4:0] vga_b,
    output wire        vga_hs,
    output wire        vga_vs  

    );
   
   wire clk200M;
   wire [15:0] data_dis;
   wire vga_clk;
   wire [10:0] v_addr;
   wire [10:0] h_addr;
   
  	IBUFGDS #(
		.DIFF_TERM    ("FALSE"),
		.IBUF_LOW_PWR ("TRUE"),
		.IOSTANDARD   ("LVDS")
	) get_clk (
		.O  (clk200M),
		.I  (clk_200MHz_p),
		.IB (clk_200MHz_n)
	);
    
  vga_ctrl  u_vga(
    .clk(clk200M),
    .rst_n(rst_n),
    .data_dis(data_dis),
    .h_addr(h_addr),
    .v_addr(v_addr),    
    .hsync(vga_hs),
    .vsync(vga_vs),
    .vga_r(vga_r),
    .vga_g(vga_g),
    .vga_b(vga_b),
    .vga_clk(vga_clk)
    );
    
 data_gen   u_data(
    .vga_clk(vga_clk),
    .rst_n(rst_n),
	.h_addr(h_addr),
	.v_addr(v_addr),
	
	.data_dis(data_dis)
    );
    

endmodule
