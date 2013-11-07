package
{
    import flash.display.Stage;
    import flash.display.MovieClip;
    import flash.events.Event;
 
    public class Activity extends MovieClip
    {
		
 
        public function Activity(X:int, Y:int):void //modify the constructor
        {
            
            this.x = X;
            this.y = Y;
			
			//addEventListener(Event.ENTER_FRAME, loop, false, 0, true); //add the EventListener
        }
		
		public function loop(e:Event):void
        {
            
        }
		public function checkKeypresses():void
        {
            
        }
		
    }
}