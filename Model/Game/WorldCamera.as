package Code.Model.Game {
	import flash.events.*;
	import flash.geom.*;
	import Code.Model.*;
	import Code.Model.Game.Entities.*;
	
	public final class WorldCamera extends EventDispatcher {
		private static const numIncrements:int = 60;
		
		public var worldX:Number = 0;
		public var worldY:Number = 0;
		
		public var target:M_Entity;
		public var offsetX:Number;
		public var offsetY:Number;
		
		public var currentOffsetX:Number;
		
		public var easeX:Number = 1;
		public var easeY:Number = 0.1;
		
		public var earthquake:Boolean = false;
		public var maxEarthquakeDistance:int = 20;
		
		public var earthquakeCooldown:int = 2;
		public var earthquakeCountdown:int = 0;
		
		public var increment:Number = 0;
		public var incrementCount:int;
		
		public function SetTargetEntity (t:M_Entity, oX:Number, oY:Number) {
			target = t;
			offsetX = oX;
			offsetY = oY;
			currentOffsetX = offsetX;
		}
		
		public function SetEase (x:Number, y:Number) {
			easeX = x;
			easeY = y;
		}
		
		public function Update () {
			if (target != null) {
				worldX += (target.worldX + currentOffsetX - worldX) * easeX;
				worldY += (target.worldY + offsetY - worldY) * easeY;
				
				if (incrementCount == 0) {
					increment = 0;
				} else {
					currentOffsetX += increment;
					incrementCount--;
				}
				
				if (earthquake) {
					if (earthquakeCountdown == 0) {
						worldX += Math.random () * (maxEarthquakeDistance * 2) - maxEarthquakeDistance;
						worldY += Math.random () * (maxEarthquakeDistance * 2) - maxEarthquakeDistance;
						earthquakeCountdown = earthquakeCooldown;
					}
					
					earthquakeCountdown--;
				}
			}
		}
		
		public function BeginTween (sign:int) {
			increment = sign * (30 - offsetX) / numIncrements;
			incrementCount = numIncrements;
		}
	}
}