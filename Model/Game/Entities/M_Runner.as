package Code.Model.Game.Entities {
	import flash.events.*;
	import flash.geom.*;
	import Code.Model.Game.Entities.*;
	
	public final class M_Runner extends M_Entity {
		public var jumpSpeed:int = 15;
		public var onLand:Boolean = false;
		
		public function M_Runner () {
			xSpeed = 10;
			width = 21;
			height = 36;
		}
		
		public override function Update () {
			worldX += xSpeed;
			worldY += ySpeed;
			
			bounds.x = worldX - width / 2;
			bounds.y = worldY - height / 2;
			bounds.width = width;
			bounds.height = height;
			
			
			
			if (onLand == false) {
				ySpeed++;
			}
		}
		
		public function ReverseXSpeed () {
			xSpeed *= -1;
		}
		
		public function IncreaseXSpeed () {
			xSpeed += 5;
		}
		
		public function Jump () {
			ySpeed = -jumpSpeed;
			onLand = false;
		}
		
		public function LandedOnLand (newWorldY:Number) {
			worldY = newWorldY;
			onLand = true;
			ySpeed = 0;
		}
	}
}