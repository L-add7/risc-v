// cache finite state machine
`include "cache_def.sv"
module dm_cache_fsm(
    input     bit              clk,     
    input     bit              rst,
    input     cpu_req_type     cpu_req,     //cpu request input
    input     mem_data_type    mem_data,
    output    mem_req_type     mem_req,
    output    cpu_resule_type  cpu_res
);

    typedef enum  { idle, compare_tag, allocate. write_back } cache_state_type;

    cache_state_type vstate,rstate;

    //interface signals to tag memory
    cache_tag_type tag_read;        //tag read result
    cache_tag_type tag_write;       //tag write result
    cache_req_type tag_req;

    //interface signals to cache data memory
    cache_data_type data_read;
    cache_data_type data_write;
    cache_req_type  data_req;

    //temporary variable for cache controller result
    cpu_resule_type v_cpu_res;

    //temporary variable for memory controller request
    mem_req_type v_mem_req;

    assign mem_req = v_mem_req;
    assign cpu_res = v_cpu_res;

    always_comb begin
        // default values for all signals 
        // no state change by default
        vstate = rstate;
        v_cpu_res = '{0,0};
        tag_write = '{0,0,0};

        //read tag by default
        tag_req.we = 'b0;
        //direct map index for cache data
        tag_req.index = cpu_req.addr[13:4];

        //modify correct word based on address
        data_write = data_read;
        case (cpu_req.addr[3:2])
            2'b00:  data_write[31:0] = cpu_req.data;
            2'b01:  data_write[63:32]= cpu_req.data;
            2'b10:  data_write[95:64]= cpu_req.data;
            2'b11:  data_write[127:96]=cpu_req.data;
        endcase

        //read out correct word from cache to cpu
        case (cpu_req.addr[3:2])
            2'b00:v_cpu_res.data = data_read[31:0];
            2'b01:v_cpu_res.data = data_read[63:32]; 
            2'b10:v_cpu_res.data = data_read[95:64]; 
            2'b11:v_cpu_res.data = data_read[127:96];  
        endcase

        

        //memory request address sampled from cpu request
        v_mem_req.addr = cpu_req.addr;
        //memory request data uesd in write
        v_mem_req.data = data_read;
        v_mem_req.rw   = 'b0;

        case(rstate)
        idle : begin
            if(cpu_req.valid)
                vstate = compare_tag; 
            end
        compare_tag:begin
            //cache_hit
            if(cpu_req.addr[TAGMSB:TAGLSB] == tag_read.tag && tag_read.valid) begin
                v_cpu_res.ready = 'b1;
                //write hit   
                if(cpu_req.rw)begin
                    //read/modify cache line
                    tag_req.we = 'b1;
                    data_req.we= 'b1;
                    //no change in tag
                    tag_write.tag = tag_read.tag;
                    tag_write.valid = 'b1;
                    tag_write.dirty = 1'b1;
                end         
                //xaction if finished
                vstate = IDLE;
            end
            else begin
                //generate new tag
                tag_req.we = 1'b1;
                tag_write.valid = 1'b1;
                // new tag
                tag_write.tag = cpu_req.addr[TAGMSB:TAGLSB];
                //cache line is dirty if write
                tag_write.dirty = cpu_req.rw;
                //generate memory request on miss
                v_mem_req.valid = 1'b1;

                //compulsory miss or miss with clean block
                if(tag_read.valid == 1'b0 || tag_read.dirty ==1'b0)
                    vstate = allocate;
                else begin
                    // miss with dirty line
                    v_mem_req.addr = {tag_read.tag,cpu_req.addr[TAGLSB-1:0]};
                    v_mem_req.rw = 1'b1;
                    //wait till write is completed
                    vstate =  write_back;
                end
            end
        end
        allocate : begin//wait for allocating a new cache line
            // memory controller has responded
            if(mem_data.ready) begin
                //re-compare tag for write miss (need modify correct word
                vstate = compare_tag;
                data_write = mem_data.data;
                data_req.we = 1'b1;
            end
        end
        write_back: begin 
            // write back is completed
            if(mem_data.ready) begin
                v_mem_req.valid = 1'b1;
                v_mem_req.rw = 1'b0;
                vstate = allocate;
            end
        end
        endcase
    end     

    always_ff @(posedge clk) begin
        if(rst)
            rstate <= idle;
        else
            rstate <= vstate; 
    end

    //connect cache tag data memory
    dm_cache_tag ctag(.*);
    dm_cache_data cdata(.*);

endmodule