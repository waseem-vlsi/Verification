class generator;

generator gr;
  mailbox #(transaction) mbx;
  mailbiox #(transaction) mbxref;

  function new (mailbox #(transaction) mbx, mailbox #(transaction) mbxref) 
        this.mbx = mbx;
        this.mbxref = mbxref;
    tr = new();    
    endfunction

  task run();
    repeat(count) begin 
      assert(tr.randomize) else begin 
        $display("Randomization failed!!!");
      end
    end 

    mbx.put(tr.copy);
    mbxref.put(tr.copy);

    tr.display("GEN");
  endtask



endclass
