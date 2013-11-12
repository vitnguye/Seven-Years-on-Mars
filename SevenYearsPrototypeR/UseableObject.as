package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	
	public class UseableObject extends MovieClip{
		// Half this hand's width and height. Saving this saves on math.
		public var	halfWidth:Number, halfHeight:Number,
		// A reference to the player.
					player:Player,
		// The sanity change the player experiences when interacting with this object.
					sanityEffect:Number = 0,
		// The number of frames left until this object can be interacted with again.
					cooldownCounter:Number = 0;
		// for sound
		public var interactSnd:Sound;
		// Constructor.
		public function UseableObject(player_:Player, X:int, Y:int, sanEffect:Number):void{
			this.player = player_;
			this.x = X; this.y = Y;
			this.sanityEffect = sanEffect;
			
			// Add the listener allowing this component to update.
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
			// Make this object look like its supposed to.
			this.gotoAndStop("available");
			this.visible = false;
			
			// make an instance of the Interaction Sound
			interactSnd = new InteractSound();
		}
		public function loop(e:Event):void{
			if(!visible){ return; }
			
			--cooldownCounter;
			if(cooldownCounter < 0){
				this.gotoAndStop("available");
				cooldownCounter = 0;
				// Constantly check for collision with the player's hand when the player is attempting interaction.
				if(player.spacePressed && player.hand.hitTestObject(this)){
					cooldownCounter = 50;
					this.gotoAndStop("cooldown");
					// Effect the player's sanity appropriately.
					player.sanity += sanityEffect;
					// Decrease the effect of this object every time it is used.
					sanityEffect *= 0.5;
					// play the interact sound
					interactSnd.play();
				}
			}
		}
	}
}