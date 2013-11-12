package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class UseableObject extends MovieClip{
		// Half this hand's width and height. Saving this saves on math.
		public var	halfWidth:Number, halfHeight:Number,
		// A reference to the player.
					player:Player,
		// The sanity change the player experiences when interacting with this object.
					sanityEffect:Number = 0;
		// Constructor.
		public function UseableObject(player_:Player, X:int, Y:int, sanEffect:Number):void{
			this.player = player_;
			this.x = X;
			this.y = Y;
			this.sanityEffect = sanEffect;
			
			// Add the listener allowing this component to update.
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
		public function loop(e:Event):void{
			// Constantly check for collision with the player's hand when the player is attempting interaction.
			if(player.spacePressed && player.hand.hitTestObject(this)){
				// Go ahead and put whatever animation related code you need to show interaction here.
				;
				// Effect the player's sanity appropriately.
				player.sanity += sanityEffect;
				// Decrease the effect of this object every time it is used.
				sanityEffect *= 0.5;
			}
		}
	}
}