package Code.View.Credits {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import Code.View.*;
	import Code.Model.*;
	import Code.Model.Credits.*;
	
	public final class V_CreditScreen extends V_Screen {
		private var m:M_CreditScreen;
		
		private var btts:Array;
		
		public override function Setup () {
			m = M_CreditScreen (model);
			
			btts = [bttMenu];
			
			for (var i:int = 0; i < btts.length; i++) {
				btts [i].addEventListener (MouseEvent.CLICK, onBttClick, false, 0, true);
			}
		}
		
		private function onBttClick (e:MouseEvent) {
			if (e.currentTarget == bttMenu) {
				m.GoMenu ();
			}
		}
	}
}