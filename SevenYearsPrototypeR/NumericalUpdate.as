package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class NumericalUpdate extends MovieClip{
		// How many frames this update will last before being destroyed and how many pixels it will float
		//	upwards for in that lifetime.
		public var	lifeTime:int, floatHeight:int,
		// Values measuring exactly how much needs to be changed per frame for the above to work correctly.
					lifeLostPerFrame:Number, heightGainedPerFrame:Number;
		// Constructor.
		public function NumericalUpdate(X:int, Y:int, valueDisplayed:Number):void{
			lifeTime = 60.0; lifeLostPerFrame = 1.0/lifeTime;
			floatHeight = 50.0; heightGainedPerFrame = floatHeight/lifeTime;
			
			this.x = X; this.y = Y
			// Display the given value.
			this.num.text = ""+valueDisplayed;
			// If the given value is negative, display in red text.
			if(valueDisplayed < 0){ this.num.textColor = 0xFF0000; }
			// If the given value is positive, display in green text.
			if(valueDisplayed > 0){ this.num.textColor = 0x00FF00; }
			// Otherwise display in white text.
			else{ this.num.textColor = 0xFFFFFF; }
			
			// Add the listener allowing this component to update.
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		public function loop(e:Event):void{
			// Lose visibility as this update fades away.
			alpha -= lifeLostPerFrame;
			// Destroy this update when it is no longer visible.
			if(alpha <= 0){ destroy(); }
			// Float up onscreen.
			y -= heightGainedPerFrame;
		}
		// Please set all refernces to this object that may exist to null after calling this function.
		public function destroy():void{
			this.removeEventListener(Event.ENTER_FRAME, loop, false);
			this.stop();
		}
	}
}