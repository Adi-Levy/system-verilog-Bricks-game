
//module for the down movment of the bonus object 


module	bonus_move	(	
 
					input		logic	clk,
					input		logic	resetN,
					input		logic	startOfFrame,  // short pulse every start of frame 30Hz  
					input    logic [10:0]topXStart,
					input    logic [10:0]topYStart,
					input    logic activate, //keep the bonus "alive"
					input    logic bonusCollision,
					input    logic [1:0]lvl,
					
					output 	logic	[10:0]	topLeftX,// output the top left corner 
					output	logic	[10:0]	topLeftY,
					output  	logic active_flag
					
);


// a module used to generate a ball trajectory.  

parameter int INITIAL_X = 0;
parameter int INITIAL_Y = 0;
parameter int INITIAL_Y_SPEED = 50; //the speed of the "falling"

logic [1:0]lvl_d = 2'd0; //to cancel the bonuses effect in the switch between levels

const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int	y_FRAME_SIZE	=	430 * MULTIPLIER;


int topLeftX_tmp; // local parameters 
int Yspeed = INITIAL_Y_SPEED;
int topLeftY_tmp;

// position calculate 

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_tmp	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp	<= INITIAL_Y * MULTIPLIER;
		active_flag <= 1'b0;
		lvl_d <= 2'd0;
	end
	else begin
		if (activate && !active_flag) begin
			topLeftX_tmp	<= topXStart * MULTIPLIER;
			topLeftY_tmp	<= topYStart * MULTIPLIER;
			active_flag <= 1'b1;
		end
		if ((topLeftY_tmp <= y_FRAME_SIZE) && (startOfFrame == 1'b1) && active_flag) begin // while bonus is active
			topLeftY_tmp  <= topLeftY_tmp + Yspeed;
		end
		else if (((topLeftY_tmp > y_FRAME_SIZE) || bonusCollision ) && active_flag) begin // bonus is done so reset the active flag
			active_flag <= 1'b0;
		end
		lvl_d <= lvl;
		if(lvl != lvl_d) begin // clear bonus when moving between lvls
			active_flag <= 1'b0;
		end
	end
end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note:  it must be 2^n 
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ;    


endmodule
