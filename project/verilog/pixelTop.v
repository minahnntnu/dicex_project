module pixelTop(
    input logic  clk,
    input logic reset

);
   //digital signals
   logic              erase;
   logic              expose;
   logic              read1;
   logic              read2;
   logic              read3;
   logic              read4;

   //ANALOG SIGNALS
   logic              anaBias1;
   logic              anaRamp;
   logic              anaReset;

   assign anaReset = 1;

   logic              convert;
   tri[7:0]           pixData; //  We need this to be a wire, because we're tristating it


  //Instanciate the pixel array
   PIXEL_ARRAY  pa1(
       anaBias1, anaRamp, anaReset, erase,expose, read1, read2, read3, read4,pixData);   


   
   pixelState pa_fsm(
       clk, reset, erase, expose, read1, read2, read3, read4, convert);


     
   logic[7:0] data;
   assign anaRamp = convert ? clk : 0;
   assign anaBias1 = expose ? clk : 0;
   assign pixData = read1|read2|read3|read4 ? 8'bZ: data; //Driving the bus


      always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         data =0;
      end
      if(convert) begin
         data +=  1;
      end
      else begin
         data = 0;
      end
   end // always @ (posedge clk or reset)
   //------------------------------------------------------------
   // Readout from databus
   //------------------------------------------------------------
   logic [7:0] pixelDataOut1;
   logic [7:0] pixelDataOut2;
   logic [7:0] pixelDataOut3;
   logic [7:0] pixelDataOut4;

   //DEFINE VARIABLES
   integer i ;
   integer  writefile;

   always_ff @(posedge clk or posedge reset) begin
      writefile=$fopen("write_file.txt","w");

      if(reset) begin
         pixelDataOut1 = 0;
         pixelDataOut2 = 0;
         pixelDataOut3 = 0;
         pixelDataOut4 = 0;
      end
      else begin
         if(read1)
           pixelDataOut1 <= pixData;
           $fwrite(writefile, "From pixel 1: ");
           for (i=7; i>=0; i=i-1) begin      
              //Reading from the most significant bit to the least significant bit and writing it to a text file to save the data     
              $fwrite(writefile, "%d", pixelDataOut1[i]);   
           end
           $fwrite(writefile, "\n");                        //New line between pixel readings

         if(read2)
           pixelDataOut2 <= pixData;  
           $fwrite(writefile,"From pixel 2: ");
           for (i=7; i>=0; i=i-1) begin
              $fwrite(writefile, "%d", pixelDataOut2[i]);
           end
           $fwrite(writefile, "\n");   

         if(read3)
           pixelDataOut3 <= pixData; 
           $fwrite(writefile, "From pixel 3: ");  
           for (i=7; i>=0; i=i-1) begin
              $fwrite(writefile, "%d", pixelDataOut3[i]);
           end
           $fwrite(writefile, "\n");   

         if(read4)
           pixelDataOut4 <= pixData; 
           $fwrite(writefile, "From pixel 4: ");
           for (i=7; i>=0; i=i-1) begin
              $fwrite(writefile, "%d", pixelDataOut4[i]);
           end  
           $fwrite(writefile, "\n");   

      end
      $fclose(writefile);                                   //Closing the file after all pixels are read


   end

endmodule