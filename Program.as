package Code {
	import flash.display.*;
	import flash.geom.*;
	import mx.core.*;
	import Code.View.*;
	import Code.Model.*;
	
	public final class Program extends Sprite {
		[Embed (source = "../../music.mp3")]
		public static const music:Class;
		
		private var views:Array = [];
		
		public function Setup () {
			//NewBigScreen (ScreenType.Menu);
			NewBigScreen (ScreenType.Game);
		}
		
		public function NewBigScreen (type:int, arg:Object = null) {
			while (views.length > 0) {
				views [views.length - 1].model.Die ();
				views [views.length - 1].Die ();
				removeChild (views [views.length - 1]);
				views.splice (views.length - 1, 1);
			}
			
			ChangeScreen (type, arg);
		}
		
		public function AddModalScreen (type:int, arg:Object = null) {
			views [views.length - 1].Off ();
			views [views.length - 1].model.Off ();
			ChangeScreen (type, arg);
		}
		
		private function ChangeScreen (type:int, arg:Object = null) {
			var screen:M_Screen = new ScreenType.models [type] ();
			screen.SetProgram (this);
			screen.Setup (arg);
			
			var view:V_Screen = new ScreenType.views [type] ();
			views.push (view);
			view.SetModel (screen);
			addChild (view);
			view.Setup ();
		}
		
		public function RemoveModalScreen (arg:Object = null) {
			views [views.length - 1].Die ();
			views [views.length - 1].model.Die ();
			removeChild (views [views.length - 1]);
			views.pop ();
			
			views [views.length - 1].model.On ();
			views [views.length - 1].On (arg);
		}
	}
}