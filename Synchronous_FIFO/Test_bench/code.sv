module tb();
sync_FIFO_if vif();

  initial begin
    vif.clock = 0;
  end

  always #10 vif.clock = ~vif.clock;


  

  sync_FIFO DUT(
.clock(vif.clock),
    .reset(vif.reset),
    .din(vif.din),
    .dout(vif.dout),
    .full(vif.full),
    .empty(vif.empty),
    .wr(vif.wr),
    .rd(vif.rd)
  );

  environment env;

  initial begin 
    env = new(vif);
    env.gen.count = 50;
    env.run();
  end 

endmodule
