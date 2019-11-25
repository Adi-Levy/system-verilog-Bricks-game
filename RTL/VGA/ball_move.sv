//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// module for moving the ball in strait lines


module	ball_move	(	
 
					input		logic	clk,
					input		logic	resetN,
					input		logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input		logic	X_direction,  //change the direction in X 
					input		logic	toggleY,	//toggle the y direction  
					input 	logic [4:0]    ballCollision, // if there was a ball collision and from which direction
					input    logic [2:0] batCollision, // if the ball collided with the bat
					input    logic pre_start, // game state input
					input    logic [10:0]topXPreStart, // initial position
					input    logic [10:0]topYPreStart,
					input    logic bonusCollision, // if there was a collision of bat and bonus
					input    logic [2:0]bonusCode, // what was the bonus that was taken
					
					output 	logic	[10:0]	topLeftX,// output the top left corner 
					output	logic	[10:0]	topLeftY,
					output  	logic hitBottom // if the ball hit the bottom of the screen
					
);


// a module used to generate a ball trajectory.  

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int INITIAL_X_SPEED = 71;
parameter int INITIAL_Y_SPEED = -71;

const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int	x_FRAME_SIZE	=	626 * MULTIPLIER;
const int	y_FRAME_SIZE	=	430 * MULTIPLIER;

int signed Xspeed; // local parameters 
int topLeftX_tmp; 
int signed Yspeed; 
int topLeftY_tmp;
logic toggleY_d; 
logic enable_flag = 1'b0;
logic frame_flag_x = 1'b1;
logic frame_flag_y = 1'b1;
logic hitBottom_d = 1'b0;
int speedLvl = 3;


//  calculation x Axis speed 

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		Xspeed	<= INITIAL_X_SPEED;
		frame_flag_x = 1'b1;
	end
	else 	begin
			if (startOfFrame) frame_flag_x <= 1'b1; 
			if (hitBottom_d) Xspeed	<= INITIAL_X_SPEED;
			else if (frame_flag_x && frame_flag_y) begin
			
				if ((topLeftX_tmp <= 0 || ballCollision == 5'b11000 ) && (Xspeed < 0) ) begin // hit left border while moving right
					Xspeed <= -Xspeed ;
					frame_flag_x <= 1'b0;
				end
			
				else if ( (topLeftX_tmp >= x_FRAME_SIZE || ballCollision == 5'b10100) && (Xspeed > 0 )) begin // hit right border while moving left
					Xspeed <= -Xspeed ;
					frame_flag_x <= 1'b0;
				end
				// if there was a collision with the bat not on this axis we still need to change this speed to keep actuall speed the same but in a different angel
				else if (batCollision != 3'd0) begin
					case (batCollision)
						3'b001: Xspeed <= -86;
						3'b010: Xspeed <= -71;
						3'b011: Xspeed <= -50;
						3'b100: Xspeed <= 0;
						3'b101: Xspeed <= 50;
						3'b110: Xspeed <= 71;
						default: Xspeed <= 86;
					endcase
				end
				if(pre_start) begin // reset speed when changing lvls
					Xspeed <= INITIAL_X_SPEED;
				end
			end			
	end
end


//  calculation Y Axis speed using gravity

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;
		toggleY_d = 1'b0; 
		hitBottom = 1'b0;
		frame_flag_y = 1'b1;
	end 
	else begin
		hitBottom <= 1'b0;
		toggleY_d <= toggleY ; // for edge detect 
		if ((toggleY == 1'b1 ) && (toggleY_d== 1'b0)) // detect toggle command rising edge from user  
			Yspeed <= -Yspeed ; 
		else begin  	
			if (startOfFrame) frame_flag_y <= 1'b1;
			if (frame_flag_x && frame_flag_y) begin
				if (hitBottom_d) Yspeed	<= INITIAL_Y_SPEED; // hit bottom reset speed
				else if ((topLeftY_tmp <= 0 || ballCollision == 5'b10001) && (Yspeed < 0 )) begin // hit top border heading up
					Yspeed <= -Yspeed ;
					frame_flag_y <= 1'b0;
				end	
				else if ( ( topLeftY_tmp >= y_FRAME_SIZE ) && (Yspeed > 0 ) ) begin //hit bottom border heading down 
					hitBottom <= 1'b1;
					frame_flag_y <= 1'b0;
				end
				else if ( (ballCollision == 5'b10010) && (Yspeed > 0 ) ) begin // hit bat heading down
					// need to change this speed to keep actuall speed the same but in a different angel
					case (batCollision)
						3'b001: Yspeed <= -50;
						3'b010: Yspeed <= -71;
						3'b011: Yspeed <= -86;
						3'b100: Yspeed <= -100;
						3'b101: Yspeed <= -86;
						3'b110: Yspeed <= -71;
						3'b111: Yspeed <= -50;
						default: Yspeed <= -Yspeed;
					endcase
					frame_flag_y <= 1'b0;
				end
				if(pre_start) begin // reset speed when changing lvls
					Yspeed <= INITIAL_Y_SPEED;
				end
			end
			hitBottom_d <= hitBottom;
		end
	end 
end

// position calculate 

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_tmp	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp	<= INITIAL_Y * MULTIPLIER;
		enable_flag <= 1'b0;
		speedLvl <= 3;
	end
	else begin
		//change speed according to bonus
		if(bonusCollision) begin
			if(bonusCode == 3'd3) begin
				speedLvl <= 4;
			end
			else if(bonusCode == 3'd4) begin
				speedLvl <= 2;
			end
			else begin
				speedLvl <= 3;
			end
		end
		
		// reseting ball location if life lost or moving to next level
		if (hitBottom_d) begin
			topLeftX_tmp	<= INITIAL_X * MULTIPLIER;
			topLeftY_tmp	<= INITIAL_Y * MULTIPLIER;
		end
		else if (startOfFrame == 1'b1 && pre_start) begin
			topLeftX_tmp  <= topXPreStart * MULTIPLIER;
			topLeftY_tmp  <= topYPreStart * MULTIPLIER;
			speedLvl <= 3; 
		end
		// move the ball
		else if (startOfFrame == 1'b1  && !pre_start) begin // perform only 30 times per second 
			if (X_direction)  //select the direction 
				topLeftX_tmp  <= topLeftX_tmp + ((Xspeed*speedLvl)/2); 
			else 
				topLeftX_tmp  <= topLeftX_tmp - ((Xspeed*speedLvl)/2); 
		
			topLeftY_tmp  <= topLeftY_tmp + ((Yspeed*speedLvl)/2);
		end
	end
end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_tmp / MULTIPLIER ;   // note:  it must be 2^n 
assign 	topLeftY = topLeftY_tmp / MULTIPLIER ;    


endmodule
