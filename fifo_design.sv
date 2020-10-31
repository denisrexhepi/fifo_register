 // Code your design here

module fifo(input logic rst_n_i,
            input logic clock_i,
            //data input interface
            input logic [63:0] data_in_i,
            input logic data_in_v_i,
            output logic data_in_bkp_i,
            //data output interface
            output logic [63:0] data_out_o,
            output logic data_out_v_o,
            input logic data_out_req_i
           );

  logic[63:0] mem [0:7]; 
  logic [2:0] wr_ptr = 3'b000; //pointer to write to memory
  logic [2:0] read_ptr =  3'b000; //pointer to read from memory
  logic is_full = 0;
 
  assign data_in_bkp_i = is_full;
  
  always @(posedge clock_i, negedge rst_n_i)
    begin
      if(~rst_n_i)
        begin
          wr_ptr = 0;
          read_ptr = 0;
          data_out_o = 0; 
          is_full = 0;
          data_out_v_o = 0;
        end

      else
        begin  
          //check is memory is full
          if(wr_ptr - read_ptr>=3'b111) 
              is_full = 1;
          
          //check if there is data and memory not full
          if(data_in_v_i && !is_full) 
            begin 
              //fill the memory
              mem[wr_ptr] = data_in_i; 
              wr_ptr+=1;
              // check request
              if(data_out_req_i)
                begin 
                  if(wr_ptr - read_ptr == 0)
                    begin 
                      data_out_v_o = 0;
                    end
               else 
                  //read fifo to the output
                 begin
                   data_out_o =  mem[read_ptr];  
                   read_ptr+=1;
                   data_out_v_o= 1;
                  
                 end
                end
            end
        end
    end 

endmodule
