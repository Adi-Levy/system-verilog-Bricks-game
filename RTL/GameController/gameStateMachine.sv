
//the state machine of the game


module gameStateMachine
	(
	input logic clk, resetN, start, risingSpace, brakeSpace, noBrick, hitbottom,
	input logic [3:0] numKey,
	output logic preState, random,
	output logic [2:0] bgState, 
	output logic [1:0] life, lvl
   );

	enum logic [3:0] {Sidle, Spre1, Sgame1, Spre2, Sgame2, Srand, SpreR, SgameR, Swin, Slose} prState, nxtState;
	logic [1:0] nxtlife = 2'd3;
 	
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  begin// Asynchronic reset
		prState <= Sidle;
		life <= 2'd3;
	end
   else begin		// Synchronic logic FSM
		prState <= nxtState;
		life <= nxtlife;
	end
	end // always
	
always_comb // Update next state and outputs
	begin
		nxtState = prState; // default values 
		nxtlife = life;
		bgState = 3'd0;
		preState = 1'b0;
		random = 1'b0;
			
			//the option of moving between the levels withe the num keys
		if (numKey == 4'd1 && lvl != 2'd1) begin
			nxtState = Spre1;
			lvl = 2'd1;
		end
		else if (numKey == 4'd2 && lvl != 2'd2) begin
			nxtState = Spre2;
			lvl = 2'd2;
		end
		else if (numKey == 4'd3 && lvl != 2'd3) begin 
			nxtState = Srand;
			bgState = 3'd2;
			random = 1'b1;
			lvl = 2'd3;
			preState = 1'b1;
		end
		//else begin		
			case (prState)
					
				Sidle: begin 
					bgState = 3'd1; // choose the open background
					preState = 1'b1;
					lvl = 2'b00;
					if (start == 1'b1) 
						nxtState = Spre1; 
				end // idle state
							
				Spre1: begin 
					preState = 1'b1;
					lvl = 2'b01;
					if (risingSpace == 1'b1)
						nxtState = Sgame1;
				end // pre-game level1 state
							
				Sgame1: begin
					lvl = 2'b01;
					if (hitbottom) begin
						nxtlife = life - 2'd1;
						if(life == 2'd1)
							nxtState = Slose;
						else	
							nxtState = Spre1;
					end
					else if (noBrick) nxtState = Spre2;
				end // game level1 state
						
				Spre2: begin
					preState = 1'b1;
					lvl = 2'b10;
					if (risingSpace == 1'b1) 
						nxtState = Sgame2;	
				end // pre-game level2 state
							
				Sgame2: begin
					lvl = 2'b10;
					if (hitbottom) begin
						nxtlife = life - 2'd1;
						if(life == 2'd1)
							nxtState = Slose;
						else	
							nxtState = Spre2;
					end
					else if (noBrick) nxtState = Srand;
				end // game level 2 state
				
				Srand: begin
					bgState = 3'd2; // choose the randomize background
					random = 1'b1;
					lvl = 2'd3;
					preState = 1'b1;
					if (brakeSpace) begin
						nxtState = SpreR;
					end
				end // randomize the bricks state
				
				SpreR: begin
					preState = 1'b1;
					lvl = 2'd3;
					if (risingSpace == 1'b1) 
						nxtState = SgameR;	
				end // pre-random level state
							
				SgameR: begin
					lvl = 2'd3;
					if (hitbottom) begin
						nxtlife = life - 2'd1;
						if(life == 2'd1)
							nxtState = Slose;
						else	
							nxtState = SpreR;
					end
					else if (noBrick) nxtState = Swin;
				end // game random level state
				
				Swin: begin
					bgState = 3'd3; // choose the win background
					preState = 1'b1;
					lvl = 2'b00;
				end // win state
				
				Slose: begin
					bgState = 3'd4; // choose the lose background
					preState = 1'b1;
					lvl = 2'b00;
				end // lose state
							
			endcase
		//end
	end // always comb
	
endmodule
