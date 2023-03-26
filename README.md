# Three-stage-pipelined-convolution-hardware
This branch consists of three stage pipelined convolution verilog code.

Three Pipeline Stages:
1. Serially taking the data into the input image matrix.
2. Calculating the convolution of each pixel of 3 different channels by adding the respective dotproducts which would be happening between the image matrix and the kernel.
3. Adding the each calculated pixels of 3 channels(RGB) and equating them to the respective pixel in the output(Grayscale image).  
