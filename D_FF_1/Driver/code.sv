class driver;
  dff_transaction tr;
  virtual dff_if vif;
    mailbox #(dff_transaction) mbxgd;

  function new(mailbox #(dff_transaction) mbxgd, virtual dff_if vif);
    this.mbxgd = mbxgd;
    this.vif = vif;
      endfunction

      task reset();
      vif.reset <= 1'b1;
        repeat(2)@(posedge vif.clock);
        vif.reset <= 1'b0;
        @(posedge vif.clock);
      endtask

      task run();
       
        forever begin 
           mbxgd.get(tr);
        vif.din <= tr.din;
           tr.display("Drv");
          @(posedge vif.clock);
           vif.din <= 1'b0;
          @(posedge vif.clock);
        end 
      endtask
endclass
