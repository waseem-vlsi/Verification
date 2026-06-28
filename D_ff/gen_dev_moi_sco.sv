class generator;

transaction tr;
  mailbox #(transaction) mbx;
  mailbox #(transaction) mbxref;

  function new (mailbox #(transaction) mbx, mailbox #(transaction) mbxref) ;
        this.mbx = mbx;
        this.mbxref = mbxref;
    tr = new();    
    endfunction
  
    int count;
  task run();
    repeat(count) begin 
      assert(tr.randomize()) else begin 
        $display("Randomization failed!!!");
      end
    

      mbx.put(tr.copy());
      mbxref.put(tr.copy());

    tr.display("GEN");
      @(sconext);
    end 
  endtask

endclass


class driver;

transaction tr;

  mailbox #(transaction) mbx;
  virtual dif_if vif;

  function new(mailbox #(transaction) mbx) ;
      this.mbx = mbx;
    tr = new();
  endfunction

  task reset();
      vif.reset <= 1'b1;
    repeat(5)@(posedge vif.clk);
      vif.reset <= 1'b0;
    @(posedge vif.clk);
    $display("Reset Done!!!");       
  endtask

  task run();
    forever begin 
      mbx.get(tr);
      vif.din <= tr.din;
      @(posedge vif.clk);
      tr.display("Drv");
      vif.din <= 1'b0;
      @(posedge vif.clk);

    end 
  endtask
endclass


class monitor ;
      transaction tr;
      virtual dif_if vif;
  mailbox #(transaction) mbx;


  function new(mailbox #(transaction) mbx) ;
       this.mbx = mbx;
    tr = new();
  endfunction
  task run();
  wait(vif.reset == 1'b0);
 
  forever begin 
     repeat(2)@(posedge vif.clk);
      tr.dout = vif.dout;
    mbx.put(tr.copy());
    tr.display("Mon");
  end 
  endtask
endclass 


class scoreboard;

    transaction tr;
    transaction trref;
  mailbox #(transaction) mbx;
  mailbox #(transaction) mbxref;
  

  function new(mailbox #(transaction) mbx, mailbox #(transaction) mbxref) ;
    this.mbx = mbx;
    this.mbxref = mbxref;
    tr = new();
    trref = new();
  endfunction
  task run();
  forever begin 
    mbx.get(tr);
    mbxref.get(trref);
    tr.display("Sco");
    trref.display("Ref");
    if(trref.din == tr.dout) begin 
      $display("Data Matched!!!");
    end 
    else begin 
      $display("Data Mismatched!!!");
    end 
    $display("----------------------------");
    ->sconext;


  end

  endtask
endclass 
