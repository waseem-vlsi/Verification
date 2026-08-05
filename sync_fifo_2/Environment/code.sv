class environment ;
    generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;

  mailbox #(sync_fifo_transaction) mbxgd;
  mailbox #(sync_fifo_transaction) mbxgs;
  mailbox #(sync_fifo_transaction) mbxms;
  virtual sync_FIFO vif;

  function new(virtual sync_FIFO vif);
    mbxgd = new();
    mbxgs = new();
    gen = new(mbxgd,mbxgs);
    drv = new(mbxgd,vif);

    mbxms = new();
    mon = new(mbxms,vif);
    sco = new(mbxms,mbxgs);


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

  // task post_test();
  //   wait(gen.done.triggered);
  // endtask

  task run();
    pre_test();
    test();
    // post_test();
  endtask
  

endclass 
