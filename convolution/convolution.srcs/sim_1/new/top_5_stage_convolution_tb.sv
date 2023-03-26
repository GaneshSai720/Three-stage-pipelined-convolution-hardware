`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.02.2023 15:55:46
// Design Name: 
// Module Name: top_module_tb
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


module top_5_stage_convolution_tb;
    parameter IMG_SIZE = 512;
    logic clk, reset;
    logic [7:0]in[2:0];
    logic signed [5:0]FILTER[2:0][2:0];
    logic signed [8:0]OUT[IMG_SIZE-3:0][IMG_SIZE-3:0];
    
    logic [7:0]mem[IMG_SIZE-1:0][IMG_SIZE-1:0][2:0]; // memory where the input image will be loaded 512*512 pixels each of them has rgb
    integer f; // used when loading the output into text file
    
    top_5_stage_convolution top_5_stage_convolution_tb(.clk(clk),.reset(reset),.in(in),.FILTER(FILTER),.OUT(OUT));
   
    initial begin
    $readmemh("img_1.txt", mem); // loading the input image text file into mem 
    end
    
    initial begin
        for(int d =0;d<5;d++)
            begin
                for(int e=0;e<3;e++)
                    begin
                        $display("[%d %d %d] - row[%d]", mem[d][e][0], mem[d][e][1], mem[d][e][2], d);
                    end
            end
    end 
    
    initial begin
        clk = 1'b0;
        reset = 1;
        #10;    
        reset = 0;
        for(int p=0;p<IMG_SIZE;p++)
            begin
                for(int q=0;q<IMG_SIZE;q++)
                    begin
                        in = mem[p][q]; // giving the input as serial manner
                        #10;
                    end
            end 
    end 
    
    always #5 clk = ~clk;
    
    initial begin
        FILTER[0][0] = 0;
        FILTER[0][1] = 1;
        FILTER[0][2] = 0;
        FILTER[1][0] = 1;
        FILTER[1][1] = -4;
        FILTER[1][2] = 1;
        FILTER[2][0] = 0;
        FILTER[2][1] = 1;
        FILTER[2][2] = 0; 
    end

    
    initial begin
        #2621600;   
        $display("%s","output: ");
        for(int i=0; i<IMG_SIZE-2; i++) begin
          for(int j=0; j<IMG_SIZE-2; j++) begin
            $display("%d ", OUT[i][j]); // checking the output is generated or not
          end
        end
        end  


    initial begin
    #2621600;  // loading the data after this much delay. Meanwhile, the ouptut of the convolution will be completely generated
    f = $fopen("pixels_out.txt", "w"); // opening the file for writing
    
    for(int i=0; i<IMG_SIZE-2; i++) begin
      for(int j=0; j<IMG_SIZE-2; j++) begin
        $fdisplay(f, "%d", OUT[i][j]); 
      end
      $fdisplay(f, "");
    end
    $fclose(f); // closing after writing 
    end    
        
    initial begin
    #2621700 $finish;
    end
      
    endmodule
