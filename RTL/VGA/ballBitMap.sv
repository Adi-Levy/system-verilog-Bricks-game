//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 



module	ballBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
);
// generating a ball bitmap 

localparam  int OBJECT_WIDTH_X = 26;
localparam  int OBJECT_HEIGHT_Y = 26;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hBA, 8'h92, 8'h4E, 8'h29, 8'h25, 8'h25, 8'h29, 8'h4E, 8'h92, 8'hBA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hB6, 8'h4D, 8'h2A, 8'h4E, 8'h52, 8'h72, 8'h77, 8'h73, 8'h52, 8'h2E, 8'h2E, 8'h2A, 8'h4E, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h6E, 8'h4E, 8'h76, 8'hDB, 8'hDF, 8'hBB, 8'hBB, 8'h9B, 8'h9B, 8'h9B, 8'h7B, 8'h77, 8'h57, 8'h52, 8'h4E, 8'h6E, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h4E, 8'h72, 8'hDB, 8'hBB, 8'hBB, 8'h57, 8'h57, 8'h7B, 8'h7B, 8'h7B, 8'h7B, 8'h77, 8'h77, 8'h57, 8'h57, 8'h57, 8'h52, 8'h6E, 8'hDB, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDB, 8'h4E, 8'h96, 8'hDF, 8'hDF, 8'hBB, 8'h33, 8'h37, 8'h57, 8'h57, 8'h57, 8'h57, 8'h57, 8'h57, 8'h57, 8'h57, 8'h57, 8'h33, 8'h33, 8'h52, 8'h6E, 8'hDB, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h72, 8'h76, 8'hBB, 8'hBB, 8'hBB, 8'h53, 8'h33, 8'h33, 8'h57, 8'h57, 8'h57, 8'h57, 8'h37, 8'h33, 8'h33, 8'h53, 8'h57, 8'h37, 8'h33, 8'h13, 8'h2E, 8'h72, 8'hFF, 8'hFF },
{8'hFF, 8'hB6, 8'h4E, 8'h72, 8'h97, 8'hBB, 8'h77, 8'h0F, 8'h33, 8'h33, 8'h33, 8'h37, 8'h37, 8'h33, 8'h33, 8'h33, 8'h13, 8'h0F, 8'h33, 8'h33, 8'h33, 8'h13, 8'h13, 8'h2E, 8'hB6, 8'hFF },
{8'hFF, 8'h4E, 8'h4E, 8'h77, 8'h77, 8'h77, 8'h0F, 8'h0F, 8'h13, 8'h33, 8'h33, 8'h33, 8'h33, 8'h33, 8'h33, 8'h13, 8'h0F, 8'h0F, 8'h0F, 8'h33, 8'h33, 8'h13, 8'h13, 8'h0E, 8'h4E, 8'hFF },
{8'hBB, 8'h2A, 8'h73, 8'h9B, 8'hDF, 8'h77, 8'h0F, 8'h0F, 8'h0F, 8'h13, 8'h13, 8'h33, 8'h33, 8'h33, 8'h13, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h13, 8'h13, 8'h0F, 8'h0E, 8'h0A, 8'hBB },
{8'h92, 8'h2A, 8'h77, 8'h9B, 8'hBB, 8'h33, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0E, 8'h0A, 8'h13, 8'h13, 8'h0E, 8'h0E, 8'h0A, 8'h92 },
{8'h4E, 8'h0A, 8'h2E, 8'h52, 8'h73, 8'h0A, 8'h0E, 8'h0E, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0E, 8'h0E, 8'h0A, 8'h0A, 8'h0E, 8'h0F, 8'h0E, 8'h0E, 8'h0A, 8'h4E },
{8'h29, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0E, 8'h0E, 8'h0F, 8'h0F, 8'h0F, 8'h0E, 8'h0E, 8'h0E, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0E, 8'h0A, 8'h0A, 8'h29 },
{8'h05, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h05 },
{8'h05, 8'h06, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0E, 8'h0A },
{8'h25, 8'h05, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h06, 8'h0E, 8'h2A },
{8'h4A, 8'h05, 8'h06, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h06, 8'h05, 8'h2E, 8'h4E },
{8'h72, 8'h05, 8'h06, 8'h06, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h06, 8'h05, 8'h01, 8'h25, 8'h2E, 8'h72 },
{8'hBB, 8'h05, 8'h06, 8'h06, 8'h06, 8'h06, 8'h05, 8'h06, 8'h06, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h06, 8'h06, 8'h05, 8'h05, 8'h05, 8'h01, 8'h4E, 8'h29, 8'hBB },
{8'hFF, 8'h4E, 8'h06, 8'h06, 8'h06, 8'h06, 8'h05, 8'h05, 8'h05, 8'h05, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h05, 8'h05, 8'h05, 8'h05, 8'h05, 8'h25, 8'h6E, 8'h4A, 8'hFF },
{8'hFF, 8'hBB, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h05, 8'h05, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h05, 8'h05, 8'h05, 8'h05, 8'h4A, 8'h29, 8'hB7, 8'hFF },
{8'hFF, 8'hFF, 8'h72, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h0A, 8'h0A, 8'h0A, 8'h06, 8'h06, 8'h06, 8'h06, 8'h05, 8'h05, 8'h05, 8'h05, 8'h72, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h4E, 8'h06, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h06, 8'h06, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h06, 8'h06, 8'h06, 8'h05, 8'h05, 8'h06, 8'h4E, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h52, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h06, 8'h06, 8'h06, 8'h0A, 8'h52, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h97, 8'h2E, 8'h0E, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0A, 8'h0E, 8'h2E, 8'h97, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'h97, 8'h77, 8'h57, 8'h53, 8'h33, 8'h33, 8'h33, 8'h33, 8'h33, 8'h33, 8'h53, 8'h97, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hBB, 8'h9B, 8'h9B, 8'h9B, 8'h9B, 8'hBB, 8'hBB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};

// pipeline (ff) to get the pixel color from the array 	 

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		if (InsideRectangle == 1'b1 )  // inside an external bracket 
			RGBout <= object_colors[offsetY*2][offsetX*2];	//get RGB from the colors table  
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule