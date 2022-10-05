`timescale 1ns / 1ps

module alarm_clock_top(
    input clk200MHz_p,
    input clk200MHz_n, 
    input rst_n, load_SW, fastfwd_SW, alarm_off_SW, set_BTN,
    input moveRight_BTN, moveLeft_BTN, increment_BTN, decrement_BTN,
    output outsignal_counter, outsignal_time,

    output audioOut, aud_sd,
    
    output  hsync,
    output  vsync,
    output  [3:0]   VGA_R,
    output  [3:0]   VGA_G,
    output  [3:0]   VGA_B   

//    output  [7:0]   test_leds
    );

    wire clk_100MHz;

clock_pll PLL(


);


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
    wire    [9:0]   pixel_x;
    wire    [9:0]   pixel_y; 
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
    
