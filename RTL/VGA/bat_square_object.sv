//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019
// bat object data and managment 


module	bat_square_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					input 	logic	[10:0] topLeftX, //position on the screen 
					input 	logic	[10:0] topLeftY,
					input    logic preStart, //in pre Game state
					input    logic [2:0] bonusCode, // the bonus that the bat collided with
					input    logic bonusCollision, // if the bat collided with a bonus
					
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout, //optional color output for mux 
					output   logic [2:0] legnth // the current legnth of the bat
);

parameter  int OBJECT_WIDTH_X = 100;
parameter  int OBJECT_HEIGHT_Y = 100;
parameter  logic [7:0] OBJECT_COLOR = 8'h5b ; 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
int rightX = 639; //coordinates of the sides  
int bottomY ;
logic insideBracket ;
logic enable_flag = 1'b0; 
logic [2:0]bonusCode_d = 3'd0;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Calculate objec bottom  boundary
assign bottomY	= (topLeftY + OBJECT_HEIGHT_Y);


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout			<=	8'b0;
		drawingRequest	<=	1'b0;
		enable_flag <= 1'b0;
		rightX <= (topLeftX + OBJECT_WIDTH_X);
		legnth <= 3'd2;
		bonusCode_d <= 3'd0;
	end
	else begin 
		
		// check if bonus for bat and do according to bonus
		bonusCode_d <= bonusCode;
		if(bonusCollision) begin
			if((bonusCode == 3'd1)) begin // make bat longer
				rightX = (topLeftX + (OBJECT_WIDTH_X*2));
				legnth <= 3'd4;
			end
			else if((bonusCode == 3'd2)) begin // make bat shorter
				rightX = (topLeftX + (OBJECT_WIDTH_X/2));
				legnth <= 3'd1; 
			end
			else begin // if hit bonus but not legnth related
				rightX = (topLeftX + OBJECT_WIDTH_X);
				legnth <= 3'd2;
			end
		end
		// keep previous legnth if no collision
		else if(legnth == 3'd4) begin
			rightX = (topLeftX + (OBJECT_WIDTH_X*2));
		end
		else if(legnth == 3'd2) begin
			rightX = (topLeftX + (OBJECT_WIDTH_X));
		end
		else if(legnth == 3'd1) begin
			rightX = (topLeftX + (OBJECT_WIDTH_X/2));
		end

		//this is an example of using blocking sentence inside an always_ff block, 
		//and not waiting a clock to use the result  
		insideBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; 
		
		if (insideBracket) // test if it is inside the rectangle 
		begin 
			RGBout  <= OBJECT_COLOR ;	// colors table 
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner
			offsetY	<= (pixelY - topLeftY);
		end 
		
		else begin  
			RGBout <= TRANSPARENT_ENCODING ; // so it will not be displayed 
			drawingRequest <= 1'b0 ;// transparent color 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		end
		if(preStart) begin // reset legnth when moving lvls or when ball hits bottom
			rightX = (topLeftX + (OBJECT_WIDTH_X));
			legnth <= 3'd2;
		end
	end
end 
endmodule 