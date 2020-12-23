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
// Module Name: tick_counter_TB                                                                 //
// Project Name: PWM Messages                                                                   //
// Target Devices: Digilent Nexys A7-50T                                                        //
// Tool Versions:                                                                               //
// Description: Project to expermient with scanning 7-segment displays and PWM dimming.         //
// Dependencies: Nexys A7-50T XDC from Digilent's website,                                      //
// or other XDC file for whatever dev board you're using.                                       //
// Additional Comments: My second working FPGA project...                                       //
//////////////////////////////////////////////////////////////////////////////////////////////////


module tick_counter_TB;
    reg clk_TB = 0;
    wire [7:0] sw_stim;
    reg [3:0] sw_1;
    reg [3:0] sw_2;
    wire [7:0] AN_DUT;
    wire [7:0] Cs_DUT;
    
    reg [2:0] i;
    reg [2:0] j;
    //wire [7:0] tick_256;
    //wire [2:0] tick_8;
    
    
    initial
        begin
            clk_TB = 1'b0;
            i = 0;
            j = 0;
            sw_1 = 4'd0;
            sw_2 = 4'd0;
            //init_t256 <= 8'b00000000;
            //init_t8 <= 3'b000;
        end
    
    always #5 
        clk_TB = ~clk_TB;
     
    assign sw_stim = {sw_2, sw_1};
    
    //tick_counter tick_DUT(.clk(clk_TB), .tick_256(tick_256), .tick_8(tick_8));
    PWM_Driver_top driver_DUT(
        .clk(clk_TB),
        .SW(sw_stim),
        .AN(AN_DUT),
        .CA(Cs_DUT[0]), 
        .CB(Cs_DUT[1]),
        .CC(Cs_DUT[2]),
        .CD(Cs_DUT[3]),
        .CE(Cs_DUT[4]),
        .CF(Cs_DUT[5]),
        .CG(Cs_DUT[6]),
        .DP(Cs_DUT[7])
        );
        always #3_333_334
        begin
            if (i < 4)
            begin
                case (i)
                0: sw_1 = 4'b0001; 
                1: sw_1 = 4'b0010;
                2: sw_1 = 4'b0100;
                3: sw_1 = 4'b1000;
                default: sw_1 = 4'b0000;
                endcase
                i = i + 1;
            end
            else
                i = 0;
        end
        always #16_666_670
        begin
            if (j < 5)
            begin
                case (j)
                0: sw_2 = 4'd0; 
                1: sw_2 = 4'd1;
                2: sw_2 = 4'd2;
                3: sw_2 = 4'd4;
                4: sw_2 = 4'd8;
                default: sw_2 = 4'd0; 
                endcase
                j = j + 1;
            end
            else
                j = 0;
        end
        initial
            begin
                #166_666_700;
                $stop;
            end
        
endmodule
