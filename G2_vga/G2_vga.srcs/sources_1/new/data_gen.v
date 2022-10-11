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
    
    //char
    reg [ 96:0 ] char_line[ 15:0 ];//16*6个字符=96,96*16的字符存储区
    
    reg [14:0] addr;
    wire [15:0] q;
    reg [14:0] cnt;
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
				
//显示彩带
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

//always@(posedge vga_clk, negedge rst_n)begin		
//	if(!rst_n)begin
//		data_dis <=BLUE;
//	end
//	else 
//	   if(add_cnt_addr)
//		  data_dis <=q;
//        else
//		  data_dis <=BLACK;
//end

//always@(posedge vga_clk,negedge rst_n)begin
//	if(!rst_n)begin
//		addr<=1'b0;
//		cnt <= 1'b0;
//	end	
//	else if(add_cnt_addr)
//		if(end_cnt_addr)
//			addr<=1'b0;
//		else begin
//			addr<=addr+1'b1;
//			cnt<=cnt+14'd1;
//			end
//   else	begin
//		addr<=addr;
//		cnt<=cnt;
//		end		
//end

//显示颜色
always@(posedge vga_clk,negedge rst_n)begin
	if(!rst_n)begin
		addr<=1'b0;
		cnt <= 1'b0;
	end	
    else if (char_line[v_addr][95 - h_addr] == 1'b1) begin
                data_dis <= PURPLE ;
          end
    else begin
                data_dis <= BLACK   ;
         end
 end
//        else 
//            data_dis <= BLACK;
//    end


assign add_cnt_addr=h_addr<129&&h_addr>=1&&v_addr<129&&v_addr>=1;
assign end_cnt_addr=(addr==16383);
//初始化显示文字
always@( posedge vga_clk or negedge rst_n ) begin
        if ( !rst_n ) begin//将前面得到的点阵放在这里~
          char_line[ 0 ]  = 96'h082001000200000000000080;
          char_line[ 1 ]  = 96'h082001000200fffe0efc2040;
          char_line[ 2 ]  = 96'h0820020002000440ea081040;
          char_line[ 3 ]  = 96'h102002007ffc0440aa0817fc;
          char_line[ 4 ]  = 96'h1020044004000440aae80010;
          char_line[ 5 ]  = 96'h3020084009003ff8aaa80210;
          char_line[ 6 ]  = 96'h37fe108011002448aca8f120;
          char_line[ 7 ]  = 96'h5020208021002448aaa810a0;
          char_line[ 8 ]  = 96'h902041003ff82448aaa81040;
          char_line[ 9 ]  = 96'h1020020001002448aaa810a0;
          char_line[ 10 ] = 96'h1020042009202838eae81110;
          char_line[ 11 ] = 96'h1020081011103008aaa81208;
          char_line[ 12 ] = 96'h10201008210820080c081408;
          char_line[ 13 ] = 96'h10203ffc4104200808082800;
          char_line[ 14 ] = 96'h1020100405003ff8082847fe;
          char_line[ 15 ] = 96'h102000000200200808100000;
        end
    end


//显示图片
//blk_mem_gen_0 u_mem(
//    .clka(vga_clk),
//    .wea(1'b0),
//    .addra(addr),
//    .dina(),
//    .douta(q)
//  );

endmodule
