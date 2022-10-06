`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/06 13:39:25
// Design Name: 
// Module Name: data_gen
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


module data_gen(
    input  vga_clk,
	input  rst_n,
	
	input  [10:0] h_addr,
	input  [10:0] v_addr,
	
	output reg [15:0] data_dis
    );
    reg [14:0] addr;
    wire [15:0] q;
    wire add_cnt_addr;
    wire end_cnt_addr;
    parameter	BLACK      =15'h0000,
				RED 	   =15'hf800,
				GREEN	   =15'h320,
				BLUE  	   =15'hf7ff,
				YELLOW	   =15'hffe0,
				SKY_BLUE   =15'h867d,
				PURPLE	   =15'h939b,
				GRAY  	   =15'h8410,
				WHITE      =15'hffff;
				
//œ‘ æ≤ ¥¯
//always@(posedge vga_clk,negedge rst_n)begin
//	if(!rst_n)
//		data_dis<=BLACK;
//	else
//	   if(v_addr<500)
//	   begin
//		   case(v_addr)
//			 1  :data_dis<=WHITE		;
//			 60 :data_dis<=RED 		;
//			 120:data_dis<=GREEN		;
//			 180:data_dis<=BLUE  		;
//			 240:data_dis<=YELLOW		;
//			 300:data_dis<=SKY_BLUE	;
//			 360:data_dis<=PURPLE		;
//			 default:data_dis<=data_dis;
//		  endcase
//	   end       
//end

always@(posedge vga_clk, negedge rst_n)begin		
	if(!rst_n)begin
		data_dis <=BLUE;
	end
	else 
	   if(add_cnt_addr)
		  data_dis <=q;
        else
		  data_dis <=BLACK;
end

always@(posedge vga_clk,negedge rst_n)begin
	if(!rst_n)
		addr<=1'b0;
	else if(add_cnt_addr)
		if(end_cnt_addr)
			addr<=1'b0;
		else
			addr<=addr+1'b1;
   else	
		addr<=addr;

end

assign add_cnt_addr=h_addr<328&&h_addr>=200&&v_addr<328&&v_addr>=200;
assign end_cnt_addr=(addr==16383);



//œ‘ æÕº∆¨
blk_mem_gen_0 u_mem(
    .clka(vga_clk),
    .wea(1'b0),
    .addra(addr),
    .dina(),
    .douta(q)
  );

endmodule
