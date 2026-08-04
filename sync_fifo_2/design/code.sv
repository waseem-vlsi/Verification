module sync_fifo(
    input logic clock,
  input logic reset,
  input logic wrenable,
  input logic rdenable,
  input logic [7:0]din,

  output logic [7:0]dout,
  output logic full,
  output logic empty  
);
  logic [2:0] rdptr,wrptr;
  logic [3:0] count;
  logic [7:0] mem [7:0] ;
  always@(posedge clock) begin 
    if(reset) begin 
      wrptr <= 3'd0;
      rdptr <= 3'd0;
      dout <= 8'd0;
      count <= 4'd0;
    end 

    else if(wrenable && !full) begin 
      mem[wrptr] <= din;
      wrptr <= wrptr + 1;
      count <= count + 1;
    end 

    else if(rdenable && !empty) begin 
      dout <= mem[rdptr];
      rdptr <= rdptr + 1;
      count <= count - 1;
      end 
    
  end



  
  assign full = (count == 4'd8) ? (1'b1) : (1'b0);
  assign empty = (count == 4'd0) ? (1'b1) : (1'b0);


endmodule
