//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering  May 2019 


//the mux of the VGA display

module	objects_mux	(	
					input		logic	clk,
					input		logic	resetN,
					input    logic [2:0] bgState, // input if there is a state that requires only background
					// ball 
					input		logic	[7:0] ballRGB, // two set of inputs per unit
					input		logic	ballDrawingRequest,
					// add the box here 
					input    logic [7:0] boxRGB,   // bat inputs to screen
					input    logic boxDrawingRequest,
					// fill your code here inputs for box
					input    logic [7:0] brikRGB,  // bricks input to screen
					input    logic brikDrawingRequest,
					input    logic letterDrawReq,  // letters input to screen
					input    logic [7:0] letterRGB,
					// background 
					input		logic	[7:0] backGroundRGB,
					// lives
					input    logic lifeBall1DrawReq,
					input    logic lifeBall2DrawReq,
					input    logic lifeBall3DrawReq,
					input    logic [7:0] lifeBall3RGB,
					input    logic [7:0] lifeBall2RGB,
					input    logic [7:0] lifeBall1RGB,
					// score
					input    logic onesDigDrawReq,
					input    logic tensDigDrawReq,
					input    logic hundredsDigDrawReq,
					input    logic thousendsDigDrawReq,
					input    logic scoreDrawReq,
					input    logic [7:0] onesDigRGB,
					input    logic [7:0] tensDigRGB,
					input    logic [7:0] hundredsDigRGB,
					input    logic [7:0] thousendsDigRGB,
					input    logic [7:0] scoreRGB,
					// bonus
					input    logic [7:0] bonusRGB,
					input    logic bonusDrawReq,
					// game name
					input    logic [7:0] gameNameRGB,
					input    logic gameNameDrawReq,

					output	logic	[7:0] redOut, // full 24 bits color output
					output	logic	[7:0] greenOut, 
					output	logic	[7:0] blueOut 
);

logic [7:0] tmpRGB;


assign redOut	  = {tmpRGB[7:5], {5{tmpRGB[5]}}}; //--  extend LSB to create 10 bits per color  
assign greenOut  = {tmpRGB[4:2], {5{tmpRGB[2]}}};
assign blueOut	  = {tmpRGB[1:0], {6{tmpRGB[0]}}};

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if(bgState != 3'd0) begin // drawing priority for only background stages of the game
			if(gameNameDrawReq && (bgState == 3'd1))
				tmpRGB <= gameNameRGB;
			else if(letterDrawReq)
				tmpRGB <= letterRGB; // drawing the writing on the screen
			else
				tmpRGB <= backGroundRGB; // normal background
		end
		
		else if (ballDrawingRequest == 1'b1 )   
			tmpRGB <= ballRGB;  //first priority (ball)
			
		else if (bonusDrawReq == 1'b1 ) // bonus priority   
			tmpRGB <= bonusRGB;
		
		else if (boxDrawingRequest) // bat priority
			tmpRGB <= boxRGB;
		
		else if (brikDrawingRequest) // brick priority
			tmpRGB <= brikRGB;
		
		else if (lifeBall1DrawReq) //first lifedrawing priority
			tmpRGB <= lifeBall1RGB;
		
		else if (lifeBall2DrawReq) //second lifedrawing priority
			tmpRGB <= lifeBall2RGB;
		
		else if (lifeBall3DrawReq) //third lifedrawing priority
			tmpRGB <= lifeBall3RGB;
			
		else if (onesDigDrawReq) //ones digit of score priority
			tmpRGB <= onesDigRGB;
			
		else if (tensDigDrawReq) //tens digit of score priority
			tmpRGB <= tensDigRGB;
			
		else if (hundredsDigDrawReq) //hundreds digit of score priority
			tmpRGB <= hundredsDigRGB;
			
		else if (thousendsDigDrawReq) //thousends digit of score priority
			tmpRGB <= thousendsDigRGB;
			
		else if (scoreDrawReq) //the word "score" priority
			tmpRGB <= scoreRGB;
			
		else 
			tmpRGB <= backGroundRGB ; // last priority (background)
		end  
	end

endmodule


