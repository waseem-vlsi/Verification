class generator;
  
  transaction tr;
  mailbox #(transaction) gdmbx;
  mailbox #(transaction) gsmbx;
  int count = 0;

  function new(mailbox #(transaction) gdmbx, mailbox #(transaction) gsmbx);
    this.gdmbx = gdmbx;
    this.gsmbx = gsmbx;
    tr = new();
  endfunction


  task run();
    repeat(count) begin 
      assert(tr.randomize()) else begin 
        $display("Randomization is failed!!!");
        $finish;
      end 
      gdmbx.put(tr.copy());
      gsmbx.put(tr.copy());
      
      $display("[Gen] : din = %0d",tr.din)
    end 
  endtask
endclass




class driver ;

  generator gr;
  mailbox #(transaction) dgmbx;
  virtual dif_if vif;

  function new (mailbox #(transaction) dgmbx);
    this.dgmbx = dgmbx;
    gr = new();
  endfunction

  task reset();
    vif.reset <= 1'b1;
    repeat(5)@posedge vif.clock;
    vif.reset <= 1'b0;
    @posedge vif.clock;
  endtask

  task run();
    forever begin 
      dgmbx.get(tr);
      if(vif.wr) begin 
        vif.wr <= 1'b1;
        vif.rd <= 1'b0;
        vif.din <= tr.din;
      end 
      else if(vif.rd) begin 
        vif.wr <= 1'b0;
        vif.rd <= 1'b1;
      end 
      

    end 
    

  endtask




endclass 
