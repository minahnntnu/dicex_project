`timescale 1 ns / 1 ps

module pixelState(
    input logic  clk,
    input  logic reset,
    output logic erase, 
    output logic expose,
    output logic read1,
    output logic read2,
    output logic read3,
    output logic read4,
    output logic convert
    
);


//-------------------------------------------------------------
//GrayCounter
//-------------------------------------------------------------
   logic[7:0]  gray_counter;
   logic enable_counter;
   logic [7 : 0]  q;
   logic reset_c = 0;
   always @(posedge clk or posedge reset_c) begin
      if (reset_c)
        q <= 0;
      else if (enable_counter) begin
        q <= q + 1; 
      end
      gray_counter <= {q[7], q[7:1] ^ q[6:0]};
   end


//------------------------------------------------------------
// State Machine
//------------------------------------------------------------
   parameter ERASE=0, EXPOSE=1, CONVERT=2, READ1=3, READ2=4, READ3=5, READ4=6, IDLE=7;

   logic               convert_stop;
   logic [2:0]         state,next_state;   //States

//State duration in clock cycles
   parameter integer c_erase = 5;
   parameter integer c_expose = 255;
   parameter integer c_convert = 255;
   parameter integer c_read = 10;

// Control the output signals
   always_ff @(negedge clk ) begin
      case(state)
        ERASE: begin
           erase <= 1;
           read1 <= 0;
           read2 <= 0;
           read3 <= 0;
           read4 <= 0;
           expose <= 0;
           convert <= 0;
        end
        EXPOSE: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           read3 <= 0;
           read4 <= 0;
           expose <= 1;
           convert <= 0;
        end
        CONVERT: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           read3 <= 0;
           read4 <= 0;
           expose <= 0;
           convert = 1;
        end
        READ1: begin
           erase <= 0;
           read1 <= 1;
           read2 <= 0;
           read3 <= 0;
           read4 <= 0;
           expose <= 0;
           convert <= 0;
        end
        READ2: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 1;
           read3 <= 0;
           read4 <= 0;           
           expose <= 0;
           convert <= 0;
        end      
        READ3: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           read3 <= 1;
           read4 <= 0;
           expose <= 0;
           convert <= 0;
        end
        READ4: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           read3 <= 0;
           read4 <= 1;
           expose <= 0;
           convert <= 0;
        end                  
        IDLE: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           read3 <= 0;
           read4 <= 0;
           expose <= 0;
           convert <= 0;

        end
      endcase // case (state)
   end // always @ (state)

   // Control the state transitions
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         state = IDLE;
         next_state = ERASE;
         reset_c  = 1;
      end
      else begin
         case (state)
           ERASE: begin
              if(gray_counter == c_erase) begin
                 next_state <= EXPOSE;
                 state <= IDLE;
              end
           end
           EXPOSE: begin
              if(gray_counter == c_expose) begin
                 next_state <= CONVERT;
                 state <= IDLE;
              end
           end
           CONVERT: begin
              if(gray_counter == c_convert) begin
                 next_state <= READ1;
                 state <= IDLE;
              end
           end
           READ1:
             if(gray_counter == c_read) begin
                state <= IDLE;
                next_state <= READ2;
             end
           READ2:
             if(gray_counter == c_read) begin
                state <= IDLE;
                next_state <= READ3;
             end
           READ3:
             if(gray_counter == c_read) begin
                state <= IDLE;
                next_state <= READ4;
             end
           READ4:
             if(gray_counter == c_read) begin
                state <= IDLE;
                next_state <= ERASE;
             end
           IDLE:
             state <= next_state;
         endcase // case (state)
         if(state == IDLE)
           reset_c=1;
         else
           reset_c = 0;
           enable_counter =1;
      end
   end // always @ (posedge clk or posedge reset)

endmodule