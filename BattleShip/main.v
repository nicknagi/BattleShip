module main(SW, KEY, CLOCK_50, LEDR, HEX0, HEX1, HEX5, HEX4, HEX3, HEX2, 
  	PS2_CLK,
	PS2_DAT,
  VGA_CLK,         // VGA Clock
  VGA_HS,       // VGA H_SYNC
  VGA_VS,       // VGA V_SYNC
  VGA_BLANK_N,      // VGA BLANK
  VGA_SYNC_N,      // VGA SYNC
  VGA_R,         // VGA Red[9:0]
  VGA_G,        // VGA Green[9:0]
  VGA_B);      // VGA Blue[9:0]);


	// Bidirectionals for keyboard module
	 inout				PS2_CLK;
	 inout				PS2_DAT;
	
	//Variables for keyboard
	 wire 		[7:0]	last_data_received;
	 wire ps2_key_pressed;
  
	//General variables to interface with the FPGA
	 input [9:0] SW;
    input [7:0] KEY;
    output [9:0] LEDR;
    output [6:0] HEX0,HEX1,HEX5, HEX4,HEX3, HEX2;
	 
	 //Wire to hold memory outputs
	 wire [9:0] memOut1 , memOut2;
	 
	 //Memory address output by the Turn Based gameplay controller based on FSM logic
	 reg [3:0] posY1, posY2;
	 wire [3:0] toposY1, toposY2;
	 
	 always@(*) begin
		posY1 <= toposY1;
		posY2 <= toposY2;
	 end
		
	 
	 //Essential variables for RAM modules
	 wire writeEnTallyb1, writeEnTallyb2;
	 wire [19:0] dataInTallyb1, dataInTallyb2;
	 wire [19:0] dataOutTallyb1, dataOutTallyb2;
	 wire [3:0] addressTallyb1, addressTallyb2;
	 
	 
	 wire displayControl;
	 wire [1:0] whoWon;
	 wire startFSM, drawWelcome, placeShips;
	 
	 mainFSM fsm(startFSM, KEY, drawWelcome, placeShips);
	 
	 //Instantiation of gameplay module
	 TurnBasedGameplayController controller2( 
	 .memOut1(memOut1) , .memOut2(memOut2),
	 .writeEnTallyb1(writeEnTallyb1), .writeEnTallyb2(writeEnTallyb2),
	 .dataInTallyb1(dataInTallyb1), .dataInTallyb2(dataInTallyb2),
	 .dataOutTallyb1(dataOutTallyb1), .dataOutTallyb2(dataOutTallyb1),
	 .addressTallyb1(addressTallyb1), .addressTallyb2(addressTallyb2),
	 .toposY1(toposY1),.toposY2(toposY2),
	 .LEDR(LEDR), .kbdOut(SW[7:0]), .KEY(KEY), .HEX0(HEX0), .HEX1(HEX1),
	 .drawX(drawX),.drawY(drawY),.isPlayer1(isPlayer1),.isPlayer2(isPlayer2), .attackTypePlayer1(attackTypePlayer1),.attackTypePlayer2(attackTypePlayer2)
	 ,.displayControl(displayControl), .whoWon(whoWon), .startFSM(startFSM)
	
	 ); 
	 
	 //more definitions for VGA and keyboard
	 input   CLOCK_50;    // 50 MHz
 
	 output   VGA_CLK;       // VGA Clock
	 output   VGA_HS;     // VGA H_SYNC
	 output   VGA_VS;     // VGA V_SYNC
	 output   VGA_BLANK_N;    // VGA BLANK
	 output   VGA_SYNC_N;    // VGA SYNC
	 output [9:0] VGA_R;       // VGA Red[9:0]
	 output [9:0] VGA_G;      // VGA Green[9:0]
	 output [9:0] VGA_B;       // VGA Blue[9:0]

	

	 //Declaring memory to be used to store tally boards and the boards containing ship locations
	 BoardTallyMap tallyb1(addressTallyb1,CLOCK_50,dataInTallyb1,writeEnTallyb1,dataOutTallyb1);
	 
	 BoardTallyMap tallyb2(addressTallyb2,CLOCK_50,dataInTallyb2,writeEnTallyb2,dataOutTallyb2);
	 
	 User1BoardMap b1(posY1[3:0],CLOCK_50,0,0,memOut1[9:0]);
	 
	 User2BoardMap b2(posY2[3:0],CLOCK_50,0,0,memOut2[9:0]);
	 
	 
	
  
  // image file (.MIF) for the controller.
 vga_adapter VGA(
   .resetn(resetn),
   .clock(CLOCK_50),
   .colour(colour),
   .x(x),
   .y(y),
   .plot(writeEn), //ACTIVE LOW
   /* Signals for the DAC to drive the monitor. */
   .VGA_R(VGA_R),
   .VGA_G(VGA_G),
   .VGA_B(VGA_B),
   .VGA_HS(VGA_HS),
   .VGA_VS(VGA_VS),
   .VGA_BLANK(VGA_BLANK_N),
   .VGA_SYNC(VGA_SYNC_N),
   .VGA_CLK(VGA_CLK));
  defparam VGA.RESOLUTION = "160x120";
  defparam VGA.MONOCHROME = "FALSE";
  defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
  defparam VGA.BACKGROUND_IMAGE = "initial_screen.mif";
  
  wire resetn;
  assign resetn = KEY[7];
 
 //colour, x, y and writeEn wires that are inputs to the attack display controller which allows for drawing on VGA.

  wire [2:0] colour;
  wire [7:0] x;
  wire [7:0] y;
  wire writeEn;
  //parameter [1:0] led;
  assign writeEn = KEY[1]; //enables plotting, ACTIVE LOW
 
  wire [3:0] drawX, drawY;
  wire isPlayer1,isPlayer2, attackTypePlayer1,attackTypePlayer2;
 
  DisplayController controller1(drawX,drawY,isPlayer1,isPlayer2, attackTypePlayer1,attackTypePlayer2
  , displayControl,x,y,colour,resetn,CLOCK_50, whoWon, drawWelcome, startFSM);
	 
Keyboard kbd(
	// Inputs
	CLOCK_50,
	KEY,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
	HEX2,
	HEX3,
	kbdOut[7:4],
	kbdOut[3:0],
	last_data_received,
	ps2_key_pressed
);

	wire [7:0] kbdOut;
	
hex_decoder Segment2 (
	.hex_digit			(kbdOut[3:0]),
	.segments	(HEX4)
);

hex_decoder Segment3 (
	.hex_digit			(kbdOut[7:4]),
	.segments	(HEX5)
);
//
//reg trigger;
//wire trigger_wire;
//assign trigger_wire = trigger;

//
//always @(last_data_received)
//begin
//	if ((last_data_received == 8'b01011010)&&(ps2_key_pressed==1))
//		begin
//		trigger <= 1'b0;
//		end
//	else 
//		begin
//		trigger <= 1'b1;
//	end
//		
//end

endmodule


