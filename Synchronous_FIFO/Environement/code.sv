class environment;

  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  event next;

  mailbox #(transaction) gdmbx;
  mailbox #(transaction) gsmbx;
  mailbox #(transaction) msmbx;

  virtual sync_FIFO_if vif;

  function new(virtual sync_FIFO_if vif );
    this.vif = vif;
    gdmbx = new();
    gsmbx = new();
    gen = new(gdmbx,gsmbx);
    drv = new(gdmbx,vif);
    msmbx = new();
    mon = new(msmbx,vif);
    sco = new(gsmbx,msmbx);

    
   // drv.vif = this.vif;
   // mon.vif = this.vif;
    gen.next = next;
    sco.next = next;
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
    join_none
  endtask

  task post_test();
    wait(gen.done);
    #100;
    $finish();
  endtask

  task run();
    pre_test();
    test();
    post_test();
  endtask
endclass 
