package
{
    import flash.display.Stage;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.ActivityEvent;
 
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
        }
    }
}