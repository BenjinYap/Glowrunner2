package Code.View.Game.Entities {
	import flash.events.*;
	import flash.display.*;
	import flash.geom.*;
	import Code.Model.Game.Entities.*;
	
	public class V_Runner extends V_Entity {
		
		public override function Setup (arg:Object = null) {
			scaleX = 0.15;
			scaleY = scaleX;
			
			for (var i:int = 0; i < numChildren; i++) {
				MovieClip (getChildAt (i)).gotoAndPlay ("Running");
			}
		}
		
		public override function On (arg:Object = null) {
			
		}
		
		public override function Update () {
			super.Update ();
			
			if (M_Runner (entityRef).onLand) {
				for (var i:int = 0; i < numChildren; i++) {
					var c:MovieClip = MovieClip (getChildAt (i));
				
					if (c.currentLabel == "JumpDone") {
						c.gotoAndPlay ("Running");
					}
				}
			} else {
				for (var i:int = 0; i < numChildren; i++) {
					var c:MovieClip = MovieClip (getChildAt (i));
					
					if (c.currentLabel != "Jumping" && entityRef.ySpeed < 0) {
						c.gotoAndPlay ("Jumping");
					}
				}
			}
		}
	}
}