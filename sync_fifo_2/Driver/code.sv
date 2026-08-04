class driver ;

  sync_fifo_transaction tr;
  mailbox #(sync_fifo_transaction) gdmbx;
  virtual sync_FIFO vif;

  function new(mailbox #(sync_fifo_transaction) gdmbx,virtual sync_FIFO vif);
     this.gdmbx = gdmbx;
     this.vif = vif;
  endfunction

  task reset();
    vif.reset <= 1'd1;
    @(posedge vif.clock);
    vif.reset <= 1'd0;
    @(posedge vif.clock);
    $display("Reset done");
  endtask

  task run();
    forever begin 
      gdmbx.get(tr);
      vif.din <= tr.din;
      vif.wrenable <= tr.wrenable;
      vif.rdenable <= tr.rdenable;
      tr.display("DRV");
      repeat(5)@(posedge vif.clock);
      vif.din <= 8'd0;
      vif.wrenable <= 1'd0;
      vif.rdenable <= 1'd0;
      @(posedge vif.clock);
          end 
  endtask
endclass 
