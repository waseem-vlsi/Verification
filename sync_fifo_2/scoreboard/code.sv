class scoreboard;
  sync_fifo_transaction tr;
  sync_fifo_transaction trref;

  logic [7:0] ref_fifo[$];
  logic [7:0] expected_data;
  
  mailbox #(sync_fifo_transaction) mbxms;
  mailbox #(sync_fifo_transaction) mbxgs; 

  function new (mailbox #(sync_fifo_transaction) mbxms, mailbox #(sync_fifo_transaction) mbxgs);
    this.mbxms = mbxms;
    this.mbxgs = mbxgs;
  endfunction


  task run();
    forever begin 
    mbxms.get(tr);
    mbxgs.get(trref);

      if(trref.wrenable && !trref.full) begin 
        ref_fifo.push_back(trref.din);
        $display("[SCO] : Write: Data : %0d pushed into queue", trref.din);
      end 
      
      
      if(trref.rdenable && !trref.empty) begin 
        if(ref_fifo.size() != 0) begin 
          expected_data = ref_fifo.pop_front();
          if(expected_data == tr.dout) begin 
            $display("Data Matched!!!");
          end 
          else begin 
            $display("Data Mismatched!!!");
          end 
        end 
                else begin

          $display("[SCO] ERROR : Reference FIFO Empty");

        end
      end 
    end
  endtask 

endclass
