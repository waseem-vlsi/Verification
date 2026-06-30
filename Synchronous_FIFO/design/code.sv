module sync_FIFO(
  input logic clock, 
  input logic reset,
  input logic wr,
  input logic rd,
  input logic [4:0] din,
  output logic [4:0] dout,
  output logic full,
  output logic empty
);

  logic [3:0] wptr,rptr;
  logic [4:0]cnt;
  logic [4:0]mem[15:0];

  always_ff@(posedge clock) begin 
    if(reset) begin 
      wptr <= 4'd0;
      rptr <= 4'd0;
      dout <= 5'd0;
      cnt <= 5'd0;
    end 
    else begin
    if(wr && !full) begin 
      mem[wptr] <= din;
      wptr <= wptr + 1;
    
    end 

     if(rd && !empty) begin 
      dout <= mem[rptr];
      rptr <= rptr + 1;


    end 

    case({wr && !full, rd && !empty})

    2'b10 : cnt <= cnt + 1;
    2'b01: cnt <= cnt - 1;
    default : cnt <= cnt;
   


  endcase 
 end
  end 

  assign full = (cnt == 5'd16) ? 1'b1 : 1'b0;
  assign empty = (cnt == 5'd0) ? 1'b1 : 1'b0;


endmodule
