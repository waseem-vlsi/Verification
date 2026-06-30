class transaction;

  rand logic [4:0] din;
  rand logic wr,rd;
  logic [4:0] dout;
  logic full,empty;


  function transaction copy();
    copy = new();
    copy.din = this.din ;
    copy.wr = this.wr;
    copy.rd = this.rd;
    copy.dout = this.dout;
    copy.full = this.full;
    copy.empty = this.empty;
  endfunction

  function void display(input string tag);
    $display("[%0s] : din=%0d wr=%0b rd=%0b dout=%0d full=%0b empty=%0b",
          tag,din,wr,rd,dout,full,empty);

  endfunction
endclass
