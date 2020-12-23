`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////////////////////
// GNU GPLv3                                                                                   //
//////////////////////////////////////////////////////////////////////////////////////////////////
// PWM Messages - Project to expermient with scanning 7-segment displays and PWM dimming.       //
//    Copyright (C) 2020  Kyle T. Goodman                                                       //
//                                                                                              //
//    This program is free software: you can redistribute it and/or modify                      //
//    it under the terms of the GNU General Public License as published by                      //
//    the Free Software Foundation, either version 3 of the License, or                         //
//    (at your option) any later version.                                                       //
//                                                                                              //
//    This program is distributed in the hope that it will be useful,                           //
//    but WITHOUT ANY WARRANTY; without even the implied warranty of                            //
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                             //
//    GNU General Public License for more details.                                              //
//                                                                                              //
//    You should have received a copy of the GNU General Public License                         //
//    along with this program.  If not, see <https://www.gnu.org/licenses/>.                    //
//////////////////////////////////////////////////////////////////////////////////////////////////
// Company: Kyle T. Goodman Goodman                                                             //
// Engineer: Kyle T. Goodman                                                                    //
//                                                                                              //
// Create Date: 12/17/2020 10:55:13 PM                                                          //
// Design Name: PWM Messages                                                                    //
// Module Name: tick_counter                                                                    //
// Project Name: PWM Messages                                                                   //
// Target Devices: Digilent Nexys A7-50T                                                        //
// Tool Versions:                                                                               //
// Description: Project to expermient with scanning 7-segment displays and PWM dimming.         //
// Dependencies: Nexys A7-50T XDC from Digilent's website,                                      //
// or other XDC file for whatever dev board you're using.                                       //
// Additional Comments: My second working FPGA project...                                       //
//////////////////////////////////////////////////////////////////////////////////////////////////


module tick_counter(
    input clk_in,
    output reg [7:0] tick_256 = 0, //60Hz divided into 8 frames of 256 ticks from 10ns clock
    output reg [2:0] tick_8 = 0 //60Hz divided into 8 frames
    );
    reg [10:0] pwm_div_counter = 0; //count to 813, just under 60Hz by 8 displays, by 256 divisions for pwm pulses
    //reg [7:0] tick_8x60x256 = 0; //60Hz divided into 8 frames of 256 ticks from 10ns clock
    //reg [2:0] tick_8x60 = 0; //60Hz divided into 8 frames
        
    //assign tick_256 = tick_8x60x256;
    //assign tick_8 = tick_8x60;
    always @(posedge(clk_in))
        begin
            if (pwm_div_counter < 11'd813)
                begin
                    pwm_div_counter = pwm_div_counter + 1;
                end
            else 
                begin
                    //tick_8x60x256 = tick_8x60x256 + 1;
                    tick_256 = tick_256 + 1;
                    pwm_div_counter = 11'd0;
                    //if (tick_8x60x256 == 8'b00000000)
                    if (tick_256 == 8'b00000000)
                        //tick_8x60 = tick_8x60 +1;
                        tick_8 = tick_8 +1;
                end
        end

endmodule

