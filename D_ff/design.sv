interface dff_if;

logic clock;
logic reset;
logic d_in;
logic d_out;
  
endinterface


module dff(dff_if df);

  always_ff@(posedge df.clock) begin 

    if(df.reset) begin 

      df.d_out <= 1'd0;

    end 

    else begin 

df.d_out <= df.d_in;
      
    end 


  end 


endmodule
