package code
{
	/*****************************************
	 * Interactivity4 :
	 * Demonstrates movement controlled by the keyboard.
	 * -------------------
	 * See 4_keyboard.fla
	 ****************************************/
	 
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	
	//for Music
	import flash.events.Event; 
	import flash.media.Sound; 
	import flash.net.URLRequest; 
	import flash.events.ActivityEvent;
	
	public class Player_Char extends MovieClip
	{
		//*************************
		// Variables:
		
		public var up:Boolean = false,
					down:Boolean = false,
					left:Boolean = false,
					right:Boolean = false;
		
		public var speed:Number = 5,
					screenWidth:Number = 378, screenHeight:Number = 560,
					screenX:Number = 410, screenY:Number = 20,
		
					playerHalfWidth:Number, playerHalfHeight:Number;
		
		//*************************
		// Constructor:
		
		public function Player_Char()
		{
			// Listen to keyboard presses
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyPressHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyReleaseHandler);
			
			// Update screen every frame
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			
			// Initialize variables as needed.
			playerHalfWidth = player.width*0.5;
			playerHalfHeight = player.height*0.5;
			
			playMusic();
			
		}
		
		//*************************
		// Event Handling:
		
		protected function enterFrameHandler(event:Event):void
		{
			// Move up, down, left, or right
			if(left && !right){
				player.x -= speed;
				rotatePlayer(270);
			}
			else if(right && !left) {
				player.x += speed;
				rotatePlayer(90);
			}
			if(up && !down) {
				player.y -= speed;
				rotatePlayer(0);
			}
			else if(down && !up) {
				player.y += speed;
				rotatePlayer(180);
			}
			
			// Move diagonally
			if(up && !down){
				if(left && !right){ rotatePlayer(315); }
				else if(right && !left){ rotatePlayer(45); }
			}
			if(down && !up){
				if(left && !right){ rotatePlayer(225); }
				else if(right && !left){ rotatePlayer(135); }
			}
			
			// Stop the player (player) from moving off-screen.
			if(player.y < (screenY + playerHalfHeight)){
				player.y = screenY + playerHalfHeight;
			}
			if(player.y > (screenY + screenHeight - playerHalfHeight)){
				player.y = screenY + screenHeight - playerHalfHeight;
			}
			if(player.x < (screenX + playerHalfWidth)){
				player.x = screenX + playerHalfWidth;
			}
			if(player.x > (screenX + screenWidth - playerHalfWidth)){
				player.x = screenX + screenWidth - playerHalfWidth;
			}
		}
		
		public function rotatePlayer(angle:Number):void{
			player.rotation = angle;
			playerHalfWidth = Math.pow(Math.pow(player.width*0.5*Math.cos(angle), 2) + Math.pow(player.height*0.5*Math.sin(angle), 2), 0.5);
			playerHalfHeight = Math.pow(Math.pow(player.width*0.5*Math.sin(angle), 2) + Math.pow(player.height*0.5*Math.cos(angle), 2), 0.5);
		}
		
		protected function keyPressHandler(event:KeyboardEvent):void
		{
			switch( event.keyCode )
			{
				case Keyboard.UP:
					up = true;
					break;
					
				case Keyboard.DOWN:
					down = true;
					break;
					
				case Keyboard.LEFT:
					left = true;
					break;
					
				case Keyboard.RIGHT:
					right = true;
					break;
			}
		}
		
		protected function keyReleaseHandler(event:KeyboardEvent):void
		{
			switch( event.keyCode )
			{
				case Keyboard.UP:
					up = false;
					//up_mc.gotoAndStop(1);
					break;
					
				case Keyboard.DOWN:
					down = false;
					//down_mc.gotoAndStop(1);
					break;
					
				case Keyboard.LEFT:
					left = false;
					//left_mc.gotoAndStop(1);
					break;
					
				case Keyboard.RIGHT:
					right = false;
					//right_mc.gotoAndStop(1);
					break;
			}
		}
		
		//for music
		public function playMusic():void
		{
			trace("Hello");
			var s:Sound = new Sound(); 
			s.addEventListener(Event.COMPLETE, onSoundLoaded); 
			var req:URLRequest = new URLRequest("Music/guile_stage.mp3"); 
			s.load(req); 
		}
		
		function onSoundLoaded(event:Event):void 
		{ 
			var localSound:Sound = event.target as Sound; 
			localSound.play(); 
		}
	}
}