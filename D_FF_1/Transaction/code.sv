class dff_transaction;
  rand  logic  din;
        logic dout;

  constraint c_din{
    din dist {0:=30, 1:= 80};
  }

  function dff_transaction copy();
    
    copy = new();
    copy.din = this.din;
    copy.dout = this.dout;

  endfunction 

  function void display(input string tag);
    $display("[%0s] : din = %0b, dout = %0b", tag,din,dout);
  endfunction 
  


endclass
