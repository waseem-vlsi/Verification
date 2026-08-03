class generator;
  dff_transaction tr;
  mailbox #(dff_transaction) mbxgd;
  mailbox #(dff_transaction) mbxgs;
  integer count;
  function new(mailbox #(dff_transaction) mbxgd, mailbox #(dff_transaction) mbxgs);
    tr = new();
    this.mbxgd = mbxgd;
    this.mbxgs = mbxgs;
  endfunction

  task run();
    repeat(count) begin 
      assert(tr.randomize()) else begin 
        $display("Randomization failed!!!");
      end 
      tr.display("Gen");
      mbxgd.put(tr.copy());
      mbxgs.put(tr.copy());
    end 
  endtask
endclass
