`include "cache.vh"
/**
 * w_en: write enable
 */
module line #(
	parameter TAG_WIDTH    = `CACHE_T,
		      OFFSET_WIDTH = `CACHE_B
)(
	input                        clk, rst,
	input  [OFFSET_WIDTH - 3:0]  offset,
	input                        w_en, set_valid, set_dirty,
	input  [TAG_WIDTH - 1:0]     set_tag,
	input  [31:0]                write_data,
	output reg                   valid,
	output                       dirty,
	output reg [TAG_WIDTH - 1:0] tag,
	output [31:0]                read_data
);
	localparam		DATA_WIDTH = 32;
	localparam		VALID_WIDTH= 1;
	localparam		DIRTY_WIDTH= 1;
	localparam		LINE_SIZE  = 2**(`CACHE_B-2);
	reg		[DATA_WIDTH-1:0]		cache_line [LINE_SIZE-1:0];

	always @(posedge clk) begin
		integer i;
		if(rst) begin
			for(i=0;i<LINE_SIZE;i=i+1)
				cache_line[i] <= 32'd0;
			valid <= 1'b0;
			dirty <= 1
		end
	end



endmodule