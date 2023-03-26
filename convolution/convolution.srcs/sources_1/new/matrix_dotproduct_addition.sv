`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.02.2023 03:11:53
// Design Name: 
// Module Name: matrix_dotproduct_addition
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


module matrix_dotproduct_addition #(parameter int IMG_SIZE = 8)(input clk, input reset, input integer row, input integer col, input integer COLOR_IN[IMG_SIZE-1:0][IMG_SIZE-1:0], input integer FILTER[2:0][2:0], output integer COLOR_OUT[IMG_SIZE-3:0][IMG_SIZE-3:0]);
    
    integer COLOR_temp;
    always_ff@(posedge clk)
    begin
        if(reset) 
            begin
                for(int m = 0; m < IMG_SIZE; m++)
                    begin
                        for(int n = 0; n < IMG_SIZE; n++)
                            begin
                                COLOR_OUT[m][n] = 0;
                            end
                    end 
            end
            
        else
            begin
                if(row>=2 && row<=IMG_SIZE-1) // we have to wait until there are 3 rows and 3 cols because the filter is of size of 3x3
                begin
                    if(col>=2 && col<=IMG_SIZE-1)
                        begin
                            COLOR_temp = 0;                        
                            for(int k=0;k<3;k++)
                                begin
                                    for(int l=0;l<3;l++)
                                        begin
                                            COLOR_temp =  COLOR_temp + COLOR_IN[row-2+k][col-2+l]*FILTER[k][l]; // doing the dot product and summing those dot products 
                                        end 
                                end
                            COLOR_OUT[row-2][col-2] = COLOR_temp;  // the sum of dot products of convolution will be assigned to this pixel
                        end
                end
            end
    end 
     
endmodule
