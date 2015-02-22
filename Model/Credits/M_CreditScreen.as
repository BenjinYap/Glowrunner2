package Code.Model.Credits {
	import flash.events.*;
	import Code.*;
	import Code.Model.*;
	
	public final class M_CreditScreen extends M_Screen {
		
		public override function Setup (arg:Object = null) {
			
		}
		
		public function GoMenu () {
			program.RemoveModalScreen ();
		}
	}
}