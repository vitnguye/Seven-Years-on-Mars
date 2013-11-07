package
{
    import flash.display.Stage;
    import flash.display.MovieClip;
    import flash.events.Event;
	import KeyObject; //add this import
 
    public class Player extends MovieClip
    {
        public var stageRef:Stage; //create an instance variable for the stage reference
		public var key:KeyObject; //add this instance variable
		
		//add these four variables:
        public var leftPressed:Boolean = false; //keeps track of whether the left arrow key is pressed
        public var rightPressed:Boolean = false; //same, but for right key pressed
        public var upPressed:Boolean = false; //...up key pressed
        public var downPressed:Boolean = false; //...down key pressed
		
		public var speed:Number = 5; //add this Number variable
		
		public var screenWidth:Number = 800;//378;
		public var screenHeight:Number = 560;
		public var screenX:Number = 0; //410; 
		public var screenY:Number = 20;
		public var playerHalfWidth:Number, playerHalfHeight:Number;
 
        public function Player(stageRef:Stage, X:int, Y:int):void //modify the constructor
        {
            this.stageRef = stageRef; //assign the parameter to this instance's stageRef variable
            this.x = X;
            this.y = Y;
			
			key = new KeyObject(stageRef); //instantiate "key" by passing it a reference to the stage
			
			playerHalfWidth = this.width*0.5;
			playerHalfHeight = this.height*0.5;
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true); //add the EventListener
        }
		
		public function loop(e:Event):void
        {
            checkKeypresses();
 
            if(leftPressed){
                x -= speed; // move to the left if leftPressed is true
            } else if(rightPressed){
                x += speed; // move to the right if rightPressed is true
            }
 
            if(upPressed){
                y -= speed; // move up if upPressed is true
            } else if(downPressed){
                y += speed; // move down if downPressed is true
            }
			
			// Stop the player (player) from moving off-screen.
			if(this.y < (screenY + playerHalfHeight)){
				this.y = screenY + playerHalfHeight; //if you're going up too far
			}
			if(this.y > (screenY + screenHeight - playerHalfHeight)){
				this.y = screenY + screenHeight - playerHalfHeight; //if you're going down too far
			}
			if(this.x < (screenX + playerHalfWidth)){
				this.x = screenX + playerHalfWidth; //if you're going left too far
			}
			if(this.x > (screenX + screenWidth - playerHalfWidth)){
				this.x = screenX + screenWidth - playerHalfWidth; //if you're going right too far.
			}
        }
		public function checkKeypresses():void
        {
            // I used http://www.dakmm.com/?p=272 as a reference to get the keyCode numbers for each key
            if(key.isDown(37) || key.isDown(65)){ // if left arrow or A is pressed
                leftPressed = true;
            } else {
                leftPressed = false;
            }
 
            if(key.isDown(38) || key.isDown(87)){ // if up arrow or W is pressed
                upPressed = true;
            } else {
                upPressed = false;
            }
 
            if(key.isDown(39) || key.isDown(68)){ //if right arrow or D is pressed
                rightPressed = true;
            } else {
                rightPressed = false;
            }
 
            if(key.isDown(40) || key.isDown(83)){ //if down arrow or S is pressed
                downPressed = true;
            } else {
                downPressed = false;
            }
        }
		
    }
}