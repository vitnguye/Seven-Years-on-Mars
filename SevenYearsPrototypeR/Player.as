package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import KeyObject;
	
	public class Player extends MovieClip{
		// References to the game 'stage' and the main game manager.
		public var	stageRef:Stage, mainRef:Main,
		// The screens to be displayed upon victory and loss.
					winScreen:WinScreen, loseScreen:LoseScreen,
		// A reference to this player's sanity bar.
					sanityBarRef:SanityBar,
		// A reference to the player's 'PlayerHand' object. This object will allow interaction with objects of
		//	the 'UseableObject' class that are within 5 pixels of the front of this player. 'Front' refers to
		//	this player's rotation, where an angle of zero has the front facing straight down.
					hand:PlayerHand,
		// Add this instance variable.
					key:KeyObject,
					
		// The player's location in the previous frame. Primarily used for collisions.
					prevX:int, prevY:int,
		// A boolean keeping track of whether or not this game is paused.
					pauseGame:Boolean,
		
		// Boolean variables that track whether or not their corresponding keyboard keys are currently pressed.
					leftPressed:Boolean, rightPressed:Boolean,
					upPressed:Boolean, downPressed:Boolean,
					spacePressed:Boolean,
					rReleased:Boolean, pReleased:Boolean, mReleased:Boolean, qReleased:Boolean,
		// The player's movement speed (in pixels per frame).
					speed:Number,
		// The number of frames left until this player can open a door again.
					doorCooldown:Number,
		// The player's current sanity value and how much of it is lost every frame.
					sanity:Number, sanityLossRate:Number,
		// Time remaining until victory and the time the player needs to survive to win (both in frames).
					timeRemaining:int, timeUntilWin:int,
		
		// The location and size of the game screen the player is allowed to move in.
		//	Width: 378, X: 410. What is this note for?
					screenX:Number, screenY:Number,
					screenWidth:Number, screenHeight:Number,
		// Half the player's width and height. Saving this saves on math.
					halfWidth:Number, halfHeight:Number;
		
		// Constructor.
		public function Player(stageRef_:Stage, mainRef_:Main, sanitybar:SanityBar):void{
			this.stageRef = stageRef_;
			this.mainRef = mainRef_;
			this.sanityBarRef = sanitybar;
			winScreen = new WinScreen(400, 300); loseScreen = new LoseScreen(400, 300);
			
			// Instantiate "key" by passing it a reference to the stage.
			key = new KeyObject(stageRef);
			
			setDifficulty("normal");
			restart();
			
			// Add the listener allowing this component to update.
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		public function restart():void{
			prevX = 0; prevY = 0;
			this.visible = true;
			pauseGame = false;
			
			halfWidth = this.width*0.5;
			halfHeight = this.height*0.5;
			
			leftPressed = false; rightPressed = false;
			upPressed = false; downPressed = false;
			spacePressed = false;
			rReleased = false; pReleased = false; mReleased = false; qReleased = false;
			
			speed = 5;
			doorCooldown = 0;
			sanity = 100;
			timeRemaining = 0;
			
			screenX = 0; screenY = 100;
			screenWidth = 800; screenHeight = 500;
			
			this.hand = new PlayerHand(x, y);
			stageRef.addChild(hand);
			this.gotoAndStop("right");
			
			// Frames until victory.
			timeRemaining = timeUntilWin;
			winScreen.visible = false; loseScreen.visible = false;
		}
		public function loop(e:Event):void{
			// Check if the 'Q' key is pressed: if it is, go to the main menu.
			if(qReleased && key.isDown(81)){
				qReleased = false;
				mainRef.goToMainMenu();
				pauseGame = true;
			}
			else if(!key.isDown(81)){ qReleased = true; }
			// Check if the 'M' key is pressed: if it is, mute/unmute the game.
			if(mReleased && key.isDown(77)){ mReleased = false; mainRef.toggleMusic(); }
			else if(!key.isDown(77)){ mReleased = true; }
			// Do nothing in this class after this point if in the menu.
			if(mainRef.mainMenu.visible){ return; }
			
			// Check if the 'R' key is pressed: if it is, restart the game.
			if(rReleased && key.isDown(82)){ rReleased = false; mainRef.restart(); }
			else if(!key.isDown(82)){ rReleased = true; }
			// Check if the 'P' key is pressed: if it is, pause/unpause the game.
			if(pReleased && key.isDown(80)){ pReleased = false; pauseGame = !pauseGame; }
			else if(!key.isDown(80)){ pReleased = true; }
			
			if(!visible || pauseGame){ return; }
			prevX = x; prevY = y;
			// Make the player show in front of everything else.
			hand.parent.setChildIndex(hand, hand.parent.numChildren-1);
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			
			checkControls();
			
			// Move the player according to arrow key presses.
			if(leftPressed){
				shiftPlayerX(-speed);
				this.gotoAndStop("walkLeft");
				rotate(Math.PI);
			}
			else if(rightPressed){
				shiftPlayerX(speed);
				this.gotoAndStop("walkRight");
				rotate(0);
			}
			if(upPressed){
				shiftPlayerY(-speed);
				this.gotoAndStop("walkUp");
				rotate(Math.PI*0.5);
			}
			else if(downPressed){
				shiftPlayerY(speed);
				this.gotoAndStop("walkDown");
				rotate(Math.PI*1.5);
			}
			// Rotate correctly for diagonal movement.
			if(upPressed){
				if(rightPressed){ this.gotoAndStop("walkUpRight"); rotate(Math.PI*0.25); }
				else if(leftPressed){ this.gotoAndStop("walkUpLeft"); rotate(Math.PI*0.75); }
			}
			else if(downPressed){
				if(rightPressed){ this.gotoAndStop("walkDownRight"); rotate(Math.PI*1.75); }
				else if(leftPressed){ this.gotoAndStop("walkDownLeft"); rotate(Math.PI*1.25); }
			}
			// Set player animation to idle if they have not moved.
			if(!leftPressed && !rightPressed && !upPressed && !downPressed){
				switch(hand.rotation + 90){
					case 180: this.gotoAndStop("left"); break;
					case 0: this.gotoAndStop("right"); break;
					case 90: this.gotoAndStop("up"); break;
					case 270: this.gotoAndStop("down"); break;
					
					case 45: this.gotoAndStop("upRight"); break;
					case 135: this.gotoAndStop("upLeft"); break;
					case 315: this.gotoAndStop("downRight"); break;
					case 225: this.gotoAndStop("downLeft"); break;
					default: break;
				}
			}
			
			// Stop the player from moving off-screen.
			// Stop the player from going above the stage.
			if(y < (screenY + halfHeight)){
				movePlayerY(screenY + halfHeight);
			}
			// Stop the player from going below the stage.
			if(y > (screenY + screenHeight - halfHeight)){
				movePlayerY(screenY + screenHeight - halfHeight);
			}
			// Stop the player from going left of the stage.
			if(x < (screenX + halfWidth)){
				movePlayerX(screenX + halfWidth);
			}
			// Stop the player from going right of the stage.
			if(x > (screenX + screenWidth - halfWidth)){
				movePlayerX(screenX + screenWidth - halfWidth);
			}
			
			// Decrease player sanity.
			sanity -= sanityLossRate;
			if(sanity < 0){ sanity = 0; }
			else if(sanity > 100){ sanity = 100; }
			sanityBarRef.updateSanityBar(sanity);
			
			if(sanity <= 0){ lose(); return; }
			--timeRemaining;
			if(timeRemaining <= 0){ win(); return; }
			
			// Handle door logic.
			--doorCooldown;
			if(doorCooldown < 0){ doorCooldown = 0; }
			for(var i:int = 0; i < mainRef.doors.length; ++i){
				doorUpdate(mainRef.doors[i]);
			}
		}
		public function doorUpdate(door:Door):void{
			if(door.visible && (doorCooldown == 0)){
				door.gotoAndStop("available");
				// Constantly check for collision with the player's hand when the player is attempting interaction.
				if(spacePressed && hand.hitTestObject(door)){
					doorCooldown = 60;
					door.openDoor();
				}
			}
			else{ door.gotoAndStop("cooldown"); }
		}
		public function win():void{
			this.visible = false;
			if(winScreen.parent == stage){ stage.removeChild(winScreen); }
			stage.addChild(winScreen);
			winScreen.visible = true;
			spacePressed = false;
		}
		public function lose():void{
			this.visible = false;
			// Calculate time survived as a portion of seven years.
			var	years:Number = ((timeUntilWin - timeRemaining)*7)/timeUntilWin,
				months:Number = (years%1)*12,
				weeks:Number = (months%1)*4,
				days:Number = (weeks%1)*7,
				hours:Number = (days%1)*24,
				minutes:Number = (hours%1)*60,
				seconds:Number = (minutes%1)*60,
				
				timeSurvived:String = "",
				descriptors:int = 0,
				firstDescriptor:Boolean = true;
			
			years = (int)(years); if(years != 0){ ++descriptors; }
			months = (int)(months); if(months != 0){ ++descriptors; }
			weeks = (int)(weeks); if(weeks != 0){ ++descriptors; }
			days = (int)(days); if(days != 0){ ++descriptors; }
			hours = (int)(hours); if(hours != 0){ ++descriptors; }
			minutes = (int)(minutes); if(minutes != 0){ ++descriptors; }
			seconds = (int)(seconds); if(seconds != 0){ ++descriptors; }
			if(descriptors == 1){ descriptors = 0; }
			
			if(years != 0){
				--descriptors;
				
				timeSurvived += years;
				if(years != 1){ timeSurvived += " years"; }
				else{ timeSurvived += " year"; }
				firstDescriptor = false;
			}
			if(months != 0){
				--descriptors;
				if(!firstDescriptor){
					timeSurvived += ", ";
					if(descriptors == 0){ timeSurvived += "and "; }
				}
				timeSurvived += months;
				if(months != 1){ timeSurvived += " months"; }
				else{ timeSurvived += " month"; }
				firstDescriptor = false;
			}
			if(weeks != 0){
				--descriptors;
				if(!firstDescriptor){
					timeSurvived += ",\n";
					if(descriptors == 0){ timeSurvived += "and "; }
				}
				timeSurvived += weeks;
				if(weeks != 1){ timeSurvived += " weeks"; }
				else{ timeSurvived += " week"; }
				firstDescriptor = false;
			}
			if(days != 0){
				--descriptors;
				if(!firstDescriptor){
					timeSurvived += ", ";
					if(descriptors == 0){ timeSurvived += "and "; }
				}
				timeSurvived += days;
				if(days != 1){ timeSurvived += " days"; }
				else{ timeSurvived += " day"; }
				firstDescriptor = false;
			}
			if(hours != 0){
				--descriptors;
				if(!firstDescriptor){
					timeSurvived += ",\n";
					if(descriptors == 0){ timeSurvived += "and "; }
				}
				timeSurvived += hours;
				if(hours != 1){ timeSurvived += " hours"; }
				else{ timeSurvived += " hour"; }
				firstDescriptor = false;
			}
			if(minutes != 0){
				--descriptors;
				if(!firstDescriptor){
					timeSurvived += ", ";
					if(descriptors == 0){ timeSurvived += "and "; }
				}
				timeSurvived += minutes;
				if(minutes != 1){ timeSurvived += " minutes"; }
				else{ timeSurvived += " minute"; }
				firstDescriptor = false;
			}
			if(seconds != 0){
				--descriptors;
				if(!firstDescriptor){
					timeSurvived += ", ";
					if(descriptors == 0){ timeSurvived += "and "; }
				}
				timeSurvived += seconds;
				if(seconds != 1){ timeSurvived += " seconds"; }
				else{ timeSurvived += " second"; }
				firstDescriptor = false;
			}
			loseScreen.timespanInfo.text = "You have survived " + timeSurvived + ".";
			if(loseScreen.parent == stage){ stage.removeChild(loseScreen); }
			stage.addChild(loseScreen);
			loseScreen.visible = true;
			spacePressed = false;
		}
		public function setDifficulty(difficulty:String){
			switch(difficulty){
				case "easy":
					sanityLossRate = 0.05;
					timeUntilWin = 7020;
					break;
				case "normal":
					sanityLossRate = 0.15;
					timeUntilWin = 7020;
					break;
				case "hard":
					sanityLossRate = 0.16;
					timeUntilWin = 9000;
					break;
				case "nightmare":
					sanityLossRate = 0.2;
					timeUntilWin = 12000;
					break;
				default:
					sanityLossRate = 1.0;
					timeUntilWin = 12000;
					break;
			}
		}
		public function checkControls():void{
			// I used http://www.dakmm.com/?p=272 as a reference to get the keyCode numbers for each key.
			// Check if the left arrow key or 'A' are pressed:
			if(key.isDown(37) || key.isDown(65)){ leftPressed = true; }
			else{ leftPressed = false; }
			// Check if the up arrow key or 'W' are pressed:
			if(key.isDown(38) || key.isDown(87)){ upPressed = true; }
			else{ upPressed = false; }
			// Check if the right arrow key or 'D' are pressed:
			if(key.isDown(39) || key.isDown(68)){ rightPressed = true; }
			else{ rightPressed = false; }
			// Check if the down arrow key or 'S' are pressed:
			if(key.isDown(40) || key.isDown(83)){ downPressed = true; }
			else{ downPressed = false; }
			// Check if the spacebar key is pressed:
			if(key.isDown(32)){ spacePressed = true; }
			else{ spacePressed = false; }
		}
		public function rotate(angle:Number):void{
			var angleDegrees:int = (angle*180)/Math.PI;
			if(hand.rotation == (angleDegrees - 90)){ return; }
			
			var	w:Number = width*0.5, h:Number = height*0.5, dirLength = Math.pow((w*w + h*h), 0.5);
			halfWidth = w*Math.cos(angle);
			halfHeight = h*Math.sin(angle);
			
			hand.x = x + halfWidth; hand.y = y - halfHeight;
			hand.stretch(dirLength*0.95, 20);
			hand.rotation = angleDegrees - 90;
			
			halfWidth = Math.abs(halfWidth); halfHeight = Math.abs(halfHeight);
		}
		public function shiftPlayer(X:int, Y:int){
			x += X; y += Y;
			hand.x += X; hand.y += Y;
		}
		public function shiftPlayerX(X:int){ shiftPlayer(X, 0); }
		public function shiftPlayerY(Y:int){ shiftPlayer(0, Y); }
		public function movePlayer(X:int, Y:int){ shiftPlayer(X - x, Y - y); }
		public function movePlayerX(X:int){ shiftPlayer(X - x, 0); }
		public function movePlayerY(Y:int){ shiftPlayer(0, Y - y); }
	}
}