interface sync_FIFO;
  logic clock;
  logic reset;
  logic wrenable;
  logic rdenable;
  logic [7:0] din;
  logic [7:0] dout;
  logic full;
  logic empty;
endinterface
