interface sync_FIFO;
  input logic clock;
  input logic reset;
  input logic [4:0]din;
  input logic wr;
  input logic rd;
  output logic [4:0]dout;
  output logic full;
  output logic empty;


endinterface
