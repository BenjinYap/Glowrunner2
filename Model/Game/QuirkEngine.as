package Code.Model.Game {
	import flash.events.*;
	import Code.Model.*;
	import Code.Model.Game.*;
	import Code.Model.Game.Entities.*;
	
	public final class QuirkEngine extends EventDispatcher {
		private static const debut:int = 300;
		private static const cooldown:int = 5;
		private static const quirkMaxCooldown:int = 450;
		private static const quirkMinCooldown:int = 150;
		private static const quirkCooldownIncrement:int = 15;
		
		private static const meteorCooldown:int = 5;
		private static const geyserCooldown:int = 30;
		private static const flashCooldown:int = 5;
		
		private var quirkStats:Array = [
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//dimmer
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//wanderstars
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//wanderdust
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//earthquake
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//meteor
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//geysers
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//nearsighted
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//spectral
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//topsy
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//reversedust
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//hacks
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//ballpit
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//seeingdoubles
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//floating
		{numBeforePerm:1, num:0, duration:450, cooldown:0},//flash
		];
		
		private var allowedQuirks:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];
		private var readyQuirks:Array = allowedQuirks.concat ();
		
		private var meteorCountdown:int = meteorCooldown;
		private var geyserCountdown:int = geyserCooldown;
		private var flashCountdown:int = flashCooldown;
		
		private var frame:int = 0;
		
		private var quirkCooldown:int = quirkMaxCooldown;
		private var quirkCountdown:int = quirkCooldown;
		private var activeQuirks:Array = [];
		
		public var frozen:Boolean = false;
		
		public function Setup () {
			//awd (QuirkType.WanderStars);
			//awd (QuirkType.WanderDust);
			//awd (QuirkType.Earthquake);
			//awd (QuirkType.MeteorShower);
			//awd (QuirkType.Nearsighted);
			//awd (QuirkType.Geysers);
			//awd (QuirkType.Dimmer);
			//awd (QuirkType.Topsy);
			//awd (QuirkType.Hacks);
			//awd (QuirkType.BallPit);
			//awd (QuirkType.ReverseDust);
			//awd (QuirkType.SeeingDoubles);
			//awd (QuirkType.Spectral);
			//awd (QuirkType.Floating);
			//awd (QuirkType.Flash);
		}
		
		public function Update () {
			if (frame < debut) {
				frame++;
			} else {
				if (frozen == false) {
					quirkCountdown--;
					
					for (var i:int = 0; i < activeQuirks.length; i++) {
						if (activeQuirks [i].durationLeft == 0) {
							RemoveQuirk (activeQuirks [i]);
							i--;
						} else {
							activeQuirks [i].durationLeft--;
						}
					}
					
					if (quirkCountdown == 0) {
						quirkCountdown = quirkCooldown;
						AddQuirk ();
					}
					
					
					
					if (IsQuirkActive (QuirkType.MeteorShower)) {
						if (meteorCountdown == 0) {
							meteorCountdown = meteorCooldown;
							dispatchEvent (new ModelEvent (ModelEvent.RequestMakeGenericEntity, GenericEntityType.Meteor));
						}
						
						meteorCountdown--;
					}
					
					if (IsQuirkActive (QuirkType.Geysers)) {
						if (geyserCountdown == 0) {
							geyserCountdown = geyserCooldown;
							dispatchEvent (new ModelEvent (ModelEvent.RequestMakeGenericEntity, GenericEntityType.Geyser));
						}
						
						geyserCountdown--;
					}
					
					if (IsQuirkActive (QuirkType.Flash)) {
						if (flashCountdown == 0) {
							flashCountdown = flashCooldown;
							dispatchEvent (new ModelEvent (ModelEvent.RequestMakeGenericEntity, GenericEntityType.Flash));
						}
						
						flashCountdown--;
					}
				}
			}
		}
		
		private function AddQuirk (type:int = -1) {
			
			if (type == -1) {
				type = readyQuirks [int (Math.random () * readyQuirks.length)];
			}
			
			readyQuirks.splice (readyQuirks.indexOf (type), 1);
			
			var quirk:Quirk = new Quirk ();
			quirk.Setup (type, quirkStats [type].duration);
			
			activeQuirks.push (quirk);
			quirkStats [type].num++;
			quirkStats [type].cooldown = cooldown;
			dispatchEvent (new ModelEvent (ModelEvent.AddQuirk, quirk.type));
			
			for (var i:int = 0; i < allowedQuirks.length; i++) {
				if (i != type) {
					if (quirkStats [allowedQuirks [i]].cooldown > 0) {
						quirkStats [allowedQuirks [i]].cooldown--;
					} else {
						if (readyQuirks.indexOf (allowedQuirks [i]) == -1) {
							readyQuirks.push (allowedQuirks [i]);
						}
					}
				}
			}
			
			DecreaseQuirkCooldown ();
		}
		
		private function awd (a:int) {
			AddQuirk (a);
		}
		
		private function RemoveQuirk (quirk:Quirk) {
			activeQuirks.splice (activeQuirks.indexOf (quirk), 1);
			dispatchEvent (new ModelEvent (ModelEvent.RemoveQuirk, quirk.type));
		}
		
		public function IsQuirkActive (type:int) {
			var isActive:Boolean = false;
			
			for (var i:int = 0; i < activeQuirks.length; i++) {
				if (activeQuirks [i].type == type) {
					isActive = true;
					break;
				}
			}
			
			return isActive;
		}
		
		public function DecreaseQuirkCooldown () {
			if (quirkCooldown > quirkMinCooldown) {
				quirkCooldown -= quirkCooldownIncrement;
			}
		}
	}
}