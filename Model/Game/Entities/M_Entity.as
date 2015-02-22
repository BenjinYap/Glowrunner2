package Code.Model.Game.Entities {
	import flash.events.*;
	import flash.geom.*;
	import Code.Model.Game.*;
	import Code.Model.Game.Entities.*;
	
	public class M_Entity {
		private static const geyserDuration:int = 600;
		
		public var genEntityType:int;
		
		public var screenWidth:Number;
		public var screenHeight:Number;
		
		public var worldX:Number = 0;
		public var worldY:Number = 0;
		
		public var xSpeed:Number = 0;
		public var ySpeed:Number = 0;
		
		public var width:Number = 0;
		public var height:Number = 0;
		
		public var bounds:Rectangle = new Rectangle ();
		
		public var alpha:Number = 1;
		
		public var wandering:Boolean = false;
		public var wanderXSpeed:Number;
		public var wanderYSpeed:Number;
		
		public var geyserDurationLeft:int = geyserDuration;
		
		public function SetGenericEntityType (type:int) {
			genEntityType = type;
			alpha = 1;
			wandering = false;
			geyserDurationLeft = geyserDuration;
		}
		
		public function SetCoords (x:Number, y:Number) {
			worldX = x;
			worldY = y;
		}
		
		public function SetSize (w:Number, h:Number) {
			width = w;
			height = h;
		}
		
		public function SetScreenSize (width:Number, height:Number) {
			screenWidth = width;
			screenHeight = height;
		}
		
		public function Update () {
			bounds.x = worldX;
			bounds.y = worldY;
			bounds.width = width;
			bounds.height = height;
			
			if (wandering) {
				worldX += wanderXSpeed;
				worldY += wanderYSpeed;
			} else {
				worldX += xSpeed;
				worldY += ySpeed;
				
				if (genEntityType == GenericEntityType.Dust) {
					ySpeed++;
				}
			}
			
			if (genEntityType == GenericEntityType.Geyser) {
				(geyserDurationLeft > 0) ? geyserDurationLeft-- : 1;
			}
		}
	}
}