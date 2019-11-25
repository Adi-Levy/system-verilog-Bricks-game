//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 

//the display of the bonus

module	bonusBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket
					input logic [2:0]bonusCode,
					input logic activate, //keep the bonus display
					input logic active_flag, //keep the bonus display

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout,  //rgb value from the bitmap 
					output   logic [2:0] outBonusCode
);
// generating a smiley bitmap 

localparam  int OBJECT_WIDTH_X = 32;
localparam  int OBJECT_HEIGHT_Y = 16;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

localparam logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] FAST = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDA, 8'hDA, 8'hDA, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hCD, 8'hCD, 8'hB6, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hC9, 8'hD2, 8'hB6, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hC9, 8'hE0, 8'hC9, 8'hD2, 8'hB6, 8'hBA, 8'hB6, 8'hB6, 8'hC5, 8'hE4, 8'hC9, 8'hD2, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF },
{8'hFF, 8'hDB, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hC9, 8'hE4, 8'hE4, 8'hE4, 8'hC9, 8'hD2, 8'hB6, 8'hB6, 8'hC5, 8'hE4, 8'hE4, 8'hE4, 8'hC9, 8'hD2, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hFF, 8'hFF },
{8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hC9, 8'hE4, 8'hE4, 8'hE4, 8'hE0, 8'hC9, 8'hB6, 8'hB6, 8'hC5, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hC9, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hFF, 8'hFF },
{8'hFF, 8'hDB, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hC9, 8'hE4, 8'hE4, 8'hC5, 8'hCD, 8'hB6, 8'hB6, 8'hB6, 8'hC5, 8'hE4, 8'hE4, 8'hC9, 8'hD2, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hC9, 8'hE4, 8'hC9, 8'hD6, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'hC5, 8'hC4, 8'hCD, 8'hB6, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDB, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hCD, 8'hD2, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hCD, 8'hD6, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};


localparam logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] SLOW = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDA, 8'hDA, 8'hDA, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h6E, 8'h92, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h6E, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h4A, 8'h2A, 8'h72, 8'hD6, 8'hB6, 8'hD6, 8'hB6, 8'h6E, 8'h4A, 8'h4A, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF },
{8'hFF, 8'hDB, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h6E, 8'h4A, 8'h4A, 8'h4A, 8'h72, 8'hDA, 8'hB6, 8'h92, 8'h4A, 8'h4A, 8'h4A, 8'h4E, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hFF, 8'hFF },
{8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h72, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h72, 8'hDA, 8'h92, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4E, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hFF, 8'hFF },
{8'hFF, 8'hDB, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h4A, 8'h4A, 8'h4A, 8'h72, 8'hD6, 8'hB6, 8'hB6, 8'h4E, 8'h4A, 8'h4A, 8'h4E, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hD6, 8'hB6, 8'h6E, 8'h2A, 8'h72, 8'hD6, 8'hB6, 8'hB6, 8'hB6, 8'h6E, 8'h4A, 8'h4E, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDB, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h6E, 8'h72, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h6E, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};


localparam logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] LONG = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDA, 8'hDA, 8'hDA, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'h92, 8'h92, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h96, 8'h92, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'h72, 8'h4A, 8'h92, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'h92, 8'h4A, 8'h92, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'h6E, 8'h4A, 8'h4A, 8'h4A, 8'h4E, 8'h4E, 8'h4E, 8'h4E, 8'h6E, 8'h92, 8'h6E, 8'h6E, 8'h6E, 8'h6E, 8'h6E, 8'h4E, 8'h4A, 8'h4A, 8'h6E, 8'hB6, 8'hDA, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF },
{8'hFF, 8'hDB, 8'hB6, 8'hB6, 8'h92, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h92, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h92, 8'hB6, 8'hB6, 8'hB6, 8'hFF, 8'hFF },
{8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h92, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h96, 8'hB6, 8'hB6, 8'hFF, 8'hFF },
{8'hFF, 8'hDB, 8'hB6, 8'hB6, 8'hB6, 8'h6E, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h92, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h6E, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h92, 8'h4A, 8'h4A, 8'h6E, 8'h72, 8'h72, 8'h72, 8'h6E, 8'h92, 8'hB6, 8'h92, 8'h92, 8'h92, 8'h92, 8'h92, 8'h6E, 8'h4A, 8'h4A, 8'h72, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDB, 8'hB6, 8'hB6, 8'hB6, 8'hD6, 8'h92, 8'h4A, 8'h92, 8'hDA, 8'hD6, 8'hD6, 8'hD6, 8'hB6, 8'hB6, 8'hB6, 8'hD6, 8'hD6, 8'hD6, 8'hDA, 8'h92, 8'h4A, 8'h92, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'h96, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};


localparam logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] SHORT = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDA, 8'hDA, 8'hDA, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hD2, 8'hB6, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hB6, 8'hCD, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hB6, 8'hB6, 8'hBA, 8'hBA, 8'hBA, 8'hC9, 8'hC5, 8'hD2, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hD2, 8'hC5, 8'hC9, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hDB, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDA, 8'hD2, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC5, 8'hE4, 8'hC4, 8'hCD, 8'hB6, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'hCD, 8'hE4, 8'hE4, 8'hC5, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hCD, 8'hB6, 8'hDB, 8'hFF, 8'hFF },
{8'hFF, 8'hDB, 8'hB6, 8'hC9, 8'hE0, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hC9, 8'hD2, 8'hB6, 8'hD6, 8'hC9, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE0, 8'hC9, 8'hB6, 8'hB6, 8'hFF, 8'hFF },
{8'hFF, 8'hDA, 8'hB6, 8'hCD, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE0, 8'hC5, 8'hD2, 8'hC9, 8'hE0, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hC9, 8'hBA, 8'hB6, 8'hFF, 8'hFF },
{8'hFF, 8'hDB, 8'hB6, 8'hC9, 8'hE0, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hC9, 8'hD2, 8'hB6, 8'hB6, 8'hC9, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE4, 8'hE0, 8'hC9, 8'hBA, 8'hB6, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hB6, 8'hD2, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hCD, 8'hC9, 8'hE4, 8'hC4, 8'hCD, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hCD, 8'hC4, 8'hE4, 8'hC5, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hC9, 8'hCE, 8'hB6, 8'hDA, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hDB, 8'hB6, 8'hBA, 8'hBA, 8'hBA, 8'hBA, 8'hBA, 8'hC9, 8'hC9, 8'hD6, 8'hBA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hD2, 8'hC5, 8'hC9, 8'hBA, 8'hBA, 8'hBA, 8'hBA, 8'hBA, 8'hB6, 8'hDA, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hD2, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hBA, 8'hB6, 8'hD2, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hB6, 8'hDA, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors;
// pipeline (ff) to get the pixel color from the array 	 

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
		object_colors <= TRANSPARENT_ENCODING;
		outBonusCode <= 3'd0;
	end
	else begin
		if (activate && !active_flag) begin //activate the right bonus display (only one bunus at a time)
			case (bonusCode)
				3'd1 : object_colors <= LONG;
				3'd2 : object_colors <= SHORT;
				3'd3 : object_colors <= FAST;
				3'd4 : object_colors <= SLOW;
				default : object_colors <= TRANSPARENT_ENCODING;
			endcase
			outBonusCode <= bonusCode;
		end
		if (InsideRectangle == 1'b1 ) begin // inside an external bracket 
			RGBout <= object_colors[offsetY][offsetX]; //out put the color acording to the bitmaps
		end
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule