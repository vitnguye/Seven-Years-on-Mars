package{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MainMenu extends MovieClip{
		// References to the main game manager and the player object.
		public var	mainRef:Main, player:Player,
		// An ID defining which menu screen this is currently showing.
					screen:String, difficultyLevel:String;
		
		// Constructor.
		public function MainMenu(mainRef_:Main):void{
			this.mainRef = mainRef_;
			this.player = mainRef.player;
			
			this.gotoAndStop("mainMenu");
			screen = "mainMenu";
			difficultyLevel = "normal";
			
			// Add the listener allowing this component to update.
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
			// Capture clicks on the stage.
			addEventListener(MouseEvent.CLICK, mouseClicked);
		}
		public function loop(e:Event):void{
			if(!this.visible){ return; }
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			player.pauseGame = true;
			if(screen == "gameOptions"){ this.difficulty.text = difficultyLevel; }
		}
		protected function mouseClicked(event:MouseEvent):void{
			switch(screen){
				case "mainMenu":
					if(this.newGame.hitTestPoint(root.mouseX, root.mouseY)){
						this.visible = false;
						mainRef.restart();
					}
					else if(this.continueGame.hitTestPoint(root.mouseX, root.mouseY)){
						this.visible = false;
						mainRef.restartMusic();
						player.pauseGame = false;
					}
					else if(this.gameOptions.hitTestPoint(root.mouseX, root.mouseY)){
						this.gotoAndStop("gameOptions");
						screen = "gameOptions";
					}
					else if(this.help.hitTestPoint(root.mouseX, root.mouseY)){
						this.gotoAndStop("help");
						screen = "help";
					}
					else if(this.credits.hitTestPoint(root.mouseX, root.mouseY)){
						this.gotoAndStop("credits");
						screen = "credits";
					}
					break;
				case "gameOptions":
					if(this.difficultyUp.hitTestPoint(root.mouseX, root.mouseY)){
						switch(difficultyLevel){
							case "easy":
								difficultyLevel = "normal";
								break;
							case "normal":
								difficultyLevel = "hard";
								break;
							case "hard":
								difficultyLevel = "nightmare";
								break;
							case "nightmare":
								break;
							default:
								difficultyLevel = "normal";
								break;
						}
						player.setDifficulty(this.difficulty.text);
						mainRef.restart();
					}
					else if(this.difficultyDown.hitTestPoint(root.mouseX, root.mouseY)){
						switch(difficultyLevel){
							case "easy":
								break;
							case "normal":
								difficultyLevel = "easy";
								break;
							case "hard":
								difficultyLevel = "normal";
								break;
							case "nightmare":
								difficultyLevel = "hard";
								break;
							default:
								difficultyLevel = "normal";
								break;
						}
						player.setDifficulty(difficultyLevel);
						mainRef.restart();
					}
					else if(this.mainMenu.hitTestPoint(root.mouseX, root.mouseY)){
						this.gotoAndStop("mainMenu");
						screen = "mainMenu";
					}
					break;
				case "help":
					if(this.mainMenu.hitTestPoint(root.mouseX, root.mouseY)){
						this.gotoAndStop("mainMenu");
						screen = "mainMenu";
					}
					break;
				case "credits":
					if(this.mainMenu.hitTestPoint(root.mouseX, root.mouseY)){
						this.gotoAndStop("mainMenu");
						screen = "mainMenu";
					}
					break;
				default:
					break;
			}
		}
	}
}