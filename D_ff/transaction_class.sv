class trasaction;

rand logic d_in;
     logic d_out;

  function transaction copy();

    copy = new();
    copy.d_in = this.d_in;
    copy.d_out = this.d_out;

  endfunction

  function void display(input string tag);

    $display("[%0s]: d_in = %0d and d_out : %0d", tag,d_in,d_out);

  endfunction

endclass 
