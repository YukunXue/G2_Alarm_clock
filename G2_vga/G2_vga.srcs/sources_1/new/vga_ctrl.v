`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/06 10:23:52
// Design Name: 
// Module Name: vga_ctrl
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
`include "vga_param.v"

module vga_ctrl(
    input   clk,
    input   rst_n,
    input   [15:0]data_dis,
    output  reg [10:0] h_addr,
    output  reg [10:0] v_addr,    
    output  reg        hsync,
    output  reg        vsync,
    output  reg  [4:0] vga_r,
    output  reg  [5:0] vga_g,
    output  reg  [4:0] vga_b,
    output             vga_clk
    );
    
    reg [11:0]  cnt_h_addr;
    wire        add_h_addr;
    wire        end_h_addr;
    
    reg [11:0]  cnt_v_addr;
    wire        add_v_addr;
    wire        end_v_addr;
  
  parameter    H_DATA_STA=`H_Sync_Time+`H_Back_Proch+`H_Left_Border,
				H_DATA_STO=`H_Sync_Time+`H_Back_Proch+`H_Left_Border+`H_Data_Time,
  				V_DATA_STA =`V_Sync_Time+`V_Back_Proch+`V_Top_Border,
				V_DATA_STO =`V_Sync_Time+`V_Back_Proch+`V_Top_Border+`V_Data_Time;
    always@(posedge vga_clk,negedge rst_n)begin
	if(!rst_n)
		cnt_h_addr<=12'b0;
	else if(add_h_addr)
		if(end_h_addr)
			cnt_h_addr<=12'b0;
		else
			cnt_h_addr<=cnt_h_addr+12'b1;
	else
		cnt_h_addr<=cnt_h_addr;
    end
    
assign add_h_addr=1'b1;
assign end_h_addr=add_h_addr&&cnt_h_addr>=`H_Total_Time-1;
    
    always@(posedge vga_clk,negedge rst_n)begin
	if(!rst_n)
		cnt_v_addr<=12'b0;
	else if(add_v_addr)
		if(end_v_addr)
			cnt_v_addr<=12'b0;
		else
			cnt_v_addr<=cnt_v_addr+12'b1;
	else
		cnt_v_addr<=cnt_v_addr;
    end
     
assign add_v_addr=end_h_addr;
assign end_v_addr=add_v_addr&&cnt_v_addr>=`V_Total_Time-1;

always@(posedge vga_clk, negedge rst_n)begin
	if(!rst_n)
		hsync<=1'b1;
	else if(cnt_h_addr==`H_Sync_Time-1)
		hsync<=1'b0;
	else if(cnt_h_addr==`H_Total_Time-1)
		hsync<=1'b1;
	else
		hsync<=hsync;
end

always@(posedge vga_clk, negedge rst_n)begin
	if(!rst_n)
		vsync<=1'b1;
	else if(cnt_v_addr==`V_Sync_Time-1)
		vsync<=1'b0;
	else if(cnt_h_addr==`V_Total_Time-1)
		vsync<=1'b1;
	else
		vsync<=vsync;
end

//数据有效显示区域定义
always@(posedge vga_clk, negedge rst_n)begin
	if(!rst_n)
		h_addr<=11'd0;
	else if(cnt_h_addr>=H_DATA_STO)
		h_addr<=11'd0;
	else if(cnt_h_addr>=H_DATA_STA)
		h_addr<=cnt_h_addr-H_DATA_STA;
	else 
		h_addr<=11'd0;
end

always@(posedge vga_clk, negedge rst_n)begin
	if(!rst_n)
		v_addr<=11'd0;
	else if(cnt_v_addr>=V_DATA_STO)
		v_addr<=11'd0;
	else if(cnt_v_addr>=V_DATA_STA)
		v_addr<=cnt_v_addr-V_DATA_STA;
	else 
		v_addr<=11'd0;
end

always@(posedge vga_clk,negedge rst_n)begin
	if(!rst_n)begin
		vga_r<=4'b0;
		vga_g<=5'b0;
		vga_b<=4'b0;
	end
	else if((cnt_h_addr>=H_DATA_STA-1)&&(cnt_h_addr<=H_DATA_STO-1)&&(cnt_v_addr>=V_DATA_STA-1)&&(cnt_v_addr<=V_DATA_STO-1))begin
		vga_r<=data_dis[15:11];
		vga_g<=data_dis[10:5];
		vga_b<=data_dis[4:0];
	end
	else begin
	    vga_r<=4'b0;
		vga_g<=5'b0;
		vga_b<=4'b0;
	end
end


wire lock;

clk_wiz_0 PLL(
  // Clock out ports
  .clk_out1(vga_clk),//for 1024*600 50.4MHz
  // Status and control signals
  .resetn(rst_n),
  .locked(lock),
 // Clock in ports
  .clk_in1(clk)//200MHz
);


endmodule
