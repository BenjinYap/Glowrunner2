package Code.View.Game.Entities {
	import flash.events.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	import Code.Model.Game.*;
	import Code.Model.Game.Entities.*;
	
	public class V_Entity extends MovieClip {
		private static const noResizeTypes:Array = [GenericEntityType.Land, GenericEntityType.HelpText, GenericEntityType.Spectral, GenericEntityType.Flash];
		
		public var entityRef:M_Entity;
		public var camRef:WorldCamera;
		
		public function SetReferences (e:M_Entity, c:WorldCamera) {
			entityRef = e;
			camRef = c;
			x = entityRef.worldX - camRef.worldX;
			y = entityRef.worldY - camRef.worldY;
		}
		
		public function Setup (arg:Object = null) {
			var g:Graphics = graphics;
			g.clear ();
			
			var glow:GlowFilter = new GlowFilter ();
			glow.color = 0xFF0000;
			filters = [glow];
			
			if (entityRef.genEntityType == GenericEntityType.Star) {
				g.lineStyle (2, 0xFF0000);
				g.beginFill (0xFF0000);
				g.drawCircle (1, 1, (entityRef.width / 2) - 1);
				g.endFill ();
			} else if (entityRef.genEntityType == GenericEntityType.Dust) {
				g.beginFill (0xFF0000);
				g.drawCircle (0, 0, entityRef.width / 2);
				g.endFill ();
			} else if (entityRef.genEntityType == GenericEntityType.Land) {
				g.lineStyle (2, 0xFF0000);
				
				if (arg.floating) {
					g.moveTo (1, 1);
					g.lineTo (1, 600);
					g.moveTo (entityRef.width - 1, 1);
					g.lineTo (entityRef.width - 1, 600);
				} else {
					g.drawRect (1, 1, entityRef.width - 2, 600);
				}
			} else if (entityRef.genEntityType == GenericEntityType.Meteor) {
				g.beginFill (0xFFFF00);
				g.drawCircle (1, 1, entityRef.width - 2);
				g.endFill ();
			} else if (entityRef.genEntityType == GenericEntityType.Ball) {
				g.beginFill (0xFF0000);
				g.drawCircle (0, 0, entityRef.width / 2);
				g.endFill ();
			} else if (entityRef.genEntityType == GenericEntityType.HelpText) {
				addChild (new mcHelpText ());
			} else if (entityRef.genEntityType == GenericEntityType.Spectral) {
				if (entityRef.width < entityRef.height) {
					g.lineStyle (entityRef.width, 0xFF0000);
					g.moveTo (0, -entityRef.height / 2);
					g.lineTo (0, entityRef.height / 2);
				} else {
					g.lineStyle (entityRef.height, 0xFF0000);
					g.moveTo (-entityRef.width / 2, 0);
					g.lineTo (entityRef.width / 2, 0);
				}
			} else if (entityRef.genEntityType == GenericEntityType.Flash) {
				addChild (new mcFlashSkin ());
			}
			
			if (noResizeTypes.indexOf (entityRef.genEntityType) == -1) {
				width = entityRef.width;
				height = entityRef.height;
			}
		}
		
		public function On (arg:Object = null) {
			
		}
		
		public function Off () {
			
		}
		
		public function Die () {
			filters = [];
			
			while (numChildren > 0) {
				removeChildAt (0);
			}
		}
		
		public function Update () {
			var screenLockedTypes:Array = [GenericEntityType.Ball, GenericEntityType.Spectral, GenericEntityType.Flash];
			
			if (screenLockedTypes.indexOf (entityRef.genEntityType) == -1) {
				x = entityRef.worldX - camRef.worldX;
				y = entityRef.worldY - camRef.worldY;
			} else {
				x = entityRef.worldX;
				y = entityRef.worldY;
			}
			
			if (entityRef.genEntityType != GenericEntityType.Dust) {
				alpha = entityRef.alpha;
			}
			
			if (noResizeTypes.indexOf (entityRef.genEntityType) == -1) {
				width = entityRef.width;
				height = entityRef.height;
			}
		}
	}
}