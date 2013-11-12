package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	
	public class SanityBar extends MovieClip{
		var currentSanity:int = 100;
		
		// Constructor.
		public function SanityBar(X:int, Y:int):void{
			this.x = X;
			this.y = Y;
		}
		public function updateSanityBar(newSanity:Number):void{
			currentSanity = newSanity;
			if(currentSanity < 0){ currentSanity = 0; }
			else if(currentSanity > 100){ currentSanity = 100; }
			
			barColor.scaleX = currentSanity*0.01;
		}
	}
}