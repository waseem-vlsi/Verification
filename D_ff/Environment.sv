class generator;

  transaction tr;

  mailbox #(transaction) mbx;
  mailbox #(transaction) mbxref;

  event gen_drv_done;
  event scorenxt;
  int count;

  
  function new( mailbox #(transaction) mbx, mailbox #(transaction) mbxref) 

    this.mbx = mbx;
    this.mbxref = mbxref;
    tr = new();

  endfunction

  task run();
    repeat(count) begin 

      assert(tr.randomize()) else begin 
        $display("Randomization failed !!!");
      end 

      mbx.put(tr.copy);
      mbxref.put(tr.copy);
      tr.display("Gen");
      @(scorenxt);

    end 
    -> gen_drv_done;


  endtask

endclass 



class driver;

transaction tr;
mailbox #(transaction) mbx;
virtual dff_if vif;

  function new(mailbox #(transaction) mbx);

this.mbx = mbx;
    
  endfunction


  task reset();

vif.reset <= 1'b1;
    repeat(5) @(posedge vif.clk);

vif.reset <= 1'b0;
    @(posedge vif.clk);
    $display("[DRV] : reset done!!!");
  endtask

  task run();
forever begin 
  mbx.get(tr);
  vif.din <= vif.dout;
  @(posedge vif.clk);
  tr.display();
  vif.din <= 1'b0;
  @(posedge vif.clk);
end 

  endtask






endclass
