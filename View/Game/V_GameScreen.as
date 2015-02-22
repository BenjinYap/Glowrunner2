package Code.View.Game {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.*;
	import flash.utils.*;
	import Code.View.*;
	import Code.Model.*;
	import Code.Model.Game.*;
	import Code.Model.Game.Entities.*;
	import Code.View.Game.Entities.*;
	
	public final class V_GameScreen extends V_Screen {
		private var m:M_GameScreen;
		
		private var runner:V_Runner = new V_Runner ();
		
		private var entityCont:Sprite = new Sprite ();
		
		private var pool:Array = [];
		
		private var frame:int = 0;
		
		private var runnerRotateSpeed:int;
		
		private var hacking:Boolean = false;
		private var hackB:Bitmap = new Bitmap ();
		private var hacksYSpeed:Number = 3;
		
		private var b:Bitmap = new Bitmap ();
		private var bCont:Sprite = new Sprite ();
		
		public override function Setup () {
			m = M_GameScreen (model);
			
			m.addEventListener (ModelEvent.MakeGenericEntity, onMakeGenericEntity, false, 0, true);
			m.addEventListener (ModelEvent.RemoveGenericEntity, onRemoveGenericEntity, false, 0, true);
			m.addEventListener (ModelEvent.AddQuirk, onAddQuirk, false, 0, true);
			m.addEventListener (ModelEvent.RemoveQuirk, onRemoveQuirk, false, 0, true);
			m.addEventListener (ModelEvent.DistortionStart, onDistortionStart, false, 0, true);
			m.addEventListener (ModelEvent.DistortionDone, onDistortionDone, false, 0, true);
			m.addEventListener (ModelEvent.GameOverOver, onGameOverOver, false, 0, true);
			
			var bd:BitmapData = new BitmapData (423, 988, true, 0);
			bd.draw (txtHacks);
			hackB.bitmapData = bd;
			hackB.x = -M_GameScreen.screenWidth / 2;
			hackB.y = -hackB.height - M_GameScreen.screenHeight / 2;
			world.addChild (hackB);
			
			
			runner.SetReferences (m.world.runner, m.world.cam);
			runner.Setup ();
			entityCont.addChild (runner);
			
			world.addChildAt (entityCont, 0);
			
			bCont.x = 300;
			bCont.y = 300;
			addChild (bCont);
			
			world.mask = worldMask;
			
			world.dimmerCover.gotoAndStop (0);
			txtHacks.visible = false;
			txtHacks.text = "";
			On ();
			
			gameOverWindow.bttReplay.addEventListener (MouseEvent.CLICK, onBttClick, false, 0, true);
			gameOverWindow.bttMenu.addEventListener (MouseEvent.CLICK, onBttClick, false, 0, true);
			
			setInterval (awd, 1000);
		}
		
		public override function On (arg:Object = null) {
			addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
			
			stage.addEventListener (MouseEvent.MOUSE_DOWN, onStageMouseDown, false, 0, true);
			stage.addEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
			stage.focus = stage;
		}
		
		public override function Off () {
			removeEventListener (Event.ENTER_FRAME, onFrame);
			stage.removeEventListener (MouseEvent.MOUSE_DOWN, onStageMouseDown);
			stage.removeEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown);
		}
		
		public override function Die () {
			Off ();
		}
		
		private function onFrame (e:Event) {
			var s:String = "        ";
			txtScore.text = "x" + m.mult.toString () + s.substr (0, 1 + 3 - m.mult.toString ().length) + m.score.toString ();
			
			if (world.transform.colorTransform.color != m.dEngine.color) {
				var ct:ColorTransform = new ColorTransform ();
				ct.color = m.dEngine.color;
				world.transform.colorTransform = ct;
			}
			
			if (m.world.frozen == false) {
				for (var i:int = 0; i < entityCont.numChildren; i++) {
					var entity:V_Entity = V_Entity (entityCont.getChildAt (i));
					entity.Update ();
				}
				
				if (m.qEngine.IsQuirkActive (QuirkType.Topsy)) {
					runner.rotation += runnerRotateSpeed;
				}
				
				if (m.qEngine.IsQuirkActive (QuirkType.Hacks)) {
					hackB.y += hacksYSpeed;
				}
				
				frame++;
			} else {
				bCont.scaleX = m.world.scaleX;
				bCont.scaleY = m.world.scaleY;
				bCont.rotation = m.world.rotation;
				
				worldMask.scaleX = m.world.scaleX;
				worldMask.scaleY = m.world.scaleY;
				worldMask.rotation = m.world.rotation;
			}
			
			if (m.gameOver) {
				runner.visible = false;
			}
		}
		
		private function awd () {
			//txtScore.text = frame.toString ();
			frame = 0;
		}
		
		private function onMakeGenericEntity (e:ModelEvent) {
			var entityRef:M_Entity = M_Entity (e.data);
			
			var entity:V_Entity;
			var inPool:Boolean = false;
			
			if (pool.length > 0) {
				inPool = true;
				entity = pool [0];
				pool.splice (0, 1);
			}
			
			if (inPool == false) {
				entity = new V_Entity ();
			}
			
			entity.SetReferences (entityRef, m.world.cam);
			entityCont.addChild (entity);
			var o:Object = {floating:m.qEngine.IsQuirkActive (QuirkType.Floating)};
			entity.Setup (o);
		}
		
		private function onRemoveGenericEntity (e:ModelEvent) {
			for (var i:int = 0; i < entityCont.numChildren; i++) {
				var entity:V_Entity = V_Entity (entityCont.getChildAt (i));
				
				if (entity.entityRef == e.data) {
					entity.Die ();
					entityCont.removeChild (entity);
					pool.push (entity);
					break;
				}
			}
		}
		
		private function onDistortionStart (e:ModelEvent) {
			var startScaleX:Number = m.world.scaleX;
			var startScaleY:Number = m.world.scaleY;
			var startRotation:Number = m.world.rotation;
			
			world.scaleX = 1;
			world.scaleY = 1;
			world.rotation = 0;
			
			var bd:BitmapData = new BitmapData (600, 600, false, 0x000000);
			bd.draw (stage);
			
			var bd2:BitmapData = new BitmapData (M_GameScreen.screenWidth, M_GameScreen.screenHeight, false, 0x000000);
			bd2.copyPixels (bd, new Rectangle (300 - 423 / 2, 300 - 423 / 2, 423, 423), new Point ());
			
			b = new Bitmap (bd2);
			bCont.addChild (b);
			b.x = -423 / 2;
			b.y = -423 / 2;
			
			bCont.scaleX = startScaleX;
			bCont.scaleY = startScaleY;
			bCont.rotation = startRotation;
			bCont.visible = true;
			
			world.visible = false;
		}
		
		private function onDistortionDone (e:ModelEvent) {
			bCont.visible = false;
			
			world.scaleX = m.world.scaleX;
			world.scaleY = m.world.scaleY;
			world.rotation = m.world.rotation;
			world.visible = true;
		}
		
		private function onStageMouseDown (e:MouseEvent) {
			m.StageMouseDown ();
		}
		
		private function onStageKeyDown (e:KeyboardEvent) {
			if (e.keyCode == Keyboard.SPACE) {
				if (m.gameOver) {
					m.GoGame ();
				} else {
					m.StageMouseDown ();
				}
			} else if (e.keyCode == 77) {
				m.MusicKeyPressed ();
			}
		}
		
		private function onAddQuirk (e:ModelEvent) {
			var type:int = e.data;
			
			if (type == QuirkType.Dimmer) {
				world.dimmerCover.gotoAndPlay ("On");
			} else if (type == QuirkType.Topsy) {
				runnerRotateSpeed = Math.random () * 40 - 20;
			} else if (type == QuirkType.Hacks) {
				hacking = true;
				hackB.y = -hackB.height - M_GameScreen.screenHeight / 2;
			} else if (type == QuirkType.BallPit) {
				for (var i:int = 0; i < entityCont.numChildren; i++) {
					var entity:V_Entity = V_Entity (entityCont.getChildAt (i));
					
					if (entity.entityRef.genEntityType == GenericEntityType.Ball) {
						entity.Setup ();
						entity.visible = true;
					}
				}
			} else if (type == QuirkType.SeeingDoubles) {
				runner.gotoAndPlay ("DoubleStart");
			} else if (type == QuirkType.Spectral) {
				for (var i:int = 0; i < entityCont.numChildren; i++) {
					var entity:V_Entity = V_Entity (entityCont.getChildAt (i));
					
					if (entity.entityRef.genEntityType == GenericEntityType.Spectral) {
						entity.Setup ();
						entity.visible = true;
					}
				}
			}
		}
		
		private function onRemoveQuirk (e:ModelEvent) {
			var type:int = e.data;
			
			if (type == QuirkType.Dimmer) {
				world.dimmerCover.gotoAndPlay ("Off");
			} else if (type == QuirkType.Hacks) {
				hacking = false;
				hackB.y = -hackB.height - M_GameScreen.screenHeight / 2;
			} else if (type == QuirkType.BallPit) {
				for (var i:int = 0; i < entityCont.numChildren; i++) {
					var entity:V_Entity = V_Entity (entityCont.getChildAt (i));
					
					if (entity.entityRef.genEntityType == GenericEntityType.Ball) {
						entity.visible = false;
					}
				}
			} else if (type == QuirkType.SeeingDoubles) {
				runner.gotoAndPlay ("DoubleEnd");
			} else if (type == QuirkType.Spectral) {
				for (var i:int = 0; i < entityCont.numChildren; i++) {
					var entity:V_Entity = V_Entity (entityCont.getChildAt (i));
					
					if (entity.entityRef.genEntityType == GenericEntityType.Spectral) {
						entity.visible = false;
					}
				}
			}
		}
		
		private function onGameOverOver (e:ModelEvent) {
			gameOverWindow.x = 0;
			gameOverWindow.txtScore.text = m.score.toString ();
		}
		
		private function onBttClick (e:MouseEvent) {
			if (e.currentTarget == gameOverWindow.bttReplay) {
				m.GoGame ();
			} else if (e.currentTarget == gameOverWindow.bttMenu) {
				m.GoMenu ();
			}
		}
	}
}