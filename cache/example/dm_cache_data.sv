/*
    使用的memory是异步读取 同步写入
*/
// cache : data memory
`include "cache_def.sv"
module dm_cache_data(
    input       bit              clk,
    input       cache_req_type   data_req,      
    input       cache_data_type  data_write,    //write port

    output      cache_data_type  data_read      //read port
);

    cache_data_type data_mem[0:1023];
    
    initial begin
        for(int i = 0 ; i<1024 ; i ++)
            data_mem[i] ='d0;
    end

    assign data_read = data_mem[data_req.index];    //read

    always_ff @(posedge clk) begin                  //write
        if(data_req.we)
            data_mem[data_req.index] <== data_write;
    end
endmodule