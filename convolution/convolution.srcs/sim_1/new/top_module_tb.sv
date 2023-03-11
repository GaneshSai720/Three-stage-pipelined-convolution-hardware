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


module top_module_tb;
    parameter IMG_SIZE = 512;
    logic clk,reset;
    integer in[2:0]; // serial input which has rgb components of each pixel
    integer FILTER[2:0][2:0]; // filter
    integer R_OUT[IMG_SIZE-3:0][IMG_SIZE-3:0];
    integer G_OUT[IMG_SIZE-3:0][IMG_SIZE-3:0];
    integer B_OUT[IMG_SIZE-3:0][IMG_SIZE-3:0];
    integer OUT[IMG_SIZE-3:0][IMG_SIZE-3:0]; // mentioning the OUT as signed because it can consist negative values after convolution with filter
    
    integer mem[IMG_SIZE-1:0][IMG_SIZE-1:0][2:0]; // memory where the input image will be loaded
    integer f,f_r,f_g,f_b; // used when loading the output into text file
    
    top_module top_module_tb(.clk(clk),.reset(reset),.in(in),.FILTER(FILTER),.OUT(OUT),.R_OUT(R_OUT),.G_OUT(G_OUT),.B_OUT(B_OUT));
   
    initial begin
    $readmemh("img_1.txt", mem); // loading the input image text file into mem 
    end
    
//    initial begin
//        for(int d =0;d<5;d++)
//            begin
//                for(int e=0;e<3;e++)
//                    begin
//                        $display("[%d %d %d] - row[%d]", mem[d][e][0], mem[d][e][1], mem[d][e][2], d);
//                    end
//            end
//    end 
    
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

    
//    initial begin
//        #2621600;   
//        $display("%s","output: ");
//        for(int i=0; i<IMG_SIZE-2; i++) begin
//          for(int j=0; j<IMG_SIZE-2; j++) begin
//            $display("%d ", OUT[i][j]); // checking the output is generated or not
//          end
//        end
//        end  


    initial begin
    #2621600;  // loading the data after this much delay. Meanwhile, the ouptut of the convolution will be completely generated
    f = $fopen("pixels.txt", "w"); // opening the file for writing
    
    for(int i=0; i<IMG_SIZE-2; i++) begin
      for(int j=0; j<IMG_SIZE-2; j++) begin
        $fdisplay(f, "%d", OUT[i][j]); 
      end
      $fdisplay(f, "");
    end
    $fclose(f); // closing after writing 
    end

    initial begin
    #2621600;  // loading the data after this much delay. Meanwhile, the ouptut of the convolution will be completely generated
    f_r = $fopen("red_pixels.txt", "w"); // opening the file for writing
    
    for(int i=0; i<IMG_SIZE-2; i++) begin
      for(int j=0; j<IMG_SIZE-2; j++) begin
        $fdisplay(f_r, "%d", R_OUT[i][j]); 
      end
      $fdisplay(f_r, "");
    end
    $fclose(f_r); // closing after writing 
    end  

    initial begin
    #2621600;  // loading the data after this much delay. Meanwhile, the ouptut of the convolution will be completely generated
    f_g = $fopen("green_pixels.txt", "w"); // opening the file for writing
    
    for(int i=0; i<IMG_SIZE-2; i++) begin
      for(int j=0; j<IMG_SIZE-2; j++) begin
        $fdisplay(f_g, "%d", G_OUT[i][j]); 
      end
      $fdisplay(f_g, "");
    end
    $fclose(f_g); // closing after writing 
    end  
    
    initial begin
    #2621600;  // loading the data after this much delay. Meanwhile, the ouptut of the convolution will be completely generated
    f_b = $fopen("blue_pixels.txt", "w"); // opening the file for writing
    
    for(int i=0; i<IMG_SIZE-2; i++) begin
      for(int j=0; j<IMG_SIZE-2; j++) begin
        $fdisplay(f_b, "%d", B_OUT[i][j]); 
      end
      $fdisplay(f_b, "");
    end
    $fclose(f_b); // closing after writing 
    end      
        
    initial begin
    #2621700 $finish;
    end
      
    endmodule
