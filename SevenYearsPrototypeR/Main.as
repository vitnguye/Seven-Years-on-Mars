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
					testObject:UseableObject;
		
		public function Main():void{
			sanitybar = new SanityBar(600, 50);
			stage.addChild(sanitybar);
			
			player = new Player(stage, sanitybar, 320, 240);
			stage.addChild(player);
			
			activity1 = new Activity(480, 320);
			stage.addChild(activity1);
			
			testObject = new UseableObject(player, 200, 200, 15);
			stage.addChild(testObject);
			
			playMusic();
		}
		
		// Play the background music.
		public function playMusic():void{
			var s:Sound = new Sound(); 
			s.addEventListener(Event.COMPLETE, onSoundLoaded); 
			var req:URLRequest = new URLRequest("Assets/Music/Running in the 90's.mp3"); 
			s.load(req); 
		}
		
		function onSoundLoaded(event:Event):void{
			var localSound:Sound = event.target as Sound; 
			localSound.play(0, 999);
		}
	}
}