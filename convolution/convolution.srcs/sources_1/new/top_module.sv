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


module top_module#(parameter int IMG_SIZE = 512)(input logic clk, input logic reset, input integer in[2:0], input integer FILTER[2:0][2:0], output integer OUT[IMG_SIZE-3:0][IMG_SIZE-3:0], output integer R_OUT[IMG_SIZE-3:0][IMG_SIZE-3:0], output integer G_OUT[IMG_SIZE-3:0][IMG_SIZE-3:0], output integer B_OUT[IMG_SIZE-3:0][IMG_SIZE-3:0]);
    integer R_IN[IMG_SIZE-1:0][IMG_SIZE-1:0]; // from the input R pixels will be loaded here
    integer G_IN[IMG_SIZE-1:0][IMG_SIZE-1:0]; // from the input G pixels will be loaded here
    integer B_IN[IMG_SIZE-1:0][IMG_SIZE-1:0]; // from the input B pixels will be loaded here
    
    integer counter = 0; // counts the pixels serially given
    integer row,col,loading_col; 
    integer R_temp,G_temp,B_temp;
    
    always_ff@(posedge clk)
        begin
        if(reset)
            begin
                counter = 0;
            end        
        else 
            begin     
                row = counter/IMG_SIZE;
                col = counter%IMG_SIZE;
                loading_col = col - 1;
                if(counter < IMG_SIZE*IMG_SIZE)
                    begin
                        R_IN[row][col] = in[0]; // loading the r_pixel
                        G_IN[row][col] = in[1]; // loading the g_pixel
                        B_IN[row][col] = in[2]; // loading the b_pixel
                        counter++;
                    end
                else if(counter > IMG_SIZE*IMG_SIZE)
                    begin
                        counter = 0;
                    end
            end
        end
        
    always_ff@(posedge clk)
    begin
        if(reset) 
            begin
                for(int m = 0; m < IMG_SIZE; m++)
                    begin
                        for(int n = 0; n < IMG_SIZE; n++)
                            begin
                                R_OUT[m][n] = 0;
                            end
                    end 
            end
            
        else
            begin
                if(row>=2 && row<=IMG_SIZE-1) // we have to wait until there are 3 rows and 3 cols because the filter is of size of 3x3
                begin
                    if(col>=2 && col<=IMG_SIZE-1)
                        begin
                            R_temp = 0;                        
                            for(int k=0;k<3;k++)
                                begin
                                    for(int l=0;l<3;l++)
                                        begin
                                            R_temp =  R_temp + R_IN[row-2+k][col-2+l]*FILTER[k][l]; // doing the dot product and summing those dot products 
                                        end 
                                end
                            R_OUT[row-2][col-2] = R_temp;  // the sum of dot products of convolution will be assigned to this pixel
                        end
                end
            end
    end  
    
    
    always_ff@(posedge clk)
    begin
        if(reset) 
            begin
                for(int m = 0; m < IMG_SIZE; m++)
                    begin
                        for(int n = 0; n < IMG_SIZE; n++)
                            begin
                                G_OUT[m][n] = 0;
                            end
                    end 
            end
            
        else
            begin
                if(row>=2 && row<=IMG_SIZE-1) // we have to wait until there are 3 rows and 3 cols because the filter is of size of 3x3
                begin
                    if(col>=2 && col<=IMG_SIZE-1)
                        begin
                            G_temp = 0;                        
                            for(int k=0;k<3;k++)
                                begin
                                    for(int l=0;l<3;l++)
                                        begin
                                            G_temp =  G_temp + G_IN[row-2+k][col-2+l]*FILTER[k][l]; // doing the dot product and summing those dot products 
                                        end 
                                end
                            G_OUT[row-2][col-2] = G_temp;  // the sum of dot products of convolution will be assigned to this pixel
                        end
                end
            end
    end    
    
    always_ff@(posedge clk)
    begin
        if(reset) 
            begin
                for(int m = 0; m < IMG_SIZE; m++)
                    begin
                        for(int n = 0; n < IMG_SIZE; n++)
                            begin
                                B_OUT[m][n] = 0;
                            end
                    end 
            end
            
        else
            begin
                if(row>=2 && row<=IMG_SIZE-1) // we have to wait until there are 3 rows and 3 cols because the filter is of size of 3x3
                begin
                    if(col>=2 && col<=IMG_SIZE-1)
                        begin
                            B_temp = 0;                        
                            for(int k=0;k<3;k++)
                                begin
                                    for(int l=0;l<3;l++)
                                        begin
                                            B_temp =  B_temp + B_IN[row-2+k][col-2+l]*FILTER[k][l]; // doing the dot product and summing those dot products 
                                        end 
                                end
                            B_OUT[row-2][col-2] = B_temp;  // the sum of dot products of convolution will be assigned to this pixel
                        end
                end
            end
    end  
    
    always_ff@(posedge clk)
        begin
        
        if(reset)
            begin
                for(int m = 0; m < IMG_SIZE-2; m++)
                    begin
                        for(int n = 0; n < IMG_SIZE-2; n++)
                            begin
                                OUT[m][n] = 0;
                            end
                    end 
            end
            
        else 
            begin
                if(counter == IMG_SIZE*IMG_SIZE)
                    begin
                        OUT[IMG_SIZE-3][IMG_SIZE-3] = R_OUT[IMG_SIZE-3][IMG_SIZE-3] + G_OUT[IMG_SIZE-3][IMG_SIZE-3] + B_OUT[IMG_SIZE-3][IMG_SIZE-3]; // loading the last pixel
                    end
                    
                else
                    begin
                        if(row>=2 && row<=IMG_SIZE-1)
                            begin
                                if(col>=3 && col<=IMG_SIZE-1)
                                    begin
                                        OUT[row-2][col-3] = R_OUT[row-2][col-3] + G_OUT[row-2][col-3] + B_OUT[row-2][col-3]; // it will be adding the elements of convolutions of all rgb
                                    end
                            end        
                    end
            end
        
        end
        
endmodule 

