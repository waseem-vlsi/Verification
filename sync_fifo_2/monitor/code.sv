class monitor;
  sync_fifo_transaction tr;
  mailbox #(sync_fifo_transaction) msmbx;
  virtual sync_FIFO vif;

  function new(mailbox #(sync_fifo_transaction) msmbx, virtual sync_FIFO vif);
    tr = new();
    this.msmbx = msmbx;
    this.vif = vif;
  endfunction

  task run();
    forever begin 
   tr.din      = vif.din;
tr.wrenable = vif.wrenable;
tr.rdenable = vif.rdenable;
tr.dout     = vif.dout;
tr.full     = vif.full;
tr.empty    = vif.empty;
      msmbx.put(tr.copy());
      tr.display("MON");
    end 
  endtask

endclass
