package Code.Model.Game {
	import flash.events.*;
	import Code.Model.*;
	import Code.Model.Game.*;
	import Code.Model.Game.Entities.*;
	
	public final class DistortionEngine extends EventDispatcher {
		private static const debut:int = 300;
		private static const colors:Array = [0xFF0000, 0xFFFF00, 0x0000FF, 0x00FFFF, 0xFF00FF, 0x00FF00, 0xFFFFFF];
		private static const cooldown:int = 450;
		//private static const cooldown:int = 6000;
		private static const duration:int = 15;
		
		public var color:Number = 0xFF0000;
		
		private var countdown:int = cooldown;
		
		private var distorting:Boolean = false;
		private var durationLeft:int;
		
		public var world:World;
		
		public var activeDistortions:Array = [];
		
		private var targetScaleX:int = 1;
		private var scaleXIncrement:Number = 0;
		
		private var targetScaleY:int = 1;
		private var scaleYIncrement:Number = 0;
		
		public var targetRotation:int = 0;
		private var rotationIncrement:Number = 0;
		
		private var frame:int = 0;
		
		public function Setup () {
			
		}
		
		public function Update () {
			if (frame < debut) {
				frame++;
			} else {
				if (countdown > 0) {
					countdown--;
				} else if (countdown == 0) {
					countdown = -1;
					dispatchEvent (new ModelEvent (ModelEvent.DistortionStart));
					Landed ();
				}
				
				if (distorting) {
					if (durationLeft > 0) {
						durationLeft--;
						(scaleXIncrement != 0) ? world.scaleX += scaleXIncrement : 1;
						(scaleYIncrement != 0) ? world.scaleY += scaleYIncrement : 1;
						(rotationIncrement != 0) ? world.rotation += rotationIncrement : 1;
					} else {
						distorting = false;
						countdown = cooldown;
						activeDistortions = [];
						world.scaleX = targetScaleX;
						world.scaleY = targetScaleY;
						world.rotation = targetRotation;
						
						scaleXIncrement = 0;
						scaleYIncrement = 0;
						rotationIncrement = 0;
						
						dispatchEvent (new ModelEvent (ModelEvent.DistortionDone));
					}
				}
			}
		}
		
		public function Landed () {
			distorting = true;
			durationLeft = duration;
			
			while (activeDistortions.length == 0) {
				for (var i:int = 0; i < 3; i++) {
					var rand:int = Math.random () * 3;
					
					if (activeDistortions.indexOf (rand) == -1) {
						activeDistortions.push (rand);
					}
				}
			}
			
			if (activeDistortions.indexOf (DistortionType.X) != -1) {
				do {
					if (Math.random () < 0.5) {
					
					}
					targetScaleX = (Math.random () < 0.5) ? -1 : 1;
				} while (world.scaleX == targetScaleX);
				
				scaleXIncrement = (targetScaleX - world.scaleX) / duration;
			}
			
			if (activeDistortions.indexOf (DistortionType.Y) != -1) {
				do {
					targetScaleY = (Math.random () < 0.5) ? -1 : 1;
				} while (world.scaleY == targetScaleY);
				
				scaleYIncrement = (targetScaleY - world.scaleY) / duration;
			}
			
			if (activeDistortions.indexOf (DistortionType.Rotation) != -1) {
				targetRotation = Math.random () * 360;
				rotationIncrement = (targetRotation - world.rotation) / duration;
			}
			
			var newColor:Number = color;
			
			while (newColor == color) {
				newColor = colors [int (Math.random () * colors.length)];
			}
			
			color = newColor;
		}
	}
}