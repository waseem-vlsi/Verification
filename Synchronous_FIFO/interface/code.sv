interface sync_FIFO_if;

   logic clock;
   logic reset;
   logic [4:0] din;
   logic wr;
   logic rd;
   logic [4:0] dout;
   logic full;
   logic empty;

   modport drv(
      input clock,

      output reset,
      output din,
      output wr,
      output rd,

  
      input full,
      input empty
   );

   modport mon(
      input clock,
      input reset,
      input din,
      input dout,
      input wr,
      input rd,
      input full,
      input empty
   );

   modport dut(
      input clock,
      input reset,
      input din,
      input wr,
      input rd,

      output dout,
      output full,
      output empty
   );

endinterface
