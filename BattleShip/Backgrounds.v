module winning_first (CLOCK_50, start, x, y, resetn, colour_wire);
input CLOCK_50;
input start;
output [7:0] x;
output [6:0] y;
output [2:0] colour_wire;
input resetn;

reg [2:0] colour;
reg done;
assign colour_wire = colour;

wire [2:0] outRAM;

win1st win(
.address(address),
.clock(CLOCK_50),
.q(outRAM));

reg [14:0] xy;
assign y = xy [6:0];
assign x = xy [14:7];
reg [7:0] x_reg;
reg [6:0] y_reg;

reg [2:0] colour_reg;
reg [7:0] temp_x;
reg [6:0] temp_y;
reg [14:0] temp_xy;
reg [14:0] counter;


wire [7:0] bitx;
wire [6:0] bity;
assign bitx = xy[14:7];
assign bity = xy[6:0];
wire [14:0] address;
assign address = bity * 160 + bitx;

always@(posedge CLOCK_50, negedge resetn) begin
  if (!resetn) begin
   x_reg <= 8'd0;
   y_reg <= 7'd0;
   colour_reg <= 3'b0;
  end
  else if (start == 1'b1) begin
 
   if ( x_reg != 8'd159) begin
     x_reg = x_reg + 8'd1;
   end
   else begin
    
     x_reg = 8'd0;
   
    if (y_reg != 7'd119)begin
       y_reg = y_reg + 7'd1;
    end
  
    else begin 
        x_reg <= 8'd0;
        y_reg <= 7'd0;
    end
   end
  end
 end

  
 always @(posedge CLOCK_50) begin
   if (!resetn) begin
    counter <= 16'd0;
   end
   else if (counter == 16'd38400) begin
    counter <= 16'd0;
   end
   if (start == 1'b1) begin
		counter <= counter + 16'd1;
	end
  end

always @(*) begin
   if (!resetn)begin
    done <= 0;
   end 
   else
    done = (counter == 16'd38400);
  end
  
always @(*)
  begin
     temp_xy = {{x_reg}, {y_reg}};
 end
 
 
 // Output result register
 always@(posedge CLOCK_50) begin
  if (!resetn) begin
   xy <= 15'b0; 
   colour <= 3'b0; 
  end
  else begin
   xy <= temp_xy;
   colour[2:0] <= outRAM [2:0];
  end
 end
 
endmodule

module winning_second (CLOCK_50, start, x, y, resetn, colour_wire);
input CLOCK_50;
input start;
output [7:0] x;
output [6:0] y;
output [2:0] colour_wire;
input resetn;

reg [2:0] colour;
reg done;
assign colour_wire = colour;

wire [2:0] outRAM;

win2nd win2(
.address(address),
.clock(CLOCK_50),
.q(outRAM));

reg [14:0] xy;
assign y = xy [6:0];
assign x = xy [14:7];
reg [7:0] x_reg;
reg [6:0] y_reg;

reg [2:0] colour_reg;
reg [7:0] temp_x;
reg [6:0] temp_y;
reg [14:0] temp_xy;
reg [14:0] counter;


wire [7:0] bitx;
wire [6:0] bity;
assign bitx = xy[14:7];
assign bity = xy[6:0];
wire [14:0] address;
assign address = bity * 160 + bitx;

always@(posedge CLOCK_50, negedge resetn) begin
  if (!resetn) begin
   x_reg <= 8'd0;
   y_reg <= 7'd0;
   colour_reg <= 3'b0;
  end
  else if (start == 1'b1) begin
 
   if ( x_reg != 8'd159) begin
     x_reg = x_reg + 8'd1;
   end
   else begin
    
     x_reg = 8'd0;
   
    if (y_reg != 7'd119)begin
       y_reg = y_reg + 7'd1;
    end
  
    else begin 
        x_reg <= 8'd0;
        y_reg <= 7'd0;
    end
   end
  end
 end

  
 always @(posedge CLOCK_50) begin
   if (!resetn) begin
    counter <= 16'd0;
   end
   else if (counter == 16'd38400) begin
    counter <= 16'd0;
   end
   if (start == 1'b1) begin
		counter <= counter + 16'd1;
	end
  end

always @(*) begin
   if (!resetn)begin
    done <= 0;
   end 
   else
    done = (counter == 16'd38400);
  end
  
always @(*)
  begin
     temp_xy = {{x_reg}, {y_reg}};
 end
 
 
 // Output result register
 always@(posedge CLOCK_50) begin
  if (!resetn) begin
   xy <= 15'b0; 
   colour <= 3'b0; 
  end
  else begin
   xy <= temp_xy;
   colour[2:0] <= outRAM [2:0];
  end
 end
 
 
endmodule

	
module game_background (CLOCK_50, start, x, y, resetn, colour_wire);
input CLOCK_50;
input start;
output [7:0] x;
output [6:0] y;
output [2:0] colour_wire;
input resetn;

reg [2:0] colour;
reg done;
assign colour_wire = colour;

wire [2:0] outRAM;

two_boards win(
.address(address),
.clock(CLOCK_50),
.q(outRAM));

reg [14:0] xy;
assign y = xy [6:0];
assign x = xy [14:7];
reg [7:0] x_reg;
reg [6:0] y_reg;

reg [2:0] colour_reg;
reg [7:0] temp_x;
reg [6:0] temp_y;
reg [14:0] temp_xy;
reg [14:0] counter;


wire [7:0] bitx;
wire [6:0] bity;
assign bitx = xy[14:7];
assign bity = xy[6:0];
wire [14:0] address;
assign address = bity * 160 + bitx;

always@(posedge CLOCK_50, negedge resetn) begin
  if (!resetn) begin
   x_reg <= 8'd0;
   y_reg <= 7'd0;
   colour_reg <= 3'b0;
  end
  else if (start == 1'b1) begin
 
   if ( x_reg != 8'd159) begin
     x_reg = x_reg + 8'd1;
   end
   else begin
    
     x_reg = 8'd0;
   
    if (y_reg != 7'd119)begin
       y_reg = y_reg + 7'd1;
    end
  
    else begin 
        x_reg <= 8'd0;
        y_reg <= 7'd0;
    end
   end
  end
 end

  
 always @(posedge CLOCK_50) begin
   if (!resetn) begin
    counter <= 16'd0;
   end
   else if (counter == 16'd38400) begin
    counter <= 16'd0;
   end
   if (start == 1'b1) begin
		counter <= counter + 16'd1;
	end
  end

always @(*) begin
   if (!resetn)begin
    done <= 0;
   end 
   else
    done = (counter == 16'd38400);
  end
  
always @(*)
  begin
     temp_xy = {{x_reg}, {y_reg}};
 end
 
 
 // Output result register
 always@(posedge CLOCK_50) begin
  if (!resetn) begin
   xy <= 15'b0; 
   colour <= 3'b0; 
  end
  else begin
   xy <= temp_xy;
   colour[2:0] <= outRAM [2:0];
  end
 end
 
endmodule




	


