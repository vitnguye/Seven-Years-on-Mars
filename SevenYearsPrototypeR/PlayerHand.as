package{
	import flash.display.MovieClip;
	public class PlayerHand extends MovieClip{
		// Half this hand's width and height. Saving this saves on math.
		public var	halfWidth:Number, halfHeight:Number;
		public function PlayerHand(X:int, Y:int):void{
			this.x = X; this.y = Y;
			
			this.halfWidth = this.width*0.5;
			this.halfHeight = this.height*0.5;
		}
		public function stretch(sizeX:int, sizeY:int):void{
			width = sizeX; height = sizeY;
			halfWidth = width*0.5;
			halfHeight = height*0.5;
		}
	}
}