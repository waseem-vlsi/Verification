class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;

  mailbox #(transaction) gdmbx;
  mailbox #(transaction) gsmbx;
  mailbox #(transaction) msmbx;

  virtual dff_if vif;

  event sconext;
  event done;

  function new(virtual dff_if vif);
    gdmbx = new();
    gsmbx = new();
    gen = new(gdmbx, gsmbx);
    drv = new(gdmbx)l
    msmbx = new();
    mon = new(msmbx);
    sco = new(gsmbx,msmbx);

    this.vif = vif;
    drv.vif = this.vif;
    mon.vif = this.vif;

    gen.sconext = next;
    sco.sconext = next;

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
    join
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
