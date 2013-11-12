package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import KeyObject;
	
	public class Player extends MovieClip{
		// Create an instance variable for the stage reference.
		public var	stageRef:Stage,
		// A reference to this player's sanity bar.
					sanityBarRef:SanityBar,
		// A reference to the player's 'PlayerHand' object. This object will allow interaction with objects of
		//	the 'UseableObject' class that are within 5 pixels of the front of this player. 'Front' refers to
		//	this player's rotation, where an angle of zero has the front facing straight down.
					hand:PlayerHand,
		
		// Add this instance variable.
					key:KeyObject,
		
		// Boolean variables that track whether or not their corresponding keyboard keys are currently pressed.
					leftPressed:Boolean = false, rightPressed:Boolean = false,
					upPressed:Boolean = false, downPressed:Boolean = false,
					spacePressed:Boolean = false,
		// The player's movement speed (in pixels per frame).
					speed:Number = 5,
		// The player's current sanity value. The purpose of this game is to try and keep this as high as possible.
					sanity:Number = 100,
		// The location and size of the game screen the player is allowed to move in.
		//	Width: 378, X: 410. What is this note for?
					screenX:Number = 0, screenY:Number = 20,
					screenWidth:Number = 800, screenHeight:Number = 560,
		// Half the player's width and height. Saving this saves on math.
					halfWidth:Number, halfHeight:Number;
		
		// Constructor.
		public function Player(stageRef:Stage, sanitybar:SanityBar, X:int, Y:int):void{
			// Initialize the player's location.
			this.x = X; this.y = Y;
			
			halfWidth = this.width*0.5;
			halfHeight = this.height*0.5;
			
			this.stageRef = stageRef;
			this.sanityBarRef = sanitybar;
			
			this.hand = new PlayerHand(x, y);
			hand.stretch(halfWidth, hand.height);
			stageRef.addChild(hand);
			
			// Instantiate "key" by passing it a reference to the stage.
			key = new KeyObject(stageRef);
			
			// Add the listener allowing this component to update.
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		
		public function loop(e:Event):void{
			checkKeypresses();
			
			// Move the player according to arrow key presses.
			if(leftPressed){
				x -= speed;
				rotatePlayer(90);
				hand.x = x - halfWidth - hand.width;
				this.gotoAndStop("left");
			}
			else if(rightPressed){
				x += speed;
				rotatePlayer(270);
				hand.x = x + halfWidth;
				this.gotoAndStop("right");
			}
			if(upPressed){
				y -= speed;
				rotatePlayer(180);
				hand.y = y - halfHeight - hand.height;
				this.gotoAndStop("up");
			}
			else if(downPressed){
				y += speed;
				rotatePlayer(0);
				hand.y = y + halfHeight;
				this.gotoAndStop("down");
			}
			// Rotate correctly for diagonal movement.
			if(upPressed){
				if(rightPressed){ rotatePlayer(225); hand.x -= hand.halfWidth; hand.y += hand.halfHeight; }
				else if(leftPressed){ rotatePlayer(135); hand.x += hand.halfWidth; hand.y += hand.halfHeight; }
			}
			else if(downPressed){
				if(rightPressed){ rotatePlayer(315); hand.x -= hand.halfWidth; hand.y -= hand.halfHeight; }
				else if(leftPressed){ rotatePlayer(45); hand.x += hand.halfWidth; hand.y -= hand.halfHeight; }
			}
			if(!leftPressed && !rightPressed && (upPressed || downPressed)){ hand.x = x; }
			if(!upPressed && !downPressed && (leftPressed || rightPressed)){ hand.y = y; }
			
			// Stop the player from moving off-screen.
			// Stop the player from going above the stage.
			if(this.y < (screenY + halfHeight)){
				this.y = screenY + halfHeight;
			}
			// Stop the player from going below the stage.
			if(this.y > (screenY + screenHeight - halfHeight)){
				this.y = screenY + screenHeight - halfHeight;
			}
			// Stop the player from going left of the stage.
			if(this.x < (screenX + halfWidth)){
				this.x = screenX + halfWidth;
			}
			// Stop the player from going right of the stage.
			if(this.x > (screenX + screenWidth - halfWidth)){
				this.x = screenX + screenWidth - halfWidth;
			}
			
			// Decrease player sanity.
			sanity -= 0.1;
			if(sanity < 0){ sanity = 0; }
			else if(sanity > 100){ sanity = 100; }
			sanityBarRef.updateSanityBar(sanity);
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
			this.rotation = angle; hand.rotation = angle;
			halfWidth = Math.pow(Math.pow(this.width*0.5*Math.cos(angle), 2) + Math.pow(this.height*0.5*Math.sin(angle), 2), 0.5);
			halfHeight = Math.pow(Math.pow(this.width*0.5*Math.sin(angle), 2) + Math.pow(this.height*0.5*Math.cos(angle), 2), 0.5);
		}
	}
}