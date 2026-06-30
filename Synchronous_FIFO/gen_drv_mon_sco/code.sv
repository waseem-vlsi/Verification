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
