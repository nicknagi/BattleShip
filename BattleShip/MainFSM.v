module mainFSM(output reg startGame, input [0:0] KEY, output reg drawWelcome, output reg placeShips);

	reg [1:0] currState, nextState;
	parameter welcome = 2'b00, place_ships = 2'b01, start_game = 2'b10;
	
	always@(posedge ~KEY[0]) begin
		case (currState) 
		
			welcome: begin
				startGame = 0;
				drawWelcome = 1;
				nextState <= place_ships;
			end
			
			place_ships: begin
				placeShips = 1;
				drawWelcome = 0;
				nextState <= start_game;
			end
			
			start_game: begin
				placeShips = 0;
				drawWelcome = 0;
				startGame = 1;
			end
			
			default: nextState = welcome; 
			
		endcase
	end
	
	always@(negedge ~KEY[0]) begin
		currState = nextState;
	end
endmodule