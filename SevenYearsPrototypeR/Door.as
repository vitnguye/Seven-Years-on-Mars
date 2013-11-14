package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	
	public class Door extends MovieClip{
		// Half this hand's width and height. Saving this saves on math.
		public var	halfWidth:Number, halfHeight:Number,
		// A reference to the player.
					player:Player,
					mainRef,
		// The objects contained in the room this door leads to.
					containedObjects:Vector.<MovieClip>,
		// The coordinates at which the player will appear when they open this door.
					exitX, exitY,
		// The sound this door will make when it is opened.
					doorSnd:Sound;
		// Constructor.
		public function Door(main:Main, player_:Player, X:int, Y:int):void{
			this.mainRef = main;
			this.player = player_;
			this.x = X; this.y = Y;
			containedObjects = new Vector.<MovieClip>;
			
			doorSnd = new DoorSound();
			
			// Make the door look like its supposed to.
			this.gotoAndStop("available");
			this.visible = false;
		}
		public function setExit(exitX_:int, exitY_:int):void{
			this.exitX = exitX_; this.exitY = exitY_;
		}
		public function openDoor():void{
			doorSnd.play();
			var i:int = 0;
			// Remove all interactable objects onscreen.
			if(mainRef.currentObjects != null){
				for(i = 0; i < mainRef.currentObjects.length; ++i){
					mainRef.stage.removeChild(mainRef.currentObjects[i]);
					mainRef.currentObjects[i].visible = false;
				}
			}
			// Put the objects in the room this door leads to onscreen.
			mainRef.currentObjects = containedObjects;
			for(i = 0; i < mainRef.currentObjects.length; ++i){
				mainRef.stage.addChild(mainRef.currentObjects[i]);
				mainRef.currentObjects[i].visible = true;
			}
			// Move the player to imitate having just moved into a new screen.
			player.movePlayer(exitX, exitY);
		}
	}
}