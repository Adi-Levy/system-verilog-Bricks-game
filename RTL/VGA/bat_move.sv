//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog version Alex Grinshpun May 2018
// coding convention dudy December 2018


module	bat_move	(	
 
					input		logic	clk,
					input		logic	resetN,
					input		logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input		logic	right,  //move the bat to the right 
					input		logic	left,	 // move the bat to the left
					input    logic collision, // find out if the was a collision
					input    logic [2:0] legnth, // current legnth of the bat nedded
					output 	logic	[10:0]	topLeftX// output the top left corner 
);


// a module used to generate a bat movment according to the arrow keys.  

parameter int INITIAL_X = 285;
parameter int INITIAL_X_SPEED = 100;

const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int	x_FRAME_SIZE	=	639 ;
const int   X_WIDTH = 27 ;


int Xspeed, topLeftX_tmp; // local parameters  
logic enable_flag = 1'b0;
// position calculate 

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_tmp	<= INITIAL_X * MULTIPLIER;
		Xspeed <= INITIAL_X_SPEED;
		enable_flag <= 1'b0;
	end
	else begin
		
		if (startOfFrame == 1'b1 && !collision) begin // perform only 30 times per second and only if there is no collision at the moment
				if (right && !left && topLeftX_tmp <= ((x_FRAME_SIZE - (X_WIDTH<<(legnth/2)))*MULTIPLIER))  //if the bat is not a t edge of the frame and needs to move right 
					topLeftX_tmp  <= topLeftX_tmp + Xspeed;
				else if (left && !right && topLeftX_tmp > 100) // if bat is not at frame edge and needs to move left 
					topLeftX_tmp  <= topLeftX_tmp - Xspeed;
				else	
					topLeftX_tmp  <= topLeftX_tmp; // if bat doesn't need to move
			end
	end
end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note:  it must be 2^n    


endmodule
