`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////////////////
//  GNU GPLv3                                                                                   //
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
// Module Name: PWM_Driver_top                                                                  //
// Project Name: PWM Messages                                                                   //
// Target Devices: Digilent Nexys A7-50T                                                        //
// Tool Versions:                                                                               //
// Description: Project to expermient with scanning 7-segment displays and PWM dimming.         //
// Dependencies: Nexys A7-50T XDC from Digilent's website,                                      //
// or other XDC file for whatever dev board you're using.                                       //
// Additional Comments: My second working FPGA project...                                       //
//////////////////////////////////////////////////////////////////////////////////////////////////


module PWM_Driver_top(
    input   clk,
    input   [7:0] SW,
    output  [7:0] AN,
    output  CA, CB, CC, CD, CE, CF, CG, DP
    );
    
    wire [7:0] tick_256;
    wire [2:0] tick_8;
    wire [7:0] disp_in;
    reg [3:0] SW_MSG;
    reg [3:0] disp_pos = 0;
    reg [7:0] AN_SEL = 0;
    reg [7:0] intensity;
    //reg [7:0] pulse_counter = 0;
    always @ (posedge(clk)) SW_MSG = SW[3:0];
    
    tick_counter tickPWM(.clk_in(clk), .tick_256(tick_256), .tick_8(tick_8));
    messages msgsPWM(.sel(SW_MSG),.disp_pos(disp_pos) , .disp_out(disp_in));
    
    assign CA = disp_in[0];
    assign CB = disp_in[1];
    assign CC = disp_in[2];
    assign CD = disp_in[3];
    assign CE = disp_in[4];
    assign CF = disp_in[5];
    assign CG = disp_in[6];
    assign DP = disp_in[7];
    assign AN = AN_SEL;
    always @(tick_8) 
        disp_pos = tick_8;
        
    always @(posedge(clk))
        begin
            case (SW[7:4])
                4'b0001 : intensity = 63;
                4'b0010 : intensity = 127;
                4'b0100 : intensity = 191;
                4'b1000 : intensity = 255;
                default : intensity = 0; 
            endcase
        end
        
    always @(tick_256) //handle 1 seven segment
        begin
            if (tick_256 < intensity)
                begin
                    case (disp_pos)
                        4'd0 : AN_SEL = 8'b11111110;
                        4'd1 : AN_SEL = 8'b11111101;
                        4'd2 : AN_SEL = 8'b11111011;
                        4'd3 : AN_SEL = 8'b11110111;
                        4'd4 : AN_SEL = 8'b11101111;
                        4'd5 : AN_SEL = 8'b11011111;
                        4'd6 : AN_SEL = 8'b10111111;
                        4'd7 : AN_SEL = 8'b01111111; 
                    endcase
                end
            else
                AN_SEL = 8'b11111111;
        end
endmodule
