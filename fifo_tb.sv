 // Code your testbench here
// or browse Examples
`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps
`include "fifo_design.sv"
`include "helper_file.sv"

module fifo_tb;
  logic rst_n_i;
  logic clock_i;
  //data input interface
  logic [63:0] data_in_i;
  logic data_in_v_i;
  logic data_in_bkp_i;

  //data output interface
  logic [63:0] data_out_o;
  logic data_out_v_o;
  logic data_out_req_i;

  fifo UUT (.rst_n_i(rst_n_i),.clock_i(clock_i), .data_in_i(data_in_i),  .data_in_v_i(data_in_v_i),.data_out_o(data_out_o), .data_out_v_o(data_out_v_o), .data_out_req_i(data_out_req_i), .data_in_bkp_i(data_in_bkp_i));

  input_interface inf();
   
  assign inf.rst_n_i = rst_n_i ;
  assign inf.clock_i = clock_i;
  //data input interface
  assign inf.data_in_i = data_in_i;
  assign inf.data_in_v_i = data_in_v_i;
  assign inf.data_in_bkp_i = data_in_bkp_i;
  
  /*output_interface inf_o();
  
  assign data_out_o = inf_o.data_out_o;
  assign data_out_v_o = inf.data_out_v_o;
  assign data_out_req_i = inf.data_out_req_i;
  */
  //dont forget to fork ...

  always
  begin
    #5 clock_i= 1;
    #5 clock_i= 0;
  end

  
  initial 
    begin
        static Test test = new ();
        test.env.data_in_agent.data_in_driver.vif = inf;
        fork
            test.run();
        join_none
        #1us; $finish;
    end
    
  initial
    begin
        rst_n_i = 0;
        #10ns rst_n_i = 1;
     /* $dumpfile("dump.vcd");
      $dumpvars;
      data_in_v_i = 0;

      data_out_req_i = 0;
      rst_n_i = 0; 
      #10ns
      
      data_in_v_i = 0;
      rst_n_i = 1;
      #100ns;
      
      data_in_v_i = 1;
      data_in_i= 64'hFFFF;
      
      #10ns;
      
      data_out_req_i = 1;
      data_in_i= 64'hBBBB;

      #10ns;
      data_in_i = 64'hCCCC;
      
      #10ns; 
      
      data_in_i = 64'hDDDD;

      #10ns;
       
      data_in_i = 64'hEEEE;

      #10ns;

     
      data_in_i = 64'h5555;

      #10ns;

      data_in_i = 64'h1111;
      
      #10ns;

      data_in_i = 'h22222222222222;

      #10ns;
      data_in_i = 64'h3333;
      
      #10ns;
      
      data_in_i = 64'h4444;

      #10ns;
      data_out_req_i = 0;
     $display("test end");
      #1000 $finish;
*/
    end
  endmodule
