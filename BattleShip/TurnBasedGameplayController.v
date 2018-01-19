module TurnBasedGameplayController(input [7:0] kbdOut,
    input [3:0]KEY,
    output [9:0] LEDR,
    output [6:0] HEX0,HEX1,
	 
	 input [9:0] memOut1 , memOut2,
	 
	 
	 output writeEnTallyb1, writeEnTallyb2,
	 output [19:0] dataInTallyb1, dataInTallyb2,
	 input [19:0] dataOutTallyb1, dataOutTallyb2,
	 
	 output [3:0] addressTallyb1, addressTallyb2,
	 output [3:0] toposY1, toposY2,
	 output [3:0]drawX, drawY, 
	 output isPlayer1,isPlayer2, attackTypePlayer1,attackTypePlayer2,
	 output reg displayControl,
	 output reg [1:0] whoWon, input startFSM
	 ); 
	 
	 		//Part wich allows turn based gameplay. No endgame determination yet.
		//LED0 indicates its player1s turn and LED 1 indicates Player2s turn.
		//LED 9 indicates player1 hit something and LED 7 indicates a hit for player 2
		

	 
	reg [19:0] dataOutTallyb1reg, dataOutTallyb2reg;
	reg [3:0] posX1, posY1, posY2, posX2;
	
	reg [3:0] drawXreg , drawYreg ;
	reg isPlayer1reg, isPlayer2reg,attackTypePlayer1reg,attackTypePlayer2reg;
	
	assign drawX = drawXreg;
	assign drawY = drawYreg;
	assign isPlayer1 = isPlayer1reg;
	assign isPlayer2 = isPlayer2reg;
	assign attackTypePlayer1 = attackTypePlayer1reg;
	assign attackTypePlayer2 = attackTypePlayer2reg;
	
	
	wire locData1, locData2;

	
	assign toposY1 = posY1;
	assign toposY2 = posY2;
		 //Displays the coordinates chosen by the user
	 hex_decoder displayX1(kbdOut[7:4],HEX0);
	 hex_decoder displayY1(kbdOut[3:0],HEX1);
	
	 //Getting either a 1 or a 0 depending on wether a ship existed in that location
	 assign locData1 = memOut1[9-posX1];
	 assign locData2 = memOut2[9-posX2];
	 
	 //Setting up relations between tally memory modules and control logic for user 1
	 assign writeEnTallyb1 = writeEnTallyb1reg;
	 assign dataInTallyb1 = dataOutTallyb1reg;
	 assign addressTallyb1 = posY1;
	 
	 //Setting up relations between tally memory modules and control logic for user 1
	 assign writeEnTallyb2 = writeEnTallyb2reg; 
	 assign dataInTallyb2 = dataOutTallyb2reg;
	 assign addressTallyb2 = posY2;
	 

	 //Updating the correct coordinates in the tally memory map for user 1 depending on the outcome of an attack
	 // 00 - Unknown, 01 - MISS, 10 - HIT
	 always@(*) begin
		dataOutTallyb1reg = dataOutTallyb1;
		dataOutTallyb1reg[19-(posX1*2)] = dataOutTallyb1reg1;
		dataOutTallyb1reg[19-(posX1*2)-1] = dataOutTallyb1reg2;
	 end

	 //Similar as above always block but for user 2
	 always@(*) begin
		dataOutTallyb2reg = dataOutTallyb2;
		dataOutTallyb2reg[19-(posX2*2)] = dataOutTallyb2reg1;
		dataOutTallyb2reg[19-(posX2*2)-1] = dataOutTallyb2reg2;
	 end
	 
	  reg  out1;
	  reg dataOutTallyb1reg1,dataOutTallyb1reg2, writeEnTallyb1reg;
	  
	  reg reg1, reg2;
	  //Control logic for determining correct values for tally board for user 1
	 always @(*) begin
			
        case (locData1)
            1'b0: begin
					out1 = 0;
					
					dataOutTallyb1reg1 = 0;
					dataOutTallyb1reg2 = 1;
					writeEnTallyb1reg = 1;
					
					attackTypePlayer1reg = 0;
					
				end
				
				1'b1: begin
					out1 = 1;

					dataOutTallyb1reg1 = 1;
					dataOutTallyb1reg2 = 0;
					writeEnTallyb1reg = 1;
					
					attackTypePlayer1reg = 1;
				end
				
				default: begin
					out1 = 0;
					attackTypePlayer1reg = 0;
				end
				
			endcase
	end
	
	
	assign LEDR[9] = out1;
	
	
	
	reg  out2;
	reg dataOutTallyb2reg1,dataOutTallyb2reg2, writeEnTallyb2reg;
	//Control logic for determining correct values for tally board for user 2
	 always @(*) begin
		
        case (locData2)
            1'b0: begin
					//playerNumreg <= 1;
					out2= 0;
					dataOutTallyb2reg1 = 0;
					dataOutTallyb2reg2 = 1;
					
					attackTypePlayer2reg = 0;
				end
				
				1'b1: begin
					//playerNumreg <= 1;
					out2 = 1;
					
					
					
					dataOutTallyb2reg1 = 1;
					dataOutTallyb2reg2 = 0;
					
					attackTypePlayer2reg = 1;
				end
				
				default: begin
					out2 = 0;
					attackTypePlayer2reg = 0;
				end
				
			endcase
	end
	assign LEDR[7] = out2;
	
	
	
	
  reg [1:0] pState, nState;
  
  parameter start = 2'b00, input1 = 2'b01, input2 = 2'b10, endGame = 2'b11;
  
  reg [3:0] p1HitCounter = 4'b0000, p2HitCounter = 4'b0000;
  // 0 when player 1 won and 1 when player 2 won
  

  
  
  //Next state decleration
  //FSM for allowing turn based input
  //Allows turn based gameplay. If a user hits then they get another turn
  always@( posedge ~KEY[0])
	begin: state_table
		case(pState)
			//State when player 1 inputs attack
			
			start: begin
				if(startFSM == 1) begin
					nState = input1;
				end
				displayControl = 0;
	
			end
			input1: begin
								posX1 = kbdOut[7:4];
								posY1 = kbdOut[3:0];
								drawXreg = posX1;
								drawYreg  = posY1;
								isPlayer1reg = 1;
								isPlayer2reg = 0;
								displayControl = 1;
								
								//Determine next state based on the outcome of attack
								//Do something at the posedge of key0 and only then increment the counter...
								//Or just increment it somwhere else
								//Do the smae with the other counter;
								if (out1) begin
									p1HitCounter = p1HitCounter + 1;
									if(p1HitCounter == 5) nState = endGame;
									else nState = input2;
								end
								else begin nState = input2; end
						
						
						
					end
			//State when player 2 inputs attack
			input2: begin
						
							posX2 =kbdOut[7:4];
							posY2 =kbdOut[3:0];
							drawXreg = posX2;
							drawYreg = posY2;
							isPlayer1reg = 0;
							isPlayer2reg = 1;
							
							if(out2) begin
								p2HitCounter = p2HitCounter + 1;
								if(p2HitCounter == 5) nState = endGame;
								else nState = input1;
							end
							else begin 
								
								 nState = input1;	  
							end
						
					 end
					 
					 
			endGame: begin
				displayControl = 0;
				if(p1HitCounter == 5) whoWon = 2'b01;
				else if(p2HitCounter == 5) whoWon = 2'b10;
				//nState = start;
			end
			
			
			
			default: nState = start;
		endcase
		
	end
	
	// State Registers
    always @(negedge ~KEY[0])
    begin: state_FFs
            pState = nState;
    end // state_FFS
  
  
  //Determines who's turn it is
  assign LEDR[1:0] = pState[1:0];
  assign LEDR[6:5] = whoWon[1:0];
  assign LEDR[4] = displayControl;
  assign LEDR[8] = startFSM;
endmodule