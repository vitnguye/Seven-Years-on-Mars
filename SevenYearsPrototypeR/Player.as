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
		
		// Boolean variables that track whether or not their corresponding keyboard keys are currently pressed.
					leftPressed:Boolean, rightPressed:Boolean,
					upPressed:Boolean, downPressed:Boolean,
					spacePressed:Boolean,
		
		//Boolean variables to keep track of the direction the player is facing(serves as pseudo-key-release variables).
					facingLeft:Boolean, facingRight:Boolean,
					facingUp:Boolean, facingDown:Boolean,
		
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
			
			restart();
			
			// Add the listener allowing this component to update.
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		public function restart():void{
			prevX = 0; prevY = 0;
			this.visible = true;
			
			halfWidth = this.width*0.5;
			halfHeight = this.height*0.5;
			
			leftPressed = false; rightPressed = false;
			upPressed = false; downPressed = false;
			spacePressed = false;
			facingLeft = false; facingRight = false;
			facingUp = false; facingDown = false;
			
			speed = 5;
			doorCooldown = 0;
			sanity = 100; sanityLossRate = 0.13;
			timeRemaining = 0; timeUntilWin = 7500;
			
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
			// Check if the 'R' key is pressed:
			if(key.isDown(82)){ mainRef.restart(); }
			
			if(!visible){ return; }
			prevX = x; prevY = y;
			// Make the player show in front of everything else.
			hand.parent.setChildIndex(hand, hand.parent.numChildren-1);
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			
			checkKeypresses();
			
			// Move the player according to arrow key presses.
			if(leftPressed){
				facingDown = false;
				facingUp = false;
				facingLeft = true;
				facingRight = false;
				shiftPlayerX(-speed);
				this.gotoAndStop("left");
				rotatePlayer(Math.PI);
			}
			else if(rightPressed){
				facingDown = false;
				facingUp = false;
				facingLeft = false;
				facingRight = true;
				shiftPlayerX(speed);
				this.gotoAndStop("right");
				rotatePlayer(0);
			}
			if(upPressed){
				facingDown = false;
				facingUp = true;
				facingLeft = false;
				facingRight = false;
				shiftPlayerY(-speed);
				this.gotoAndStop("walkup");
				rotatePlayer(Math.PI*0.5);
			}
			else if(downPressed){
				facingDown = true;
				facingUp = false;
				facingLeft = false;
				facingRight = false;
				shiftPlayerY(speed);
				this.gotoAndStop("down");
				rotatePlayer(Math.PI*1.5);
			}
			// Rotate correctly for diagonal movement.
			if(upPressed){
				if(rightPressed){ this.gotoAndStop("upRight"); rotatePlayer(Math.PI*0.25); }
				else if(leftPressed){ this.gotoAndStop("upLeft"); rotatePlayer(Math.PI*0.75); }
			}
			else if(downPressed){
				if(rightPressed){ this.gotoAndStop("downRight"); rotatePlayer(Math.PI*1.75); }
				else if(leftPressed){ this.gotoAndStop("downLeft"); rotatePlayer(Math.PI*1.25); }
			}
			
			//tests for changing to idle sprite when no button is pressed
			if(facingRight && !rightPressed && !leftPressed && !upPressed && !downPressed){
				this.gotoAndStop("right");
			}
			if(facingLeft && !rightPressed && !leftPressed && !upPressed && !downPressed){
				this.gotoAndStop("left");
			}
			if(facingUp && !rightPressed && !leftPressed && !upPressed && !downPressed){
				this.gotoAndStop("up");
			}
			if(facingDown && !rightPressed && !leftPressed && !upPressed && !downPressed){
				this.gotoAndStop("down");
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
		public function checkKeypresses():void{
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
		public function rotatePlayer(angle:Number):void{
			var angleDegrees:int = (angle*180)/Math.PI;
			if(hand.rotation == angleDegrees){ return; }
			
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