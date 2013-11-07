package
{
    import flash.display.Stage;
    import flash.display.MovieClip;
    import flash.events.Event;
	
 
    public class SanityBar extends MovieClip
    {
       var maxSanity:int = 100;
var currentSanity:int = maxSanity;
var percentSanity:Number = currentSanity / maxSanity;
 
        public function SanityBar(X:int, Y:int):void //modify the constructor
        {
            this.x = X;
            this.y = Y;
			
			
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true); //add the EventListener
        }
		
		public function loop(e:Event):void
        {
            currentSanity -= 0.2;
			updateSanityBar();
        }
		function updateSanityBar():void
{
     percentSanity = currentSanity / maxSanity;
     barColor.scaleX = percentSanity;
}
		
           
		
    }
}