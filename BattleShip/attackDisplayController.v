module DisplayController(
input [3:0] x, y,
input isPlayer1,isPlayer2, attackTypePlayer1,attackTypePlayer2,
input attackDisplayControl,
 output reg[7:0]posXout,
 output reg[7:0]posYout,
 output reg[2:0]colourOut,
 input ResetN,clk, input [1:0] whoWon, input drawWelcome, input startFSM);
 
 reg [1:0] placeShips;
 always@(posedge clk) begin
		placeShips = 2'b0;
		end
 
 reg [3:0] squarecounter;
 reg [3:0] xReg, yReg;
 reg isPlayer1register,isPlayer2register, attackTypePlayer1register,attackTypePlayer2register;
 
 wire [2:0] colour1;
 wire [7:0] xw1;
 wire [6:0] yw1;
 reg start1;
 
 wire [2:0] colour2;
 wire [7:0] xw2;
 wire [6:0] yw2;
 reg start2;
 
 wire [2:0] colourG;
 wire [7:0] xg;
 wire [6:0] yg;
 reg startG;
 
 winning_first d1(clk, start1, xw1, yw1, ResetN, colour1);
 winning_second d2(clk, start2, xw2, yw2, ResetN, colour2);
 game_background d3(clk, startG, xg, yg, ResetN, colourG);
 
 always@(*) begin
	xReg = x;
	yReg = y;
	isPlayer1register = isPlayer1;
	isPlayer2register = isPlayer2;
	attackTypePlayer1register = attackTypePlayer1;
	attackTypePlayer2register = attackTypePlayer2;
end
	 //Changing posXout, posYout and color draws a pixel on the screen.
always@(posedge clk) begin
	 
	 if (drawWelcome == 1 && placeShips == 0) begin 
	 	startG <= 1;
		posXout <= xg;
		posYout <= yg;
		colourOut <= colourG;
	 end
	 else if (drawWelcome == 0 && placeShips == 1) begin
	   posXout <= 90 + squarecounter[1:0] + xReg*5;
		posYout <= 36 + squarecounter[3:2] + yReg*5;
		colourOut <= 3'b101;
	 end
	 else if (drawWelcome == 0 && placeShips == 2) begin
	 	startG <= 1;
		posXout <= xg;
		posYout <= yg;
		colourOut <= colourG;
	 end
	 else if (drawWelcome == 0 && placeShips == 3) begin
	 	posXout <= 26 + squarecounter[1:0] + xReg*5;
		posYout <= 36 + squarecounter[3:2] + yReg*5;
		colourOut <= 3'b101;
	 end	 
	 else if(startFSM == 1 && attackDisplayControl == 0 && whoWon == 0) begin
	   startG <= 1;
		posXout <= xg;
		posYout <= yg;
		colourOut <= colourG;
	 end
	 else if((attackDisplayControl == 1)&&(whoWon == 0)) begin
		
			if(isPlayer1register == 1'b1) begin
		  posXout <= 26 + squarecounter[1:0] + xReg*5;
		  posYout <= 36 + squarecounter[3:2] + yReg*5;
			  if(attackTypePlayer1register == 1'b0) colourOut <= 3'b001;
			  else colourOut <= 3'b100;
			
		  end
		  else if(isPlayer2register == 1'b1) begin
				posXout <= 90 + squarecounter[1:0] + xReg*5;
				posYout <= 36 + squarecounter[3:2] + yReg*5;
					if(attackTypePlayer2register == 1'b0) colourOut <= 3'b001;
		  else colourOut <= 3'b100;
		  end
		  
		  squarecounter <= squarecounter + 1;
		  
	 end
	 
	 else if ((attackDisplayControl == 0)&&(whoWon == 0)) begin
			posXout <= 0;
			posYout <= 0;
			colourOut <= 3'b001;
	 end
	 else if ((attackDisplayControl == 0)&&(whoWon == 2'b01))
	 begin
	   start1 <= 1;
		posXout <= xw1;
		posYout <= yw1;
		colourOut <= colour1;

	 end
	 else if((attackDisplayControl == 0)&&(whoWon == 2'b10))
	 begin
		start2 <= 1;
		posXout <= xw2;
		posYout <= yw2;
		colourOut <= colour2;
	 end
	 
	
	 
end
		//drawing d1(CLOCK_50, start, x, y, resetn, colour);		  
endmodule