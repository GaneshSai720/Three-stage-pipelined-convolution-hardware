`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.02.2023 15:54:57
// Design Name: 
// Module Name: top_module
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


module top_5_stage_convolution#(parameter int IMG_SIZE = 512)(input logic clk, input logic reset, input logic [7:0]in[2:0], input logic signed [5:0]FILTER[2:0][2:0], output logic signed [8:0]OUT[IMG_SIZE-3:0][IMG_SIZE-3:0]);
    bit [7:0]R_IN[IMG_SIZE-1:0][IMG_SIZE-1:0]; // from the input R pixels will be loaded here
    bit [7:0]G_IN[IMG_SIZE-1:0][IMG_SIZE-1:0]; // from the input G pixels will be loaded here
    bit [7:0]B_IN[IMG_SIZE-1:0][IMG_SIZE-1:0]; // from the input B pixels will be loaded here
    bit signed [8:0]R_OUT[IMG_SIZE-3:0][IMG_SIZE-3:0];
    bit signed [8:0]G_OUT[IMG_SIZE-3:0][IMG_SIZE-3:0];
    bit signed [8:0]B_OUT[IMG_SIZE-3:0][IMG_SIZE-3:0];
    bit signed [8:0]temp_1[2:0][2:0]; //  temp array used to store the dot product with the weights
    bit signed [8:0]temp_2[2:0][2:0];
    bit signed [8:0]temp_3[2:0][2:0];
    
    bit [$clog2(IMG_SIZE*IMG_SIZE):0]counter; // counts the pixels serially given [18:0] can store more than 512*512 we ideally want it to go upto 512*512 + 4 
    bit [$clog2(IMG_SIZE)-1:0] row,col; 
    bit [$clog2(IMG_SIZE)-1:0] row_1,col_1;
    bit [$clog2(IMG_SIZE)-1:0] row_2,col_2;
    bit [$clog2(IMG_SIZE)-1:0] row_3,col_3;
    bit [$clog2(IMG_SIZE)-1:0] row_4,col_4;
    
    // 1st stage: Serially loading the data:
    always_ff@(posedge clk)
        begin
        if(reset)
            begin
                counter <= 0;
                row <= 0;
                col <= 0;
                row_1 <= 0;
                col_1 <= 0; 
                row_2 <= 0;
                col_2 <= 0;
                row_3 <= 0;
                col_3 <= 0;
                row_4 <= 0;
                col_4 <= 0;
            end        
        else 
            begin  
            
            if(counter < IMG_SIZE*IMG_SIZE)   
                begin
                    R_IN[row][col] <= in[0]; // loading the r_pixel
                    G_IN[row][col] <= in[1]; // loading the g_pixel
                    B_IN[row][col] <= in[2]; // loading the b_pixel
                    if(col == 511)
                    begin
                        row <= row + 1;
                    end
                    col <= col + 1;
                end
                
            else
                begin
                    counter <= 0; 
                    col <= 0;
                    row <= 0; 
                end
             counter++;
                
            end
        end
        
  // 2nd stage: Mutliplication:
  always_ff@(posedge clk)
    begin
        if(row>=4) // waiting until the first five rows and columns are loaded
            begin
               for(int m=0;m<3;m++)
                begin
                    for(int n=0;n<3;n++)
                     begin
                        temp_1[m][n] = FILTER[m][n]*R_IN[row_1+m][col_1+n];
                        temp_2[m][n] = FILTER[m][n]*G_IN[row_1+m][col_1+n];
                        temp_3[m][n] = FILTER[m][n]*B_IN[row_1+m][col_1+n];
                     end
                end  
                if(col_1 == 509)
                begin
                    row_1 <= row_1 + 1;
                    col_1 <= 0;
                end
                else
                col_1 <= col_1 + 1; 
            end 
    end
    
    // 3rd stage: Addition of the dot products:
    always_ff@(posedge clk)
        begin
            if((row_1>=0 && col_1>=1) || row_1 >= 1)
                begin
                   R_OUT[row_2][col_2] <= 0;
                   G_OUT[row_2][col_2] <= 0;
                   B_OUT[row_2][col_2] <= 0;
                   for(int m=0;m<3;m++)
                    begin
                        for(int n=0;n<3;n++)
                         begin
                            $display(" Debug Before adding - %0d %0d %0d %0d",R_OUT[row_2][col_2],temp_1[m][n], row_2, col_2);
                            R_OUT[row_2][col_2] = R_OUT[row_2][col_2] + temp_1[m][n];
                            $display(" Debug After adding - %0d %0d",R_OUT[row_2][col_2],temp_1[m][n]);
                            G_OUT[row_2][col_2] = G_OUT[row_2][col_2] + temp_2[m][n];
                            B_OUT[row_2][col_2] = B_OUT[row_2][col_2] + temp_3[m][n];
                         end
                    end
                    if(col_2 == 509)
                    begin
                        row_2 <= row_2 + 1;
                        col_2 <= 0;
                    end
                    else
                    col_2 <= col_2 + 1; 
                end
        end
    
    
    // 4th stage: Adding r_g_b:
    always_ff@(posedge clk)
        begin    
            if((row_2>=0 && col_2>=1) || row_2>=1)
                begin 
                    OUT[row_3][col_3] = R_OUT[row_3][col_3] + G_OUT[row_3][col_3] + B_OUT[row_3][col_3]; // it will be adding the elements of convolutions of all rgb
                    if(col_3 == 509)
                    begin
                        row_3 <= row_3 + 1;
                        col_3 <= 0;
                    end
                    else
                    col_3 <= col_3 + 1;
                end
        end        
        
    // 5th stage: Normalizing the values to fit them as pixels    
    always@(posedge clk)
    begin
        if((row_3>=0 && col_3>=1) || row_3>=1)
        begin
            if(OUT[row_4][col_4]<0)
                begin
                    OUT[row_4][col_4] <= 0; 
                end
            else if(OUT[row_4][col_4] > 255)
                begin
                    OUT[row_4][col_4] <= 255;
                end  
            if(col_4 == 509)
            begin
                row_4 <= row_4 + 1;
                col_4 <= 0;
            end 
            else
            col_4 <= col_4 + 1;
        end
    end
        
        
endmodule 
        
