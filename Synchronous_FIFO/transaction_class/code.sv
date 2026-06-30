class transaction;

  rand logic [4:0] din;
  logic wr,rd;
  logic [4:0] dout;
  logic full,empty;


  function transaction copy();
    copy = new();
    this.din = din;
  endfunction

  function void display(input string);
    $display("[%0s] : din = %0d", string,din);

  endfunction
endclass
