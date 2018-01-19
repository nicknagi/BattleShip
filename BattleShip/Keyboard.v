module Keyboard (
	// Inputs
	CLOCK_50,
	KEY,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
	HEX2,
	HEX3,
	XoutLoad,
	YoutLoad,
	last_data_received,
	ps2_key_pressed
);



output ps2_key_pressed;
input				CLOCK_50;
input		[3:0]	KEY;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

// Outputs
output		[6:0]	HEX2;
output		[6:0]	HEX3;

output 		[7:0]	last_data_received;
output reg		[3:0] XoutLoad;
output reg		[3:0] YoutLoad;

reg		[3:0] Xout;
reg		[3:0] Yout;

always @(posedge CLOCK_50)
begin
	if (last_data_received == 8'b01011010)
	begin
		XoutLoad <= Xout;
		YoutLoad <= Yout;
	end
	else if (last_data_received == 8'b00011100)
	begin
		Xout <= 4'h0; //A
	end
	else if (last_data_received == 8'b01000101)
	begin
		Yout <= 4'h0; //0
	end
	else if (last_data_received == 8'b00110010)
	begin
		Xout <= 4'h1; //B
	end
	else if (last_data_received == 8'b00010110)
	begin
		Yout <= 4'h1; //1
	end
		else if (last_data_received == 8'b00100001)
	begin
		Xout <= 4'h2; //C
	end
	else if (last_data_received == 8'b00011110)
	begin
		Yout <= 4'h2; //2
	end
	else if (last_data_received == 8'b00100011)
	begin
		Xout <= 4'h3; //D
	end
		else if (last_data_received == 8'b00100110)
	begin
		Yout <= 4'h3; //3
	end
	else if (last_data_received == 8'b00100100)
	begin
		Xout <= 4'h4; //E
	end
	else if (last_data_received == 8'b00100101)
	begin
		Yout <= 4'h4; //4
	end
		else if (last_data_received == 8'b00101011)
	begin
		Xout <= 4'h5; //F
	end
	else if (last_data_received == 8'b00101110)
	begin
		Yout <= 4'h5; //5
	end
	else if (last_data_received == 8'b00110100)
	begin
		Xout <= 4'h6; //G
	end
		else if (last_data_received == 8'b00110110)
	begin
		Yout <= 4'h6; //6
	end
	else if (last_data_received == 8'b00110011)
	begin
		Xout <= 4'h7; //H
	end
		else if (last_data_received == 8'b00111101)
	begin
		Yout <= 4'h7; //7
	end
	else if (last_data_received == 8'b01000011)
	begin
		Xout <= 4'h8; //I
	end
	else if (last_data_received == 8'b00111110)
	begin
		Yout <= 4'h8; //8
	end
		else if (last_data_received == 8'b00111011)
	begin
		Xout <= 4'h9; //J
	end
	else if (last_data_received == 8'b01000110)
	begin
		Yout <= 4'h9; //9
	end
end

keyboard k1(
		// Inputs
		.CLOCK_50(CLOCK_50),
		.KEY(KEY),

		// Bidirectionals
		.PS2_CLK(PS2_CLK),
		.PS2_DAT(PS2_DAT),

		// Outputs
		.last_data_received(last_data_received),
		.ps2_key_pressed(ps2_key_pressed)
		);

hex_decoder Segment2 (
	.hex_digit			(Xout[3:0]),
	.segments	(HEX2)
);

hex_decoder Segment3 (
	.hex_digit			(Yout[3:0]),
	.segments	(HEX3)
);
		
endmodule


module keyboard (
	// Inputs
	CLOCK_50,
	KEY,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
//	HEX0,
//	HEX1,
	last_data_received,
	 ps2_key_pressed
);

// Inputs
input				CLOCK_50;
input		[3:0]	KEY;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

// Outputs

output reg 		[7:0]	last_data_received;
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire		[7:0]	ps2_key_data;
output				ps2_key_pressed;


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge CLOCK_50)
begin
	if (KEY[0] == 1'b0)
		last_data_received <= 8'h00;
	else if ((ps2_key_pressed == 1'b1)&&(ps2_key_data!=8'h00))
		last_data_received <= ps2_key_data;
end

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

PS2_Controller PS2 (

	.CLOCK_50				(CLOCK_50),
	.reset				(~KEY[0]),

	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);

endmodule
