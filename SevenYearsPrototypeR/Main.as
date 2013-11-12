package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ActivityEvent;
	//for Music
	import flash.media.Sound; 
	import flash.net.URLRequest; 
	
	public class Main extends MovieClip{
		public var	player:Player,
					sanitybar:SanityBar,
					activity1:Activity,
		// A vector containing the objects currently onscreen.
					currentObjects:Vector.<MovieClip>,
		// A vector containing the doors defined for this game.
					doors:Vector.<Door>;
		
		// Constructor.
		public function Main():void{
			sanitybar = new SanityBar(600, 50);
			stage.addChild(sanitybar);
			
			player = new Player(stage, this, sanitybar, 320, 240);
			stage.addChild(player);
			
			activity1 = new Activity(480, 320);
			stage.addChild(activity1);
			
			makeDoors();
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
				doorB_None:Door = new Door(this, player, 0, 0),
					doorB_Up:Door = new Door(this, player, 400, 0),
				doorC_None:Door = new Door(this, player, 0, 0),
					doorC_Right:Door = new Door(this, player, 800, 300),
					doorC_Down:Door = new Door(this, player, 400, 600),
				doorD_None:Door = new Door(this, player, 0, 0),
					doorD_Up:Door = new Door(this, player, 400, 0);
			
			// Create the beginning room.
			// Nondirectional entrance. Never accessible (except at game start).
			doorA_None.setExit(400, 300);
			doorA_None.containedObjects.push(new UseableObject(player, 200, 200, 15));
			doorA_None.containedObjects.push(new UseableObject(player, 250, 400, 10));
			doorA_None.containedObjects.push(doorB_Up);
			doorA_None.containedObjects.push(doorC_Right);
			// An entrance from above, going down into this room.
			doorA_Down.setExit(400, 0);
			doorA_Down.containedObjects = doorA_None.containedObjects;
			// An entrance from the right, going left into this room.
			doorA_Left.setExit(800, 300);
			doorA_Left.rotation = 90;
			doorA_Left.containedObjects = doorA_None.containedObjects;
			
			// Create a room above the beginning room.
			// Nondirectional entrance. Never accessible (except at game start).
			doorB_None.setExit(400, 300);
			doorB_None.containedObjects.push(new UseableObject(player, 400, 300, 15));
			doorB_None.containedObjects.push(new UseableObject(player, 550, 220, 20));
			doorB_None.containedObjects.push(new UseableObject(player, 150, 400, 12));
			doorB_None.containedObjects.push(doorA_Down);
			// An entrance from below, going up into this room.
			doorB_Up.setExit(400, 600);
			doorB_Up.containedObjects = doorB_None.containedObjects;
			
			// Create a room left of the beginning room.
			// Nondirectional entrance. Never accessible (except at game start).
			doorC_None.setExit(400, 300);
			doorC_None.containedObjects.push(new UseableObject(player, 400, 300, 50));
			doorC_None.containedObjects.push(doorA_Left);
			doorC_None.containedObjects.push(doorD_Up);
			// An entrance from the left, going right into this room.
			doorC_Right.setExit(0, 300);
			doorC_Right.rotation = 90;
			doorC_Right.containedObjects = doorC_None.containedObjects;
			// An entrance from above, going down into this room.
			doorC_Down.setExit(400, 0);
			doorC_Down.containedObjects = doorC_None.containedObjects;
			
			// Create a room above room C.
			// Nondirectional entrance. Never accessible (except at game start).
			doorD_None.setExit(400, 300);
			doorD_None.containedObjects.push(doorC_Down);
			// An entrance from below, going up into this room.
			doorD_Up.setExit(400, 600);
			doorD_Up.containedObjects = doorD_None.containedObjects;
			
			// Start in the beginning room, and add all doors create to the 'doors' vector.
			doorA_None.openDoor();
			doors.push(doorA_None); doors.push(doorA_Down); doors.push(doorA_Left);
			doors.push(doorB_Up);
			doors.push(doorC_Right); doors.push(doorC_Down);
			doors.push(doorD_Up);
		}
		
		// Play the background music.
		public function playMusic():void{
			var s:Sound = new Sound(); 
			s.addEventListener(Event.COMPLETE, onSoundLoaded); 
			var req:URLRequest = new URLRequest("Assets/Music/Living in the Sunlight Loving in the Moonlight.mp3"); 
			s.load(req); 
		}
		
		function onSoundLoaded(event:Event):void{
			var localSound:Sound = event.target as Sound; 
			localSound.play(0, 999);
		}
	}
}