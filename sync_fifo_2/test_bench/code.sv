module tb;
  sync_FIFO vif();
  sync_FIFO dut (vif);

    environment env;
  initial begin 
    vif.clock <= 1'd0;
  end 
  always #5 vif.clock = ~(vif.clock);


  initial begin 
    env = new(vif);
    env.run();
  end 

  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars;
  end 
endmodule
