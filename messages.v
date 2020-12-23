`timescale 1ns / 1ps
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
// Module Name: messages                                                                        //
// Project Name: PWM Messages                                                                   //
// Target Devices: Digilent Nexys A7-50T                                                        //
// Tool Versions:                                                                               //
// Description: Project to expermient with scanning 7-segment displays and PWM dimming.         //
// Dependencies: Nexys A7-50T XDC from Digilent's website,                                      //
// or other XDC file for whatever dev board you're using.                                       //
// Additional Comments: My second working FPGA project...                                       //
//////////////////////////////////////////////////////////////////////////////////////////////////


module messages (
    //input               clk_in,
    input       [3:0]   sel,
    input       [3:0]   disp_pos,  //requested display position
    output      [7:0]   disp_out  //send character mask
    );
    
    reg [3:0] msg_select = 4'b0000;
    reg [8*8-1:0] active_msg;
    reg [7:0] active_pos;
    reg [7:0] disp_char;
    assign disp_out = ~disp_char; // need to go and manually flip the binary data for the characters, but for now, this is fine
    
    always @(sel)
        begin
        msg_select = sel;
        case(msg_select)
            4'b0000 : active_msg = "--------"; //messages of 8 characters can be entered in here with capital ascii text hyphens "-" and dots "."
            4'b0001 : active_msg = "--------"; //for M and W, you must enter it twice, as it relies on n and u respectively. H is lowercase by
            4'b0010 : active_msg = "--------"; //default because K is displayed by an equivalent character to H, yes I looks strange, but it's
            4'b0100 : active_msg = "--------"; //that way to distinguish it from L, feel free to edit the character binaries below.
            4'b1000 : active_msg = "--------";
            default : active_msg = "--------";
        endcase
        end
        
    always @(disp_pos)
        begin
            case(disp_pos)
                4'd0 : active_pos = active_msg[7:0];
                4'd1 : active_pos = active_msg[15:8];
                4'd2 : active_pos = active_msg[23:16];
                4'd3 : active_pos = active_msg[31:24];
                4'd4 : active_pos = active_msg[39:32];
                4'd5 : active_pos = active_msg[47:40];
                4'd6 : active_pos = active_msg[55:48];
                4'd7 : active_pos = active_msg[63:56];
            endcase 
        end
        
    always @(active_pos)
        begin
            case (active_pos)
                "0" : disp_char = 8'b00111111;
                "1" : disp_char = 8'b00000110;
                "2" : disp_char = 8'b01011011;
                "3" : disp_char = 8'b01001111;
                "4" : disp_char = 8'b01100110;
                "5" : disp_char = 8'b01101101;
                "6" : disp_char = 8'b01111100;
                "7" : disp_char = 8'b00000111;
                "8" : disp_char = 8'b01111111;
                "9" : disp_char = 8'b01100111;
                "A" : disp_char = 8'b01110111;
                "B" : disp_char = 8'b00111111;
                "C" : disp_char = 8'b00111001;
                "D" : disp_char = 8'b01011110;
                "E" : disp_char = 8'b01111011;
                "F" : disp_char = 8'b01110001;
                "G" : disp_char = 8'b01111101;
                "H" : disp_char = 8'b01110100;
                "I" : disp_char = 8'b00001111;
                "J" : disp_char = 8'b00011110;
                "K" : disp_char = 8'b01110110;
                "L" : disp_char = 8'b00111000;
                "M" : disp_char = 8'b01010100;
                "N" : disp_char = 8'b01010100;
                "O" : disp_char = 8'b00111111;
                "P" : disp_char = 8'b01110011;
                "Q" : disp_char = 8'b01100111;
                "R" : disp_char = 8'b00110001;
                "S" : disp_char = 8'b01101101;
                "T" : disp_char = 8'b00000111;
                "U" : disp_char = 8'b00011100;
                "V" : disp_char = 8'b00011100;
                "W" : disp_char = 8'b00011100;
                "X" : disp_char = 8'b01110110;
                "Y" : disp_char = 8'b01101110;
                "Z" : disp_char = 8'b01011011;
                "." : disp_char = 8'b10000000;
                "-" : disp_char = 8'b01000000;
                " " : disp_char = 8'b00000000;
                default : disp_char = 8'b00000000;
            endcase
        end
    
endmodule

