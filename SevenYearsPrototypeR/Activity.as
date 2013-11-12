package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Activity extends MovieClip{
		// Constructor.
		public function Activity(X:int, Y:int):void{
			this.x = X;
			this.y = Y;
			
			// Add the listener allowing this component to update.
			//addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		
		public function loop(e:Event):void{}
		public function checkKeypresses():void{}
	}
}