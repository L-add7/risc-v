// cache : tag memory single port 1024 blocks

`include "cache_def.sv"
module dm_cache_tag(
    input       bit                 clk,
    input       cache_req_type      tag_req,        //tag request/command
    input       cache_tag_type      tag_write,      //write port

    output      cache_tag_type      tag_read        //read port
);

    cache_tag_type tag_mem[0:1023];

    initial begin
        for(int i = 0 ; i < 1024 ; i ++)
            tag_mem[i] = 'd0;
    end

    assign tag_read = tag_mem[tag_req.index]

    always_ff @(posedge clk) begin                  //write
        if(tag_req.we)
            tag_mem[tag_req.index] <= tag_write;
    end
endmodule