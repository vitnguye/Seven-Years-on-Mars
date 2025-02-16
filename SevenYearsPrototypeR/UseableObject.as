﻿package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.display.Graphics;
	
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
			
			// Give this object the default interaction sound.
			interactSnd = new InteractSound();
			
			// Add the listener allowing this component to update.
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
			// Make this object look like its supposed to.
			this.gotoAndStop(ID);
			this.visible = false;
			
			switch(ID){
				case "bookshelf":
					stretch(100, 200);
					interactSnd = new PageFlip();
					break;
				case "clock":
					stretch(30, 30);
					break;
				case "co2Scrubber":
					stretch(75,125);
					break;
				case "chemistryTable":
					stretch(200, 100);
					interactSnd = new Bubbling();
					break;
				case "cubbyhole":
					stretch(700, 200);
					interactSnd = new Snoring();
					break;
				case "diningTable":
					stretch(200, 100);
					interactSnd = new Eating();
					break;
				case "dolphinRide":
					stretch(150, 100);
					interactSnd = new Dolphin();
					break;
				case "floor":
					stretch(800, 500);
					break;
				case "gameBoard":
					stretch(30, 30);
					break;
				case "gameConsole":
					stretch(30, 10);
					interactSnd = new GameStation();
					break;
				case "gameController":
					stretch(10, 10);
					interactSnd = new ButtonMashing();
					break;
				case "garden":
					stretch(800, 500);
					break;
				case "magnifyingGlass":
					stretch(30, 10);
					break;
				case "microscope":
					stretch(10, 30);
					break;
				case "pony":
					stretch(100, 75);
					interactSnd = new Neigh();
					break;
				case "robotArm":
					stretch(75,100);
					break;
				case "rock":
					stretch(30, 20);
					break;
				case "rover":
					stretch(75, 50);
					break;
				case "satelliteControlPanel":
					stretch(100, 50);
					interactSnd = new Computer();
					break;
				case "sink":
					stretch(50, 30);
					break;
				case "skull":
					stretch(15, 10);
					break;
				case "sockPuppet_1":
					stretch(10, 15);
					break;
				case "sockPuppet_2":
					stretch(10, 15);
					break;
				case "spinningChair_1":
					stretch(50, 60);
					interactSnd = new ChairSqueak();
					break;
				case "spinningChair_2":
					stretch(50, 60);
					interactSnd = new ChairSqueak();
					break;
				case "steelTable":
					stretch(200, 100);
					break;
				case "talkingBass":
					stretch(50, 25);
					interactSnd = new TalkingBass();
					break;
				case "tardis":
					stretch(50, 100);
					break;
				case "television":
					stretch(50, 80);
					break;
				case "treadmill":
					stretch(100, 50);
					interactSnd = new Treadmill();
					break;
				case "waterPot":
					stretch(35, 20);
					break;
				case "whiteBoard":
					stretch(100, 50);
					break;
				case "wallSquare":
					break;
				case "wallTriangle":
					break;
				default:
					break;
			}
		}
		public function loop(e:Event):void{
			if(!visible){ return; }
			
			if(collisionEnabled && verifyCollision(player)){
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
				case "bookshelf":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 90;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.5);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "clock":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 50;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.5);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "co2Scrubber":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 50;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.7);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break
				case "chemistryTable":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 50;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect + rand(-15, 15)));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.78);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "cubbyhole":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 50;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.5);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "diningTable":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 50;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.5);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "dolphinRide":
					// Only allow this object to exist when player sanity is low enough and the player is not occupying
					//	the same space as this object would.
					if(player.sanity >= 50 || ((this.alpha < 0) && verifyCollision(player))){
						if(collisionEnabled){ this.alpha = -2; }
						else if(this.alpha != -2){ this.alpha = -1; }
						collisionEnabled = false;
						break;
					}
					else{
						if(this.alpha == -2){ collisionEnabled = true; }
						this.alpha = 1.0;
					}
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 60;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.7);
						
						interactSnd.play();
					}
					break;
				case "floor":
					break;
				case "gameBoard":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 30;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.7);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "gameConsole":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 50;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect + 8));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.888);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "gameController":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 50;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect + 5));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.777);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "garden":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 50;
						this.alpha = 0.95;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.5);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "magnifyingGlass":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 90;
						this.alpha = 0.18;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.7);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "microscope":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 300;
						this.alpha = 0.0;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.95);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "pony":
					// Only allow this object to exist when player sanity is low enough and the player is not occupying
					//	the same space as this object would.
					if(player.sanity >= 50 || ((this.alpha < 0) && verifyCollision(player))){
						if(collisionEnabled){ this.alpha = -2; }
						else if(this.alpha != -2){ this.alpha = -1; }
						collisionEnabled = false;
						break;
					}
					else{
						if(this.alpha == -2){ collisionEnabled = true; }
						this.alpha = 1.0;
					}
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 50;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.7);
						
						interactSnd.play();
					}
					break;
				case "robotArm":
					break;
				case "rock":
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 50;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.0);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "rover":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 180;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.7);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "satelliteControlPanel":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 80;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.5);
						
						interactSnd.play();
					}
					break;
				case "sink":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 50;
						this.alpha = 0.6;
						
						player.sanity -= 1.5;
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "skull":
					// Only allow this object to exist when player sanity is low enough and the player is not occupying
					//	the same space as this object would.
					if(player.sanity >= 50 || ((this.alpha < 0) && verifyCollision(player))){
						if(collisionEnabled){ this.alpha = -2; }
						else if(this.alpha != -2){ this.alpha = -1; }
						collisionEnabled = false;
						break;
					}
					else{
						if(this.alpha == -2){ collisionEnabled = true; }
						this.alpha = 1.0;
					}
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 50;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.9);
						
						interactSnd.play();
					}
					break;
				case "sockPuppet_1":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 60;
						this.alpha = 0.4;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.8);
						var teleportOpen:Boolean = false, obj:MovieClip;
						while(this.hitTestObject(player) || !teleportOpen){
							x = rand(halfWidth, 800 - halfWidth); y = rand(100 + halfHeight, 600 - halfHeight);
							teleportOpen = true;
							for(var i:int = 0; i < (player.mainRef.currentObjects.length-1); ++i){
								obj = player.mainRef.currentObjects[i];
								if(obj != this && obj.visible && obj.collisionEnabled
										&& this.hitTestObject(obj)){
									teleportOpen = false;
								}
							}
						}
						if(sanityEffect < 5){ sanityEffect = rand(-5, 5); }
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "sockPuppet_2":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 70;
						this.alpha = 0.4;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.8);
						player.mainRef.doors[rand(1, player.mainRef.doors.length)-1].openDoor();
						if(sanityEffect < 5){ sanityEffect = rand(-5, 5); }
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "spinningChair_1":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 120;
						this.alpha = 0.8;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.25);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "spinningChair_2":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 120;
						this.alpha = 0.8;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.25);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "steelTable":
					break;
				case "talkingBass":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 40;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						if((player.sanity < 30) && (sanityEffect > 0)){ sanityEffect = -sanityEffect; }
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.7);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "tardis":
					// Only allow this object to exist when player sanity is low enough and the player is not occupying
					//	the same space as this object would.
					if(player.sanity >= 10 || ((this.alpha < 0) && verifyCollision(player))){
						if(collisionEnabled){ this.alpha = -2; }
						else if(this.alpha != -2){ this.alpha = -1; }
						collisionEnabled = false;
						break;
					}
					else{
						if(this.alpha == -2){ collisionEnabled = true; }
						this.alpha = 1.0;
					}
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 999999999;
						this.alpha = rand(0, 1);
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						//this.parent.removeChild(this);
						this.visible = false;
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "television":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 10;
						this.alpha = 0.9;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.17);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "treadmill":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 120;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect - 5));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.65);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "waterPot":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 5;
						this.alpha = 0.2;
						
						// Effect the player's sanity appropriately.
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.95);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "whiteBoard":
					this.alpha = 1.0;
					// Constantly check for collision with the player's hand when the player is attempting interaction.
					if(player.spacePressed && verifyCollision(player.hand)){
						cooldownCounter = 60;
						this.alpha = 0.6;
						
						// Effect the player's sanity appropriately.
						if((player.sanity < 30) && (sanityEffect > 0)){ sanityEffect = -sanityEffect; }
						player.sanity += sanityEffect;
						stage.addChild(new NumericalUpdate(x, y, sanityEffect));
						// Decrease the effect of this object every time it is used.
						sanityEffect = (int)(sanityEffect*0.7);
						
						if(player.mainRef.soundOn){ interactSnd.play(); }
					}
					break;
				case "wallSquare":
					break;
				case "wallTriangle":
					break;
				default:
					break;
			}
		}
		private function verifyCollision(other:MovieClip):Boolean{
			if(!other.hitTestObject(this)){ return false; }
			for(var i:int = 0; i < this.numChildren; ++i){
				if((this.getChildAt(i) is MovieClip) && (this.getChildAt(i).name != ID) &&
						other.hitTestObject(this.getChildAt(i))){
					return true;
				}
			}
			return false;
		}
		public function stretch(sizeX:int, sizeY:int):void{
			width = sizeX; height = sizeY;
			halfWidth = width*0.5;
			halfHeight = height*0.5;
		}
		public function rotate(angle:Number):void{
			var angleDegrees:int = (angle*180)/Math.PI;
			if(rotation == angleDegrees){ return; }
			
			var	w:Number = width*0.5, h:Number = height*0.5;
			halfWidth = w*Math.cos(angle);
			halfHeight = h*Math.sin(angle);
			
			rotation = angleDegrees - 90;
			halfWidth = Math.abs(halfWidth); halfHeight = Math.abs(halfHeight);
		}
		public function rand(min:Number, max:Number):Number{
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
	}
}