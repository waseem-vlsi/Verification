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

 transaction tr;
  mailbox #(transaction) dgmbx;
  virtual sync_FIFO_if.drv vif;

  function new (mailbox #(transaction) dgmbx, virtual sync_FIFO_if.drv vif);
    this.dgmbx = dgmbx;
    this.vif = vif;
    tr = new();
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
    tr.display("DRV");
    @(negedge vif.clock);
    if(tr.wr) begin

      vif.wr  <= 1'b1;
      vif.rd  <= 1'b0;
      vif.din <= tr.din;

    end

    else if(tr.rd) begin

      vif.wr <= 1'b0;
      vif.rd <= 1'b1;
      vif.din <= 5'd0;

    end

    else begin
   $display("Invalid transaction");
end

    @(posedge vif.clock);

    // clear signals
    vif.wr  <= 1'b0;
    vif.rd  <= 1'b0;
    vif.din <= 5'd0;

  end

endtask

endclass 
