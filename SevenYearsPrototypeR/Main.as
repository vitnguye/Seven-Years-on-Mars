package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ActivityEvent;
	//for Music
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest; 
	
	public class Main extends MovieClip{
		public var	player:Player,
					sanitybar:SanityBar,
					backgroundMusic:Sound, soundChannel:SoundChannel,
		// A vector containing the objects currently onscreen.
					currentObjects:Vector.<MovieClip>,
		// A vector containing the doors defined for this game.
					doors:Vector.<Door>;
		
		// Constructor.
		public function Main():void{
			backgroundMusic = new Sound();
			backgroundMusic.load(new URLRequest("Assets/Music/Living in the Sunlight Loving in the Moonlight.mp3"));
			
			sanitybar = new SanityBar(600, 50);
			stage.addChild(sanitybar);
			
			player = new Player(stage, this, sanitybar);
			stage.addChild(player);
			
			makeDoors();
			playMusic();
		}
		public function restart():void{
			makeDoors();
			player.restart();
			soundChannel.stop();
			playMusic();
		}
		private function makeDoors(){
			doors = new Vector.<Door>;
			//	Door naming format:
			//		Doors are named as "door" + roomID + "_" + player directional heading when passing through this door.
			
			// Define rooms to be used and all doors leading into them.
			var	doorA_None:Door = new Door(this, player, 0, 0),
					doorA_Down:Door = new Door(this, player, 400, 600),
					doorA_Left:Door = new Door(this, player, 0, 300),
					doorA_Right:Door = new Door(this, player, 800, 300),
					doorA_Up:Door = new Door(this, player, 400, 0),			
				doorB_None:Door = new Door(this, player, 0, 0),
					doorB_Up:Door = new Door(this, player, 400, 0),
				doorC_None:Door = new Door(this, player, 0, 0),
					doorC_Right:Door = new Door(this, player, 800, 300),
				doorD_None:Door = new Door(this, player, 0, 0),
					doorD_Down:Door = new Door(this, player, 400, 600),
				doorE_None:Door = new Door(this, player, 0, 0),
					doorE_Left:Door = new Door(this, player, 0, 300);
			
			// Create the beginning room.
			// Nondirectional entrance. Never accessible (except at game start).
			doorA_None.setExit(400, 300);
			doorA_None.containedObjects.push(new UseableObject(player, 200, 200, 15, true, "square"));
			doorA_None.containedObjects.push(new UseableObject(player, 250, 400, 10, true, "circle"));
			doorA_None.containedObjects.push(doorB_Up);
			doorA_None.containedObjects.push(doorC_Right);
			doorA_None.containedObjects.push(doorD_Down);
			doorA_None.containedObjects.push(doorE_Left);
			// An entrance from above, going down into this room.
			doorA_Down.setExit(400, 0);
			doorA_Down.containedObjects = doorA_None.containedObjects;
			// An entrance from the right, going left into this room.
			doorA_Left.setExit(800, 300);
			doorA_Left.rotation = 90;
			doorA_Left.containedObjects = doorA_None.containedObjects;
			// An entrance from below, going up into this room.
			doorA_Up.setExit(400, 600);
			doorA_Up.containedObjects = doorA_None.containedObjects;
			// An entrance from the left, going right into this room.
			doorA_Right.setExit(0, 300);
			doorA_Right.rotation = 90;
			doorA_Right.containedObjects = doorA_None.containedObjects;
			
			// Create a room above room A.
			// Nondirectional entrance. Never accessible (except at game start).
			doorB_None.setExit(400, 300);
			doorB_None.containedObjects.push(new UseableObject(player, 400, 300, 15, true, "square"));
			doorB_None.containedObjects.push(new UseableObject(player, 550, 220, 20, true, "circle"));
			doorB_None.containedObjects.push(new UseableObject(player, 150, 400, 12, true, "square"));
			doorB_None.containedObjects.push(doorA_Down);
			// An entrance from below, going up into this room.
			doorB_Up.setExit(400, 600);
			doorB_Up.containedObjects = doorB_None.containedObjects;
			
			// Create a room to the right of room A.
			// Nondirectional entrance. Never accessible (except at game start).
			doorC_None.setExit(400, 300);
			doorC_None.containedObjects.push(new UseableObject(player, 400, 300, 50, true, "circle"));
			doorC_None.containedObjects.push(doorA_Left);
			// An entrance from the left, going right into this room.
			doorC_Right.setExit(0, 300);
			doorC_Right.rotation = 90;
			doorC_Right.containedObjects = doorC_None.containedObjects;
			
			// Create a room below room A.
			// Nondirectional entrance. Never accessible (except at game start).
			doorD_None.setExit(400, 300);
			doorD_None.containedObjects.push(doorA_Up);
			// An entrance from below, going up into this room.
			doorD_Down.setExit(400, 0);
			doorD_Down.containedObjects = doorD_None.containedObjects;
			
			// Create a room to the left of room A.
			// Nondirectional entrance. Never accessible (except at game start).
			doorE_None.setExit(400, 300);
			doorE_None.containedObjects.push(doorA_Right);
			// An entrance from the left, going right into this room.
			doorE_Left.setExit(800, 300);
			doorE_Left.rotation = 90;
			doorE_Left.containedObjects = doorE_None.containedObjects;
			
			// Start in the beginning room, and add all doors create to the 'doors' vector.
			doorA_None.openDoor();
			doors.push(doorA_None); doors.push(doorA_Down); doors.push(doorA_Left); doors.push(doorA_Up); doors.push(doorA_Right)
			doors.push(doorB_Up);
			doors.push(doorC_Right);
			doors.push(doorD_Down);
			doors.push(doorE_Left);
		}
		
		// Play the background music.
		public function playMusic():void{
			soundChannel = backgroundMusic.play();
		}
		
		function onSoundLoaded(event:Event):void{
			var localSound:Sound = event.target as Sound; 
			localSound.play(0, 999);
		}
	}
}