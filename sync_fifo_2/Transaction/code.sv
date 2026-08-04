class sync_fifo_transaction;
  rand logic [7:0]din;
  rand logic wrenable;
  rand logic rdenable;
  logic [7:0] dout;
  logic full;
  logic empty;


constraint const_din {
    din dist {
        8'd1  := 40,
        8'd2  := 70,
        8'd3  := 25,
        8'd4  := 54,
        8'd5  := 87,
        8'd6  := 56,
        8'd25 := 29
    };
}

  function  sync_fifo_transaction copy();
    copy = new();
copy.din = this.din;
copy.dout = this.dout;
copy.wrenable = this.wrenable;
copy.rdenable = this.rdenable;
copy.full = this.full;
copy.empty = this.empty;
    return copy;
  endfunction

  function void display(input string tag);
    $display("[%0s] : din: %0d, rdenable: %0d, wrenable:%0d, dout:%0d", tag, din,rdenable,wrenable,dout);
  endfunction

endclass
