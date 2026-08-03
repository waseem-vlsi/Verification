class scoreboard;
  dff_transaction tr;
  dff_transaction trref;
  mailbox #(dff_transaction) mbxgs;
  mailbox #(dff_transaction) mbxms;

  function new (mailbox #(dff_transaction)mbxms, mailbox #(dff_transaction)mbxgs);
    this.mbxgs = mbxgs;
    this.mbxms = mbxms;
  endfunction

  task run(); 
  forever   begin
    mbxms.get(tr);
    mbxgs.get(trref);
    tr.display("SCO");
    trref.display("REF");

    if(tr.dout == trref.dout) 
      $display("Data Mateched!!!");
    else 
      $display("Data Mismateched!!!");
    end
  endtask

endclass
