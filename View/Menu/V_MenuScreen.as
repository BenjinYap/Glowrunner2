package Code.View.Menu {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	import Code.View.*;
	import Code.Model.*;
	import Code.Model.Menu.*;
	
	public final class V_MenuScreen extends V_Screen {
		private var m:M_MenuScreen;
		
		private var btts:Array;
		
		public override function Setup () {
			m = M_MenuScreen (model);
			
			btts = [bttPlay, bttCredits];
			
			for (var i:int = 0; i < btts.length; i++) {
				btts [i].addEventListener (MouseEvent.CLICK, onBttClick, false, 0, true);
			}
			
			stage.addEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
			stage.focus = stage;
		}
		
		public override function Die () {
			stop ();
			stage.removeEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown);
		}
		
		private function onBttClick (e:MouseEvent) {
			if (e.currentTarget == bttPlay) {
				m.GoGame ();
			} else if (e.currentTarget == bttCredits) {
				m.GoCredits ();
			}
		}
		
		private function onStageKeyDown (e:KeyboardEvent) {
			if (e.keyCode == Keyboard.SPACE) {
				m.GoGame ();
			}
		}
	}
}