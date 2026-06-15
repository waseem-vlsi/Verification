class generator;

  transaction tr;

  mailbox #(transaction) mbx;
  mailbox #(transaction) mbxref;

  event gen_drv_done;
  event scorenxt;
  int count;

  function new( mailbox #(transaction) mbx, mailbox #(transaction) mbxref) 

    this.mbx = mbx;
    this.mbxref = mbxref;
    tr = new();

  endfunction

  task run();
    repeat(count) begin 

      assert(tr.randomize()) else begin 
        $display("Randomization failed !!!");
      end 

      mbx.put(tr.copy);
      mbxref.put(tr.copy);
      tr.display("Gen");
      @(scorenxt);

    end 
    -> gen_drv_done;


  endtask

endclass 
