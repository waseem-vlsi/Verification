class generator;
  
  transaction tr;
  mailbox #(transaction) gdmbx;
  mailbox #(transaction) gsmbx;
  int count = 0;
  event next;
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
      @(next);
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



class monitor;
  transaction tr;
  mailbox #(transaction) msmbx;
  virtual sync_FIFO_if.mon vif;

  function new(mailbox #(transaction) msmbx, virtual sync_FIFO_if.mon vif);
    this.msmbx = msmbx;
    this.vif = vif;
 
  endfunction

  task run();
    forever begin 
      @(posedge vif.clock);
      #1;
      if(vif.wr || vif.rd) begin
         tr = new();
      tr.dout = vif.dout;
      tr.full = vif.full;
      tr.empty = vif.empty;
      tr.wr = vif.wr;
      tr.rd = vif.rd;
      tr.din = vif.din;
        $display("MON");
      msmbx.put(tr);
    end 
    end 
  endtask
endclass 


class scoreboard;

  transaction tr;
  transaction trref;

  mailbox #(transaction) gsmbx;
  mailbox #(transaction) msmbx;

  logic [4:0] queue_for_fifo[$];
  logic [4:0] temp;
  event next;

  function new(mailbox #(transaction) gsmbx,
               mailbox #(transaction) msmbx);

    this.gsmbx = gsmbx;
    this.msmbx = msmbx;
    tr = new();
    trref = new();

  endfunction


  task run();

    forever begin

      gsmbx.get(trref);
      msmbx.get(tr);

      // write operation
      if(trref.wr) begin

        queue_for_fifo.push_back(trref.din);

        $display("[SCO] PASS : stored din = %0d",
                  trref.din);

      end


      // read operation
      else if(trref.rd) begin

        if(queue_for_fifo.size() > 0) begin

          temp = queue_for_fifo.pop_front();

          if(temp == tr.dout)

            $display("[SCO] PASS : Expected=%0d Actual=%0d",
                     temp,tr.dout);

          else

            $display("[SCO] FAIL : Expected=%0d Actual=%0d",
                     temp,tr.dout);

        end

        else

          $display("[SCO] ERROR : Queue empty");

      end
        ->next;
    end

  endtask

endclass
