class generator;
    sync_fifo_transaction tr;

  mailbox #(sync_fifo_transaction) gdmbx;
  mailbox #(sync_fifo_transaction) gsmbx;
  int count;

  function new(mailbox #(sync_fifo_transaction) gdmbx,mailbox #(sync_fifo_transaction) gsmbx);
    tr = new();
    this.gdmbx = gdmbx;
    this.gsmbx = gsmbx;
  endfunction
   
  task run();
    repeat(count) begin 
      assert(tr.randomize()) else begin 
        $display("Randomization failed!!!");
      end

      gdmbx.put(tr.copy());
      gsmbx.put(tr.copy());

      tr.display("GEN");
    end
  endtask
endclass
