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
		public var	player:Player, mainMenu:MainMenu,
					sanitybar:SanityBar,
					soundChannel:SoundChannel, soundOn:Boolean,
					backgroundMusic:Sound, menuMusic:Sound,
		// A vector containing the objects currently onscreen.
					currentObjects:Vector.<MovieClip>,
		// A vector containing the doors defined for this game.
					doors:Vector.<Door>;
		
		// Constructor.
		public function Main():void{
			soundOn = false;
			menuMusic = new Sound();
			menuMusic.load(new URLRequest("Assets/Music/Light Hearted.mp3"));
			backgroundMusic = new Sound();
			backgroundMusic.load(new URLRequest("Assets/Music/Living in the Sunlight Loving in the Moonlight.mp3"));
			
			sanitybar = new SanityBar(700, 30);
			stage.addChild(sanitybar);
			
			player = new Player(stage, this, sanitybar);
			stage.addChild(player);
			
			mainMenu = new MainMenu(this);
			stage.addChild(mainMenu);
			mainMenu.x = 400; mainMenu.y = 300;
			
			restart();
			goToMainMenu();
		}
		public function restart():void{
			if(!mainMenu.visible){ restartMusic(); }
			makeDoors();
			player.restart();
		}
		public function goToMainMenu(){
			mainMenu.visible = true;
			restartMusic();
		}
		private function makeDoors(){
			doors = new Vector.<Door>;
			//	Door naming format:
			//		Doors are named as "door" + roomID + "_" + player directional heading when passing through this door.
			
			// Define rooms to be used and all doors leading into them.
			var	doorA_None:Door = new Door(this, player, 0, 0),
					doorA_Down:Door = new Door(this, player, 400, 600),
					doorA_Left:Door = new Door(this, player, 0, 350),
					doorA_Right:Door = new Door(this, player, 800, 350),
					doorA_Up:Door = new Door(this, player, 400, 100),			
				doorB_None:Door = new Door(this, player, 0, 0),
					doorB_Up:Door = new Door(this, player, 400, 100),
				doorC_None:Door = new Door(this, player, 0, 0),
					doorC_Right:Door = new Door(this, player, 800, 350),
				doorD_None:Door = new Door(this, player, 0, 0),
					doorD_Down:Door = new Door(this, player, 400, 600),
				doorE_None:Door = new Door(this, player, 0, 0),
					doorE_Left:Door = new Door(this, player, 0, 350),
				wall:UseableObject;
			
			// Create the beginning room.
			// Nondirectional entrance. Never accessible (except at game start).
			doorA_None.setExit(400, 350);
			doorA_None.containedObjects.push(new UseableObject(player, 400, 350, 0, false, "floor"));
			doorA_None.containedObjects.push(new UseableObject(player, 400, 230, 20, true, "spinningChair_2"));
			doorA_None.containedObjects.push(new UseableObject(player, 570, 450, 10, true, "diningTable"));
			wall = new UseableObject(player, 700, 125, 0, true, "wallSquare"); wall.stretch(200, 50);
			doorA_None.containedObjects.push(wall);
			wall = new UseableObject(player, 775, 200, 0, true, "wallSquare"); wall.stretch(50, 200);
			doorA_None.containedObjects.push(wall);
			wall = new UseableObject(player, 100, 125, 0, true, "wallSquare"); wall.stretch(200, 50);
			doorA_None.containedObjects.push(wall);
			wall = new UseableObject(player, 25, 200, 0, true, "wallSquare"); wall.stretch(50, 200);
			doorA_None.containedObjects.push(wall);
			wall = new UseableObject(player, 700, 575, 0, true, "wallSquare"); wall.stretch(200, 50);
			doorA_None.containedObjects.push(wall);
			wall = new UseableObject(player, 775, 500, 0, true, "wallSquare"); wall.stretch(50, 200);
			doorA_None.containedObjects.push(wall);
			wall = new UseableObject(player, 100, 575, 0, true, "wallSquare"); wall.stretch(200, 50);
			doorA_None.containedObjects.push(wall);
			wall = new UseableObject(player, 25, 500, 0, true, "wallSquare"); wall.stretch(50, 200);
			doorA_None.containedObjects.push(wall);
			doorA_None.containedObjects.push(new UseableObject(player, 570, 120, 20, true, "satelliteControlPanel"));
			doorA_None.containedObjects.push(new UseableObject(player, 280, 120, -10, true, "talkingBass"));
			doorA_None.containedObjects.push(doorB_Up);
			doorA_None.containedObjects.push(doorC_Right);
			doorA_None.containedObjects.push(doorD_Down);
			doorA_None.containedObjects.push(doorE_Left);
			// An entrance from above, going down into this room.
			doorA_Down.setExit(400, 100);
			doorA_Down.stretch(100, 100);
			doorA_Down.rotation = 180;
			doorA_Down.containedObjects = doorA_None.containedObjects;
			// An entrance from the right, going left into this room.
			doorA_Left.setExit(800, 350);
			doorA_Left.stretch(100, 100);
			doorA_Left.rotation = 270;
			doorA_Left.containedObjects = doorA_None.containedObjects;
			// An entrance from below, going up into this room.
			doorA_Up.setExit(400, 600);
			doorA_Up.stretch(100, 100);
			doorA_Up.containedObjects = doorA_None.containedObjects;
			// An entrance from the left, going right into this room.
			doorA_Right.setExit(0, 350);
			doorA_Right.stretch(100, 100);
			doorA_Right.rotation = 90;
			doorA_Right.containedObjects = doorA_None.containedObjects;
			
			// Create a room above room A.
			// Nondirectional entrance. Never accessible (except at game start).
			doorB_None.setExit(400, 350);
			doorB_None.containedObjects.push(new UseableObject(player, 400, 350, 0, false, "floor"));
			doorB_None.containedObjects.push(new UseableObject(player, 400, 300, 20, true, "dolphinRide"));
			doorB_None.containedObjects.push(doorA_Down);
			// An entrance from below, going up into this room.
			doorB_Up.setExit(400, 600);
			doorB_Up.stretch(100, 100);
			doorB_Up.containedObjects = doorB_None.containedObjects;
			
			// Create a room to the right of room A.
			// Nondirectional entrance. Never accessible (except at game start).
			doorC_None.setExit(400, 350);
			doorC_None.containedObjects.push(new UseableObject(player, 400, 350, 0, false, "floor"));
			wall = new UseableObject(player, 400, 123, 0, true, "wallSquare"); wall.stretch(800, 46);
			doorC_None.containedObjects.push(wall);
			wall = new UseableObject(player, 675, 153, 0, true, "wallSquare"); wall.stretch(250, 60);
			doorC_None.containedObjects.push(wall);
			doorC_None.containedObjects.push(new UseableObject(player, 150, 125, 25, true, "whiteBoard"));
			doorC_None.containedObjects.push(new UseableObject(player, 270, 125, 25, true, "whiteBoard"));
			doorC_None.containedObjects.push(new UseableObject(player, 420, 175, 20, true, "rock"));
			doorC_None.containedObjects.push(new UseableObject(player, 400, 165, 18, true, "magnifyingGlass"));
			doorC_None.containedObjects.push(new UseableObject(player, 700, 165, 0, true, "sink"));
			doorC_None.containedObjects.push(new UseableObject(player, 370, 330, 42, true, "chemistryTable"));
			doorC_None.containedObjects.push(new UseableObject(player, 370, 545, 0, true, "steelTable"));
			doorC_None.containedObjects.push(new UseableObject(player, 420, 500, 26, false, "microscope"));
			doorC_None.containedObjects.push(new UseableObject(player, 600, 330, 20, true, "spinningChair_1"));
			doorC_None.containedObjects.push(doorA_Left);
			// An entrance from the left, going right into this room.
			doorC_Right.setExit(0, 350);
			doorC_Right.stretch(100, 100);
			doorC_Right.rotation = 90;
			doorC_Right.containedObjects = doorC_None.containedObjects;
			
			// Create a room below room A.
			// Nondirectional entrance. Never accessible (except at game start).
			doorD_None.setExit(400, 350);
			doorD_None.containedObjects.push(new UseableObject(player, 400, 350, 0, false, "floor"));
			doorD_None.containedObjects.push(new UseableObject(player, 400, 350, 60, false, "garden"));
			doorD_None.containedObjects.push(new UseableObject(player, 530, 520, 11, true, "waterPot"));
			doorD_None.containedObjects.push(doorA_Up);
			// An entrance from below, going up into this room.
			doorD_Down.setExit(400, 0);
			doorD_Down.stretch(100, 100);
			doorD_Down.rotation = 180;
			doorD_Down.containedObjects = doorD_None.containedObjects;
			
			// Create a room to the left of room A.
			// Nondirectional entrance. Never accessible (except at game start).
			doorE_None.setExit(400, 350);
			doorE_None.containedObjects.push(new UseableObject(player, 400, 350, 0, false, "floor"));
			doorE_None.containedObjects.push(new UseableObject(player, 450, 200, 25, true, "cubbyhole"));
			doorE_None.containedObjects.push(new UseableObject(player, 50, 200, 25, true, "bookshelf"));
			doorE_None.containedObjects.push(new UseableObject(player, 25, 480, 25, true, "television"));
			doorE_None.containedObjects.push(new UseableObject(player, 105, 480, 25, true, "gameConsole"));
			doorE_None.containedObjects.push(new UseableObject(player, 140, 480, 20, true, "gameController"));
			doorE_None.containedObjects.push(new UseableObject(player, 130, 520, 20, true, "gameBoard"));
			doorE_None.containedObjects.push(new UseableObject(player, 472, 480, 28, true, "sockPuppet_1"));
			doorE_None.containedObjects.push(new UseableObject(player, 485, 475, 28, true, "sockPuppet_2"));
			doorE_None.containedObjects.push(new UseableObject(player, 640, 530, 34, true, "treadmill"));
			doorE_None.containedObjects.push(doorA_Right);
			// An entrance from the left, going right into this room.
			doorE_Left.setExit(800, 350);
			doorE_Left.stretch(100, 100);
			doorE_Left.rotation = 270;
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
		public function toggleMusic():void{
			if(soundOn){
				soundChannel.stop();
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, musicEnd, false);
			}
			else{
				playMusic();
				soundChannel.addEventListener(Event.SOUND_COMPLETE, musicEnd, false, 0, true);
			}
			soundOn = !soundOn;
		}
		public function musicEnd(e:Event):void{
			playMusic();
		}
		public function restartMusic():void{
			toggleMusic();
			if(!soundOn){ toggleMusic(); }
		}
		private function playMusic():void{
			if(mainMenu.visible){ soundChannel = menuMusic.play(); }
			else{ soundChannel = backgroundMusic.play(); }
		}
	}
}