package {
	public class bookshelf extends UseableObject{
		public function bookshelf(player_:Player, X:int, Y:int, sanEffect:Number) {
			super.UseableObject(player_, X, Y, sanEffect);
		}
		public function effect(){
			// Effect the player's sanity appropriately.
			player.sanity += sanityEffect;
			stage.addChild(new NumericalUpdate(x, y, sanityEffect));
			// Decrease the effect of this object every time it is used.
			sanityEffect *= 0.5;
			
			interactSnd.play();
		}
	}
	
}
