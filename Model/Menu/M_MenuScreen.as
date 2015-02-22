package Code.Model.Menu {
	import flash.events.*;
	import Code.*;
	import Code.Model.*;
	
	public final class M_MenuScreen extends M_Screen {
		
		public override function Setup (arg:Object = null) {
			
		}
		
		public function GoGame () {
			program.NewBigScreen (ScreenType.Game);
		}
		
		public function GoCredits () {
			program.AddModalScreen (ScreenType.Credits);
		}
	}
}