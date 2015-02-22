package Code.Model.Game {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.media.*;
	import Code.*;
	import Code.Model.*;
	import Code.Model.Game.*;
	import Code.Model.Game.Entities.*;
	
	public final class M_GameScreen extends M_Screen {
		public static const screenWidth:int = 423;
		public static const screenHeight:int = 423;
		private static const gameOverDuration:int = 30;
		
		private static var muted:Boolean = false;
		
		private var efShape:Shape = new Shape ();
		
		public var world:World = new World ();
		
		public var qEngine:QuirkEngine = new QuirkEngine ();
		public var dEngine:DistortionEngine = new DistortionEngine ();
		
		public var gameOver:Boolean = false;
		private var gameOverDurationLeft:int = gameOverDuration;
		
		public var score:int = 0;
		public var mult:int = 0;
		
		private var volume:Number = 1;
		
		private var channel:SoundChannel;
		
		public override function Setup (arg:Object = null) {
			qEngine.addEventListener (ModelEvent.AddQuirk, onAddQuirk, false, 0, true);
			qEngine.addEventListener (ModelEvent.RemoveQuirk, onRemoveQuirk, false, 0, true);
			qEngine.addEventListener (ModelEvent.RequestMakeGenericEntity, onRequestMakeGenericEntity, false, 0, true);
			//qEngine.Setup ();
			
			dEngine.world = world;
			dEngine.addEventListener (ModelEvent.DistortionDone, onDistortionDone, false, 0, true);
			dEngine.addEventListener (ModelEvent.DistortionStart, onDistortionStart, false, 0, true);
			dEngine.Setup ();
			
			world.qEngine = qEngine;
			world.addEventListener (ModelEvent.MakeGenericEntity, onMakeGenericEntity, false, 0, true);
			world.addEventListener (ModelEvent.RemoveGenericEntity, onRemoveGenericEntity, false, 0, true);
			world.addEventListener (ModelEvent.GameOver, onGameOver, false, 0, true);
			world.addEventListener (ModelEvent.JumpLand, onJumpLand, false, 0, true);
			world.Setup ();
			
			channel = new Program.music ().play ();
			channel.addEventListener (Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
			
			var st:SoundTransform = new SoundTransform ();
			st.volume = (muted) ? 0 : 1;
			channel.soundTransform = st;
			
			setTimeout (On, 2);
		}
		
		public override function On (arg:Object = null) {
			efShape.addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
			qEngine.Setup ();
		}
		
		public override function Off () {
		
		}
		
		public override function Die () {
			channel.removeEventListener (Event.SOUND_COMPLETE, onSoundComplete);
			channel.stop ();
		}
		
		private function onFrame (e:Event) {
			if (gameOver == false) {
				qEngine.Update ();
				dEngine.Update ();
			}
			
			world.Update ();
			
			if (gameOver) {
				if (gameOverDurationLeft > 0) {
					gameOverDurationLeft--;
					volume -= 1 / gameOverDuration;
					var st:SoundTransform = new SoundTransform ();
					st.volume = volume * ((muted) ? 0 : 1);
					channel.soundTransform = st;
				} else {
					dispatchEvent (new ModelEvent (ModelEvent.GameOverOver));
				}
			} else {
				score += 7 * mult;
			}
		}
		
		private function onSoundComplete (e:Event) {
			channel.removeEventListener (Event.SOUND_COMPLETE, onSoundComplete);
			channel = new Program.music ().play ();
			channel.addEventListener (Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
			
			var st:SoundTransform = new SoundTransform ();
			st.volume = (muted) ? 0 : 1;
			channel.soundTransform = st;
		}
		
		private function onAddQuirk (e:ModelEvent) {
			var type:int = e.data;
			world.QuirkAdded (type);
			dispatchEvent (new ModelEvent (ModelEvent.AddQuirk, type));
		}
		
		private function onRemoveQuirk (e:ModelEvent) {
			var type:int = e.data;
			world.QuirkRemoved (type);
			dispatchEvent (new ModelEvent (ModelEvent.RemoveQuirk, type));
		}
		
		private function onRequestMakeGenericEntity (e:ModelEvent) {
			world.MakeGenericEntityByType (e.data);
		}
		
		private function onMakeGenericEntity (e:ModelEvent) {
			dispatchEvent (new ModelEvent (ModelEvent.MakeGenericEntity, e.data));
		}
		
		private function onRemoveGenericEntity (e:ModelEvent) {
			dispatchEvent (new ModelEvent (ModelEvent.RemoveGenericEntity, e.data));
		}
		
		private function onDistortionStart (e:ModelEvent) {
			dispatchEvent (new ModelEvent (ModelEvent.DistortionStart));
			world.DistortionStarted ();
			dEngine.Landed ();
			qEngine.frozen = true;
		}
		
		private function onDistortionDone (e:ModelEvent) {
			world.frozen = false;
			qEngine.frozen = false;
			dispatchEvent (new ModelEvent (ModelEvent.DistortionDone));
		}
		
		private function onGameOver (e:ModelEvent) {
			gameOver = true;
			world.gameOver = true;
			gameOverDurationLeft = gameOverDuration;
		}
		
		private function onJumpLand (e:ModelEvent) {
			mult++;
		}

		public function StageMouseDown () {
			if (gameOver == false) {
				world.StageMouseDown ();
			}
		}
		
		public function MusicKeyPressed () {
			if (gameOver == false) {
				muted = (muted) ? false : true;
				
				var st:SoundTransform = new SoundTransform ();
				st.volume = (muted) ? 0 : 1;
				channel.soundTransform = st;
			}
		}
		
		public function GoGame () {
			program.NewBigScreen (ScreenType.Game);
		}
		
		public function GoMenu () {
			program.NewBigScreen (ScreenType.Menu);
		}
	}
}