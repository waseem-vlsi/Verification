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

endclass
