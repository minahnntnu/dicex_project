module PIXEL_ARRAY
  (
   input logic      VBN1,
   input logic      RAMP,
   input logic      RESET,
   input logic      ERASE,
   input logic      EXPOSE,
   input logic      READ1,
   input logic      READ2,
   input logic      READ3,
   input logic      READ4,
   inout [7:0]      DATA
   );

   parameter real    dv_pixel1 = 0.5; 
   parameter real    dv_pixel2 = 0.7; 
   parameter real    dv_pixel3 = 0.9; 
   parameter real    dv_pixel4 = 1; 

    PIXEL_SENSOR  #(.dv_pixel(dv_pixel1))  s1(VBN1, RAMP, RESET, ERASE,EXPOSE, READ1,DATA);
    PIXEL_SENSOR  #(.dv_pixel(dv_pixel2))  s2(VBN1, RAMP, RESET, ERASE,EXPOSE, READ2,DATA);
    PIXEL_SENSOR  #(.dv_pixel(dv_pixel3))  s3(VBN1, RAMP, RESET, ERASE,EXPOSE, READ3,DATA);
    PIXEL_SENSOR  #(.dv_pixel(dv_pixel4))  s4(VBN1, RAMP, RESET, ERASE,EXPOSE, READ4,DATA);

endmodule