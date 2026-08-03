class monitor;
  dff_transaction tr;
  mailbox #(dff_transaction) mbxms;
  virtual dff_if vif;

  function new (mailbox #(dff_transaction) mbxms, virtual dff_if vif);
    tr = new();
    this.mbxms = mbxms;
    this.vif = vif;
    endclass

    task run();
      wait(vif.reset = 1'b0);
      forever begin 
      tr.dout = vif.dout;

        mbxms.put(tr);
        tr.display("MON");
      end
    endtask
endclass
