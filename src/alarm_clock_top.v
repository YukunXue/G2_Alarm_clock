`timescale 1ns / 1ps

module alarm_clock_top(
    input clk200MHz_p,
    input clk200MHz_n, 
    input rst_n, load_SW, fastfwd_SW, alarm_off_SW, set_BTN,
    input moveRight_BTN, moveLeft_BTN, increment_BTN, decrement_BTN,
//   output outsignal_counter, outsignal_time,

//    output audioOut, aud_sd,
    /*
        G2 use led to replace the aud
    */
    output  alarm_led,
    output  work_led,
    output  second_led,

    output  vga_hs,
    output  vga_vs,
    output  [4:0]   vga_r,
    output  [5:0]   vga_g,
    output  [4:0]   vga_b   

//    output  [7:0]   test_leds
    );

    wire clk200MHz;
    wire clk_100MHz;
    

  	IBUFGDS #(
		.DIFF_TERM    ("FALSE"),
		.IBUF_LOW_PWR ("TRUE"),
		.IOSTANDARD   ("LVDS")
	) get_clk (
		.O  (clk200MHz),
		.I  (clk200MHz_p),
		.IB (clk200MHz_n)
	);

    counter_mod_m #(
        .M(2),
        .N(1)
    ) U_100MHz(
        .clk(clk200MHz),
        .rst_n(rst_n),
        .m_out(clk_100MHz)
    );

    wire outsignal_counter;
    wire outsignal_time;
    //  Signal  Define
    
    wire [3:0] seconds_ones, minutes_ones, load_minutes_ones;
    wire [2:0] seconds_tens, minutes_tens, load_minutes_tens;
    
    wire [3:0] out_seconds_ones, out_minutes_ones;
    wire [2:0] out_seconds_tens, out_minutes_tens;
    
    wire [7:0] timer_seconds_ones, timer_seconds_tens, timer_minutes_ones, timer_minutes_tens;
    
    wire [1:0] two_bit_count;
    wire [3:0] enable_signal;
    wire moveRight_BTN_t, moveLeft_BTN_t, increment_BTN_t, decrement_BTN_t;
    wire set_BTN_t;
    wire set_status;

    wire    [3:0]   set_num;
    wire    [3:0]   set_id;

    wire    vga_clk;
    wire    [10:0]   pixel_x;
    wire    [10:0]   pixel_y; 
    wire            video_on;


    /******************************************************
           按键消抖
    ********************************************************/

    debounce    right_key(
        .clk(clk_100MHz),
        .rst_n(rst_n),
        .key_in(moveRight_BTN),
        .key_out(moveRight_BTN_t)
    );

    debounce    left_key(
        .clk(clk_100MHz),
        .rst_n(rst_n),
        .key_in(moveLeft_BTN),
        .key_out(moveLeft_BTN_t)
    );

    debounce    incre_key(
        .clk(clk_100MHz),
        .rst_n(rst_n),
        .key_in(increment_BTN),
        .key_out(increment_BTN_t)
    );

    debounce    decre_key(
        .clk(clk_100MHz),
        .rst_n(rst_n),
        .key_in(decrement_BTN),
        .key_out(decrement_BTN_t)
    );

    debounce    set_key(
        .clk(clk_100MHz),
        .rst_n(rst_n),
        .key_in(set_BTN),
        .key_out(set_BTN_t)
    );

    always @ (posedge clk_100MHz)begin
        if(!rst_n)  begin
            work_led    <=  1'b0;
        end
        else  if(set_BTN_t|decrement_BTN_t|increment_BTN_t|moveLeft_BTN_t|moveRight_BTN_t)begin
                work_led    <=  1'b1;
            end
            else
                work_led    <=  1'b0;
    end

    /******************************************************
           时钟产生电路
    ********************************************************/

    clock_generator clk_module(
        .clk(clk_100MHz),
        .rst_n(rst_n), 
        .fastFwd(fastfwd_SW), 
        .outsignal_1(outsignal_counter),    //  分频成闹钟工作的时钟
                                            //  当Fast按键按下，则为五倍速速模式，用于调试
        .outsignal_400(outsignal_time)      //  分频出400HZ的时钟       
    );
    
    /******************************************************
            计数电路
    ********************************************************/
    wire min;
 
    //  计数模块
    counter_60 second_counter(
        .clk(clk_100MHz),
        .rst_n(rst_n), 
        .load(load_SW),             //   如果有效，保持原来的状态，计时停止 
        .set(set_status),
        .set_id(set_id[1:0]),
        .set_num(set_num),
        .signal(outsignal_counter), 
        .ones(seconds_ones), 
        .tens(seconds_tens), 
        .loop(min)                  //   loop信号为产生60次加法后的计数
        );

     counter_60 minutes_counter(
        .clk(clk_100MHz),
        .rst_n(rst_n), 
        .load(load_SW),             //   如果有效，保持原来的状态，计时停止 
        .set(set_status),
        .set_id(set_id[3:2]),
        .set_num(set_num),
        .signal(min), 
        .ones(minutes_ones), 
        .tens(minutes_tens), 
        .loop(hour)                  //   loop信号为产生60次加法后的计数
        );



    /******************************************************
            设置时间
    ********************************************************/
    

    set_time set_time_module(
        .clk(clk_100MHz),
        .set(set_status),            //  设置模式使能
        .rst_n(rst_n),
        .incrementBtn(increment_BTN_t), 
        .decrementBtn(decrement_BTN_t),
        .enterBtn(moveRight_BTN_t),
        .set_num(set_num),
        .set_id(set_id)
    );


    /******************************************************
            设置闹钟
    ********************************************************/
 
    //  test_signal 表示任意按键被按下
    wire test_signal = moveRight_BTN_t | moveLeft_BTN_t | increment_BTN_t | decrement_BTN_t;
    set_alarm set_alarm_module(
        .signal(test_signal), 
        .load(load_SW), 
        .moveRightBtn(moveRight_BTN), 
        .moveLeftBtn(moveLeft_BTN),
        .incrementBtn(increment_BTN), 
        .decrementBtn(decrement_BTN), 
        .load_seconds(load_minutes_ones), 
        .load_minutes(load_minutes_tens)
    );

    /******************************************************
            时钟显示选择模块
    ********************************************************/
 

    // display clock or set alarm
    //  如果set有效，则显示
    //  如果load有效，则显示闹钟设置
    //  其他，则显示计时器
    display_clock clock_alarm(
        .load(load_SW),
        .set(set_status),
        .set_id(set_id),
        .set_num(set_num), 
        .seconds_ones(seconds_ones), 
        .minutes_ones(minutes_ones), 
        .load_minutes_ones(load_minutes_ones),
        .seconds_tens(seconds_tens), 
        .minutes_tens(minutes_tens), 
        .load_minutes_tens(load_minutes_tens),
        .out_seconds_ones(out_seconds_ones), 
        .out_minutes_ones(out_minutes_ones), 
        .out_seconds_tens(out_seconds_tens), 
        .out_minutes_tens(out_minutes_tens)
    );

    /******************************************************
           时钟设置信号产生电路
    ********************************************************/

   set_signal_detect    U0_set_signal_detect(
        .clk(clk_100MHz),
        .rst_n(rst_n),
        .other_btn(test_signal),
        .second_clk(outsignal_counter),
        .set_btn(set_BTN_t),

        .set_status(set_status)  //  检测是否是 set 阶段的输出 高电平有效
    );

    /******************************************************
          指示灯部分
    ********************************************************/
    wire play_sound;
    
    check_alarm check_alarm_module(minutes_ones, load_minutes_ones, minutes_tens, load_minutes_tens, load_SW, alarm_off_SW, play_sound);

    assign alarm_led=(play_sound==1)?1'b1:1'b0;

    /******************************************************
          VGA信号产生电路
    ********************************************************/


    vga_sync     u_vga_sync (
        .clk                     ( clk_100MHz      ),
        .rst_n                   ( rst_n           ),

        .hsync                   ( hsync           ),
        .vsync                   ( vsync           ),
        .video_on                ( video_on        ),
        .p_tick                  ( vga_clk         ),
        .pixel_x                 ( pixel_x   [9:0] ),
        .pixel_y                 ( pixel_y   [9:0] )
    );


    rgb_out     u_rgb_out  (
        .clk(clk_100MHz),
        .rst_n(rst_n),
        .minutes_tens(out_minutes_tens),
        .minutes_ones(out_minutes_ones),
        .seconds_tens(out_seconds_tens),
        .seconds_ones(out_seconds_ones),
        .vga_clk(vga_clk),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on),
        .vga_r(VGA_R),
        .vga_b(VGA_B),
        .vga_g(VGA_G)
    );



endmodule