# Five-stage-pipelined-convolution-hardware
This branch consists of Five stage pipelined convolution verilog code

Pipeline Stages:
1. Serially taking the data into the input channels matrices. (R_IN, G_IN, B_IN)
2. Calculating the dotproducts between the pixels of input channel matrices and kernel matrix.
3. Adding the dotproducts by equating them to the repsective pixel of the three intermediate output channels. (R_OUT, G_OUT, B_OUT)
4. Adding each channel outputs and equating them to the final output matix. (OUT = R_OUT + G_OUT + B_OUT)    
5. Normalizing the output matrix pixels wwhich would be a grayscale image(OUT). 
