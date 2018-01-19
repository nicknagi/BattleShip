# Epic-Space-Battleship
The follwing project is done as a part of ECE 241 course offered by the University of Toronto. It is done in a team of two by Polina Govorkova and Nekhil Nagia (https://github.com/nicknagi), where the work was distributed and performed equally by both teammates.

Modules PS2_Controller, Altera_UP_PS2_Data_In, Altera_UP_PS2_Command_Out, vga_adapter, vga_pill, vga_controller and vga_address_translator were provided by the instructors of the course and are not discussed in the following description.
## Introduction
#### Description of the game
The project is a custom interpretation of the game “Battleship”. It is a guessing game between two players, where each player’s objective is to find the locations of the opponent’s ships. The ships are placed on 10x10 boards, one for each player. Players alternate turns to “shoot” at each other’s boards, until the first fleet is drowned.
Our custom version transfers the battle into space and gives the second player equal advantage. In the original game the amount of ships each player has is equal and the first player has a competitive advantage of shooting first. Therefore, if the first player wins, the total shots made are greater than that of  player two. To eliminate this unfair advantage, player two is allowed to enter an additional ship that would require an additional turn to drown.
#### Motivation
Verilog is a new toolset for us both. Making ourselves familiar with software mediums, we got used to thinking in terms of parameters and variables without relying on physical meaning and physical abilities of the system. We believe it is crucial to expand our knowledge in this area to succeed in both working with hardware and software, and this project became a great opportunity to do so.
As for the choice of the game, both of us had a great time in school during our childhood playing “paper games” between classes. It turned out we both absolutely admire Battleship, and therefore, we decided to create this game not only for the ECE241 project but also as a tribute to the nostalgic memories from school days.
#### Goals of the project
Taking the original game as a sample to follow, our initial outlook for the game had the following elements:
The users are greeted by a welcome screen outlining the name of the game. The user can then proceed to start the game.
The users are then greeted by a screen where they can place their ships, taking turns to do so.
Then, the users can start playing the game by selecting coordinates on the board to target. The screen has two separate boards representing the two players. If a user hits the grid is lit up by a red pixel otherwise a blue pixel represents a miss. Players keep taking turns until a winner is determined.
Once a winner is determined, a ‘victory’ screen is shown outlining the player that won.
The users can then restart the game.
As for the add ons, we decided we would interface with the keyboard to allow the user to select the coordinates as well as the screen to display the graphics. Additional add ons, if time permitted would have been implementing an AI system allowing the user to play with the computer, using sound as one of the outputs and adding dynamic graphics.
## The Design
#### Module main
This module contains all the module and  memory declarations as well as all the wire instantiations connecting all the modules in an appropriate manner;
#### Module mainFSM
This module contains the FSM controlling the whole game ie contains the possible states the game can be in any given moment in time. The states are welcome screen, ship placement, gameplay and the endgame. Each of the substates have their own control logic. Also, to allow dynamic control of several FSMs involved in the project, the main FSM sends out handshake signals triggering the other FSMs. 
#### Module Turn Based Controller
This module contains the functionality to allow for the ‘turn based’ gameplay to occur.  It contains all the necessary interfacing to communicate with the other modules, mainly the display controller. The module has an FSM which dictates which player’s turn it is as well as constantly checking to determine if someone won. After each player’s turn, the appropriate memory map is also updated and once an endgame has been reached the FSM sends a handshake signal to the main FSM to allow for the continuation of the game. 
#### Module Display Controller
This module controls the coordinates of a pixel and its colour to be displayed via vga_controller module depending on the game state (vga_controller module is not listed in this section due to the fact that it was fully provided by the course authorities and the file hasn’t been changed). 
The Display Controller receives the inputs from the Main FSM that allow it to determines the state of the game. Within the state it controls the assignment of colour, x and y values: if player places a ship or hits a spot on the battlefield, a square of the corresponding colour is displayed using a counter within the module. Otherwise a certain picture is displayed using separate modules winning_first, winning_second or game_background.
Background: modules winning_first, winning_second and game_background
The following modules are responsible for the display of a full screen image at certain state of the game. Module game_background displays the image of two ten by ten grids representing boards for each player. Modules winning_first and winning_secong display images congratulating the first and the second player with their victory respectively. 
Each of the modules takes “start” and “reset” as signals for action and outputs position of a pixel and the color of it to be displayed at a given point of time. All the values are set to zero if reset is active. Otherwise if start is active, the colour is determined by the Read-Only Memory blocks, each responsible for certain image. ROM chips receive memory from . mif files. The files are converted from Paint files of type .bmp using provided by the course converter. Each image has the properties of 3 in width, 19200 in depth (for 160 by 120 pixels screen). 
#### Module Keyboard
Module Keyboard interprets information received by module keyboard. Based on the information provided it recognizes, assigns and loads coordinates of x and y later to be used in placement of the ships and targeting the boards.
#### Module keyboard
The following module is a medium between modules Keyboard and PS2_controller (not listed in this section due to the fact that it was fully provided by the course authorities and the file hasn’t been changed). The module passes hexadecimal value of the keyboard key once the key is pressed.
#### Module hex_decoder
This module interprets 4 bits signal and displays the corresponding hexadecimal value on seven segment display.
## Report on Success
The final state of the project is a game, playable by two users. That obeys all the rules described in the introduction and displays the result of the game. The core of the game is implemented and the boards receive the data from user inputs, store information and appropriately respond to the attacks. Therefore, the users receive nice visuals and can play obeying the rules of the game.
In our final implementation of the game that was presented there were a few minor bugs such as whenever a user finished inputting their move the enter key as well as KEY[0] on the FPGA had to be pressed which could have been an inconvenience for the user. It happened due to the fact that keyboard was implemented mid-way of the project and later wasn’t always available during the development process. Therefore, we mainly used switches and keys while testing it. Doing final adjustments and revisions we couldn’t restore full functionality of the keyboard without interfering with the functionality of the game.
Another malfunctioning component was when a user would enter an already attacked spot again our implementation would accept it. To prevent this from happening we created two separate memory maps but due to lack of time we were not able to properly implement it without interfering with the proper functioning of the game. Barring these errors our project performed as intended and did not contain any further bugs.
