package
{
    import flash.display.Stage;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.ActivityEvent;
 
	//for Music
	import flash.media.Sound; 
	import flash.net.URLRequest; 
	
    public class Main extends MovieClip
    {
        public var player:Player;
		public var activity1:Activity;
		public var sanitybar:SanityBar;
 
        public function Main():void
        {
            player = new Player(stage, 320, 240);
			activity1 = new Activity(480, 320);
			sanitybar = new SanityBar(600, 50);
            stage.addChild(player);
			stage.addChild(activity1);
			stage.addChild(sanitybar);
			playMusic();
        }
		
		//for music
		public function playMusic():void
		{
			trace("Hello");
			var s:Sound = new Sound(); 
			s.addEventListener(Event.COMPLETE, onSoundLoaded); 
			var req:URLRequest = new URLRequest("Assets/Music/Running in the 90's.mp3"); 
			s.load(req); 
		}
		
		function onSoundLoaded(event:Event):void 
		{ 
			trace("there");
			var localSound:Sound = event.target as Sound; 
			localSound.play();
		}
		
    }
}