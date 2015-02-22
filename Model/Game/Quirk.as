package Code.Model.Game {
	import flash.events.*;
	import Code.Model.*;
	
	public final class Quirk extends EventDispatcher {
		public var type:int;
		public var duration:int;
		public var durationLeft:int;
		
		public function Setup (t:int, d:int) {
			type = t;
			duration = d;
			durationLeft = duration;
		}
		
		public function Update () {
			durationLeft--;
			
			if (durationLeft == 0) {
				dispatchEvent (new ModelEvent (ModelEvent.RemoveQuirk));
			}
		}
	}
}