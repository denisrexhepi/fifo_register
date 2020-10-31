interface input_interface();
  logic rst_n_i;
  logic clock_i;
  //data input interface
  logic [63:0] data_in_i;
  logic data_in_v_i;
  logic data_in_bkp_i;
endinterface

interface output_interface();
  logic [63:0] data_out_o;
  logic data_out_v_o;
  logic data_out_req_i;
endinterface 


class data_in_trans;
    rand bit [63:0] data;
endclass

class Data_In_Driver;
    virtual input_interface vif;
    virtual task sendTrans(data_in_trans trans);
        $display("sendTrans is running");
        wait(vif.data_in_bkp_i == 0);
        @(posedge vif.clock_i);
        $display("Sending Data in Progess [%0t]: %h", $time, trans.data);
        vif.data_in_v_i = 1;
        vif.data_in_i = trans.data;
        @(posedge vif.clock_i);
        vif.data_in_v_i = 0;
        $display("Data sent successfully!");
    endtask
endclass


class Data_In_Agent;
    Data_In_Driver data_in_driver = new();
endclass


class VerificationEnvironment;
    Data_In_Agent data_in_agent = new();
endclass

class Test;
    VerificationEnvironment env = new ();
    virtual task run;
        data_in_trans trans = new();
        $display("task is running");
        trans.randomize();
        #100ns;
        env.data_in_agent.data_in_driver.sendTrans(trans);
    endtask
endclass

class data_in_monitor;
    sendTrans trans;
    virtual input_interface vif;
    virtual task monitor_transaction(sendTrans trans);
        forever begin
            wait(vif.data_in_bkp_i == 0 && vif.data_in_v_i ==1);
            @(negedge vif.clock_i);
            trans = new();
            trans.data = vif.data_in_i;
            publish_data(trans);
            $display("Data in: %h", trans.data)
    endtask
    
    virtual task publish_data(sendTrans trans);
        //do nothing
    endtask 
endclass

