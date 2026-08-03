class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;

  mailbox #(dff_transaction) mbxgd;
  mailbox #(dff_transaction) mbxgs;
  mailbox #(dff_transaction) mbxms;
  virtual dff_if vif;

  function new (virtual dff_if vif);
    mbxgd = new();
    mbxgs = new();
    gen = new(mbxgd,mbxgs);
    drv = new(mbxgd);

    mbxms = new();
    mon = new(mbxms);
    sco = new(mbxms,mbxgs);

    this.vif = vif;
    drv.vif = this.vif;
    mon.vif = this.vif;
  endfunction

  task pre_test();
    drv.reset();
  endtask

  task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
    join_any
  endtask

  task post_test();
    wait(gen.done.triggered);
  endtask

  task run();
    pre_test();
    test();
    post_test();  
  endtask
  
endclass
