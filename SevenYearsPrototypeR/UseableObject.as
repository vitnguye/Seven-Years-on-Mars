package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	
	public class UseableObject extends MovieClip{
		// Half this hand's width and height. Saving this saves on math.
		public var	halfWidth:Number, halfHeight:Number,
		// A reference to the player, and an ID defining which object this is.
					player:Player, ID:String,
		// The sanity change the player experiences when interacting with this object.
					sanityEffect:Number = 0,
		// The number of frames left until this object can be interacted with again.
					cooldownCounter:Number = 0,
		// Can the player collide with this object?
					collisionEnabled:Boolean = true,
		// The sound this object will make when interacted with by the player.
					interactSnd:Sound;
		// Constructor.
		public function UseableObject(player_:Player, X:int, Y:int, sanEffect:Number, collidible:Boolean, ID_:String):void{
			this.player = player_;
			this.x = X; this.y = Y;
			this.sanityEffect = sanEffect;
			this.collisionEnabled = collidible;
			this.ID = ID_;
			
			// make an instance of the Interaction Sound
			interactSnd = new InteractSound();
			
			// Add the listener allowing this component to update.
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
			// Make this object look like its supposed to.
			this.gotoAndStop(ID);
			this.visible = false;
		}
		public function loop(e:Event):void{
			if(!visible){ return; }
			
			if(collisionEnabled && player.hitTestObject(this)){
				player.movePlayer(player.prevX, player.prevY);
			}
			--cooldownCounter;
			if(cooldownCounter < 0){
				this.gotoAndStop(ID);
				cooldownCounter = 0;
				
				effect();
			}
		}
		public function effect(){
			switch(ID){
				case "square":
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && player.hand.hitTestObject(this)){
						cooldownCounter = 120;
						this.gotoAndStop(ID+"Cooldown");
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.9);
						
						interactSnd.play();
					}
					break;
				case "circle":
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && player.hand.hitTestObject(this)){
						cooldownCounter = 30;
						this.gotoAndStop(ID+"Cooldown");
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.5);
						
						interactSnd.play();
					}
					break;
				default:
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && player.hand.hitTestObject(this)){
						cooldownCounter = 50;
						this.gotoAndStop(ID+"Cooldown");
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.5);
						
						interactSnd.play();
					}
					break;
			}
			
		}
	}
}