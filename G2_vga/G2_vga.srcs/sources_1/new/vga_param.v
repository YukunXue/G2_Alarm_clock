`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/06 10:24:54
// Design Name: 
// Module Name: vga_param
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


`define vga_1024_600_60 //根据需要自行选择

`ifdef  vga_640_480
 
    `define H_Right_Border 8
    `define H_Front_Proch  8
    `define H_Sync_Time    96
    `define H_Back_Proch   40
    `define H_Left_Border  8
    `define H_Data_Time    640
    `define H_Total_Time   800

    `define V_Bottom_Border 8
    `define V_Front_Proch   2
    `define V_Sync_Time     2
    `define V_Back_Proch    25
    `define V_Top_Border    8
    `define V_Data_Time     480
    `define V_Total_Time    525
`elsif   vga_1024_768_75  //75MHz
	 `define H_Right_Border 0
    `define H_Front_Proch  16
    `define H_Sync_Time    96
    `define H_Back_Proch   176
    `define H_Left_Border  0
    `define H_Data_Time    1024
    `define H_Total_Time   1312

    `define V_Bottom_Border 0
    `define V_Front_Proch   1
    `define V_Sync_Time     3
    `define V_Back_Proch    28
    `define V_Top_Border    0
    `define V_Data_Time     768
    `define V_Total_Time    800
`elsif   vga_1024_768_60  //60MHz
	 `define H_Right_Border 0
    `define H_Front_Proch  24
    `define H_Sync_Time    136
    `define H_Back_Proch   160
    `define H_Left_Border  0
    `define H_Data_Time    1024
    `define H_Total_Time   1344

    `define V_Bottom_Border 0
    `define V_Front_Proch   3
    `define V_Sync_Time     6
    `define V_Back_Proch    29
    `define V_Top_Border    0
    `define V_Data_Time     768
    `define V_Total_Time    806
`elsif   vga_1024_600_60  //60Hz 50.4MHz
	 `define H_Right_Border 0
    `define H_Front_Proch  24
    `define H_Sync_Time    136
    `define H_Back_Proch   160
    `define H_Left_Border  0
    `define H_Data_Time    1024
    `define H_Total_Time   1344

    `define V_Bottom_Border 0
    `define V_Front_Proch   1
    `define V_Sync_Time     4
    `define V_Back_Proch    21
    `define V_Top_Border    0
    `define V_Data_Time     600
    `define V_Total_Time    626    
    
/**根据需要自行添加修改**/
`endif

