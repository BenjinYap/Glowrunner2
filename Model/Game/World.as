package Code.Model.Game {
	import flash.events.*;
	import flash.utils.*;
	import Code.Model.*;
	import Code.Model.Game.Entities.*;
	
	public final class World extends EventDispatcher {
		public var screenWidth:int = 423;
		public var screenHeight:int = 423;
		
		public var cam:WorldCamera = new WorldCamera ();
		
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var rotation:Number = 0;
		
		public var pool:Array = [];
		public var entities:Array = [];
		public var runner:M_Runner = new M_Runner ();
		public var lands:Array = [];
		public var stars:Array = [];
		public var dusts:Array = [];
		public var meteors:Array = [];
		public var geysers:Array = [];
		public var balls:Array = [];
		public var spectrals:Array = [];
		public var flashes:Array = [];
		
		public var landGapWidth:Number;
		public var minLandWidth:Number;
		public var maxLandHeightDiff:Number = 50;
		public var baseLandHeight:Number = 10000;
		
		private var minEntityXSpeed:Number;
		
		public var qEngine:QuirkEngine;
		
		public var frozen:Boolean = false;
		
		public var gameOver:Boolean = false;
		
		public function Setup () {
			landGapWidth = runner.xSpeed * 30 * 0.7;
			minLandWidth = runner.xSpeed * 30;
			
			minEntityXSpeed = (runner.xSpeed > 10) ? runner.xSpeed - 10 : 0;
			
			runner.worldY = -50;
			entities.push (runner);
			
			cam.SetTargetEntity (runner, 150, 0);
			
			setTimeout (MakeStuff, 1);
		}
		
		public function Update () {
			if (frozen == false) {
				cam.Update ();
				
				for (var i:int = 0; i < entities.length; i++) {
					entities [i].Update ();
				}
				
				var betweenLands:Boolean = true;
				
				for (var i:int = 0; i < lands.length; i++) {
					if (gameOver == false) {
						if (runner.ySpeed > 0) {
							if (runner.bounds.intersects (lands [i].bounds)) {
								if (runner.worldY + runner.height / 2 - runner.ySpeed > lands [i].worldY) {
									for (var j:int = 0; j < 70; j++) {
										MakeDust (runner.worldX, runner.worldY + runner.height / 2, -Math.random () * 5, -Math.random () * 10 - 5);
									}
									
									//runner.LandedOnLand (lands [i].worldY - 100);
									runner.LandedOnLand (runner.worldY);
									runner.xSpeed = 0;
									dispatchEvent (new ModelEvent (ModelEvent.GameOver));
								} else {
									if (runner.worldX + runner.xSpeed < lands [i].worldX + lands [i].width) {
										runner.LandedOnLand (lands [i].worldY - runner.height / 2);
										dispatchEvent (new ModelEvent (ModelEvent.JumpLand));
										
										for (var j:int = 0; j < 70; j++) {
											if (qEngine.IsQuirkActive (QuirkType.ReverseDust)) {
												MakeDust (runner.worldX, runner.worldY + runner.height / 2, Math.random () * 4 + 6 + minEntityXSpeed + 4, -Math.random () * 10 - 5);
											} else {
												MakeDust (runner.worldX, runner.worldY + runner.height / 2, Math.random () * 4 + 6 + minEntityXSpeed, -Math.random () * 10 - 5);
											}
										}
									}
								}
							}
						}
					}
					
					if (lands [i].bounds.x < runner.worldX - runner.width / 2 && lands [i].bounds.x + lands [i].bounds.width > runner.worldX + runner.width / 2) {
						betweenLands = false;
						break;
					}
					
					if (lands [i].worldX + lands [i].width + 100 < runner.worldX + cam.offsetX - screenWidth / 2) {
						RemoveGenericEntity (lands [i], lands, true);
						i--;
					}
				}
				
				if (gameOver == false) {
					if (betweenLands) {
						runner.onLand = false;
					}
					
					if (runner.onLand) {
						for (var i:int = 0; i < 5; i++) {
							if (qEngine.IsQuirkActive (QuirkType.ReverseDust)) {
								MakeDust (runner.worldX, runner.worldY + runner.height / 2, Math.random () * 10 + minEntityXSpeed + 10, -Math.random () * 7 - 3);
							} else {
								MakeDust (runner.worldX, runner.worldY + runner.height / 2, Math.random () * 10 + minEntityXSpeed, -Math.random () * 7 - 3);
							}
						}
					}
				}
				
				for (var i:int = 0; i < stars.length; i++) {
					if (stars [i].worldX + stars [i].width / 2 < cam.worldX - screenWidth / 2) {
						stars [i].SetCoords (cam.worldX + screenWidth / 2 + 50 + Math.random () * screenWidth, runner.worldY + Math.random () * (screenHeight) - screenHeight / 2);
						stars [i].width = Math.random () * 2 + 4;
						stars [i].height = stars [i].width;
						stars [i].wandering = false;
					}
					
					if (stars [i].worldY + stars [i].height / 2 < cam.worldY - screenHeight / 2 || stars [i].worldY - stars [i].height / 2 > cam.worldY + screenHeight / 2) {
						stars [i].SetCoords (runner.worldX + cam.offsetX + screenWidth / 2 + 50 + Math.random () * screenWidth, runner.worldY + Math.random () * (screenHeight) - screenHeight / 2);
						stars [i].width = Math.random () * 2 + 4;
						stars [i].height = stars [i].width;
						stars [i].wandering = false;
					}
					
					for (var j:int = 0; j < lands.length; j++) {
						if (lands [j].bounds.contains (stars [i].worldX, stars [i].worldY + stars [i].height / 2)) {
							stars [i].SetCoords (cam.worldX + screenWidth / 2 + Math.random () * screenWidth, runner.worldY + Math.random () * (screenHeight) - screenHeight / 2);
							stars [i].width = Math.random () * 2 + 4;
							stars [i].height = stars [i].width;
							stars [i].wandering = false;
						}
					}
					
					if (qEngine.IsQuirkActive (QuirkType.WanderStars)) {
						if (stars [i].wandering == false) {
							stars [i].wandering = true;
							stars [i].wanderXSpeed = Math.random () * 20 + minEntityXSpeed;
							stars [i].wanderYSpeed = Math.random () * 10 - 5;
						}
					}
				}
				
				for (var i:int = 0; i < dusts.length; i++) {
					for (var j:int = 0; j < lands.length; j++) {
						if ((lands [j].bounds.containsRect (dusts [i].bounds) && dusts [i].ySpeed > 0) || dusts [i].alpha <= 0 || dusts [i].worldX + dusts [i].width + 10 / 2 < cam.worldX - screenWidth / 2 || dusts [i].worldY + dusts [i].width / 2 < cam.worldY - screenHeight / 2) {
							dusts [i].worldY = lands [j].worldY - dusts [i].width / 2;
							RemoveGenericEntity (dusts [i], dusts, true);
							i--;
							break;
						}
						
						if (qEngine.IsQuirkActive (QuirkType.WanderDust)) {
							if (dusts [i].wandering == false) {
								dusts [i].wandering = true;
								dusts [i].wanderXSpeed = Math.random () * 20 + minEntityXSpeed;
								dusts [i].wanderYSpeed = -Math.random () * 7 - 3;
							}
						}
					}
				}
				
				var newestLand:M_Entity = lands [0];
				
				for (var i:int = 1; i < lands.length; i++) {
					newestLand = (lands [i].worldX > newestLand.worldX) ? lands [i] : newestLand;
				}
				
				if (newestLand.worldX < runner.worldX) {
					MakeNewLand (newestLand.worldX + newestLand.width + landGapWidth, minLandWidth + Math.random () * (minLandWidth * 3), newestLand.height + Math.random () * (maxLandHeightDiff * 2) - maxLandHeightDiff);
				}
				
				
				
				for (var i:int = 0; i < meteors.length; i++) {
					for (var j:int = 0; j < lands.length; j++) {
						if (lands [j].bounds.contains (meteors [i].worldX - meteors [i].xSpeed, meteors [i].worldY - meteors [i].ySpeed)) {
							if (meteors [i].worldX >= cam.worldX - screenWidth / 2 && meteors [i].worldX <= cam.worldX + screenWidth / 2) {
								for (var k:int = 0; k < 50; k++) {
									MakeDust (meteors [i].worldX, lands [j].worldY, Math.random () * 9, -Math.random () * 15 - 3, Math.random () * 3 + 3);
								}
							}
							
							RemoveGenericEntity (meteors [i], meteors, true);
							i--;
							break;
						} else if (meteors [i].worldX < cam.worldX - M_GameScreen.screenWidth / 2 || meteors [i].worldY > cam.worldY + M_GameScreen.screenHeight / 2) {
							RemoveGenericEntity (meteors [i], meteors, true);
							i--;
							break;
						}
					}
				}
				
				for (var i:int = 0; i < geysers.length; i++) {
					for (var j:int = 0; j < 2; j++) {
						MakeDust (geysers [i].worldX, geysers [i].worldY, Math.random () * 4 - 2, -Math.random () * 15 - 10, Math.random () * 7 + 3);
					}
					
					if (geysers [i].geyserDurationLeft == 0 || geysers [i].worldX < cam.worldX - screenWidth / 2) {
						RemoveGenericEntity (geysers [i], geysers, false);
						i--;
					}
				}
				
				if (qEngine.IsQuirkActive (QuirkType.BallPit)) {
					for (var i:int = 0; i < balls.length; i++) {
						if (balls [i].worldX + balls [i].width / 2 > M_GameScreen.screenWidth / 2 || balls [i].worldX - balls [i].width / 2 < -M_GameScreen.screenWidth / 2) {
							balls [i].xSpeed *= -1;
						}
						
						if (balls [i].worldY + balls [i].width / 2 > M_GameScreen.screenHeight / 2 || balls [i].worldY - balls [i].width / 2 < -M_GameScreen.screenHeight / 2) {
							balls [i].ySpeed *= -1;
						}
					}
				}
				
				if (qEngine.IsQuirkActive (QuirkType.Spectral)) {
					for (var i:int = 0; i < spectrals.length; i++) {
						if (spectrals [i].worldX < -M_GameScreen.screenWidth / 2 || spectrals [i].worldX > M_GameScreen.screenWidth / 2) {
							spectrals [i].xSpeed *= -1;
						}
						
						if (spectrals [i].worldY < -M_GameScreen.screenHeight / 2 || spectrals [i].worldY > M_GameScreen.screenHeight / 2) {
							spectrals [i].ySpeed *= -1;
						}
					}
				}

				for (var i:int = 0; i < flashes.length; i++) {
					flashes [i].alpha -= 0.07;
					
					if (flashes [i].alpha <= 0) {
						RemoveGenericEntity (flashes [i], flashes, true);
						i--;
					}
				}
			}
		}
		
		private function onMakeGenericEntity (e:ModelEvent) {
			dispatchEvent (new ModelEvent (ModelEvent.MakeGenericEntity, e.data));
		}
		
		private function onRemoveGenericEntity (e:ModelEvent) {
			dispatchEvent (new ModelEvent (ModelEvent.RemoveGenericEntity, e.data));
		}
		//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		public function QuirkAdded (type:int) {
			if (type == QuirkType.BallPit) {
				for (var i:int = 0; i < balls.length; i++) {
					balls [i].SetCoords (0, 0);
					var size:Number = Math.random () * 20 + 10;
					balls [i].SetSize (size, size);
					balls [i].xSpeed = Math.random () * 10 - 5;
					balls [i].ySpeed = Math.random () * 10 - 5;
				}
			} else if (type == QuirkType.Earthquake) {
				cam.earthquake = true;
			} else if (type == QuirkType.Nearsighted) {
				cam.BeginTween (1);
			} else if (type == QuirkType.Spectral) {
				for (var i:int = 0; i < spectrals.length; i++) {
					spectrals [i].SetCoords (0, 0);
					
					if (i < spectrals.length / 2) {
						spectrals [i].xSpeed = 0;
						spectrals [i].ySpeed = Math.random () * 10 - 5;
						spectrals [i].width = M_GameScreen.screenWidth;
						spectrals [i].height = 1;
					} else {
						spectrals [i].xSpeed = Math.random () * 10 - 5;
						spectrals [i].ySpeed = 0;
						spectrals [i].width = 1;
						spectrals [i].height = M_GameScreen.screenHeight;
					}
				}
			}
		}
		
		public function QuirkRemoved (type:int) {
			if (type == QuirkType.WanderDust) {
				for (var i:int = 0; i < dusts.length; i++) {
					dusts [i].wandering = false;
				}
			} else if (type == QuirkType.WanderStars) {
				for (var i:int = 0; i < stars.length; i++) {
					stars [i].wandering = false;
				}
			} else if (type == QuirkType.Earthquake) {
				cam.earthquake = false;
			} else if (type == QuirkType.BallPit) {
				for (var i:int = 0; i < balls.length; i++) {
					balls [i].worldX = 0;
					balls [i].worldY = 0;
					balls [i].xSpeed = 0;
					balls [i].ySpeed = 0;
				}
			} else if (type == QuirkType.Earthquake) {
				cam.earthquake = false;
			} else if (type == QuirkType.Nearsighted) {
				cam.BeginTween (-1);
			} else if (type == QuirkType.Spectral) {
				for (var i:int = 0; i < spectrals.length; i++) {
					spectrals [i].worldX = 0;
					spectrals [i].worldY = 0;
					spectrals [i].xSpeed = 0;
					spectrals [i].ySpeed = 0;
				}
			}
		}
		
		private function MakeStuff () {
			MakeHelpText ();
			MakeStars ();
			MakeBalls ();
			MakeNewLand (0, runner.xSpeed * 30 * 11, 10000);
			//MakeNewLand (0, runner.xSpeed * 30 * 1, 10000);
			MakeSpectrals ();
		}
		
		private function MakeHelpText () {
			var help:M_Entity = new M_Entity ();
			entities.push (help);
			help.SetGenericEntityType (GenericEntityType.HelpText);
			help.worldX = 300;
			help.worldY = -130;
			help.xSpeed = 6;
			dispatchEvent (new ModelEvent (ModelEvent.MakeGenericEntity, help));
		}
		
		private function MakeStars () {
			for (var i:int = 0; i < 30; i++) {
				var star:M_Entity = MakeGenericEntity (GenericEntityType.Star, stars, true);
				star.SetCoords (runner.worldX + Math.random () * screenWidth * 2, runner.worldY + Math.random () * (screenHeight) - screenHeight / 2);
				star.width = Math.random () * 2 + 4;
				star.height = star.width;
				dispatchEvent (new ModelEvent (ModelEvent.MakeGenericEntity, star));
			}
		}
		
		private function MakeBalls () {
			for (var i:int = 0; i < 20; i++) {
				var ball:M_Entity = MakeGenericEntity (GenericEntityType.Ball, balls);
			}
		}
		
		private function MakeNewLand (worldX:Number, width:Number, height:Number) {
			var land:M_Entity = MakeGenericEntity (GenericEntityType.Land, lands, true);
			land.SetCoords (worldX, baseLandHeight - height);
			land.SetSize (width, height);
			dispatchEvent (new ModelEvent (ModelEvent.MakeGenericEntity, land));
		}
		
		private function MakeSpectrals () {
			for (var i:int = 0; i < 10; i++) {
				var spectral:M_Entity = MakeGenericEntity (GenericEntityType.Spectral, spectrals);
			}
		}
		
		public function StageMouseDown () {
			if (runner.onLand) {
				runner.Jump ();
			}
		}
		
		private function MakeDust (x:Number, y:Number, xSpeed:Number, ySpeed:Number, diameter:Number = 3) {
			var dust:M_Entity = MakeGenericEntity (GenericEntityType.Dust, dusts, true);
			dust.SetCoords (x, y);
			dust.SetSize (diameter, diameter);
			dust.xSpeed = xSpeed;
			dust.ySpeed = ySpeed;
			
			dispatchEvent (new ModelEvent (ModelEvent.MakeGenericEntity, dust));
		}
		
		private function MakeGenericEntity (type:int, genEntityCont:Array, cancelDispatch:Boolean = false):M_Entity {
			var e:M_Entity;
			var inPool:Boolean = false;
			
			for (var i:int = 0; i < pool.length; i++) {
				if (pool [i].genEntityType == type) {
					inPool = true;
					e = pool [i];
					pool.splice (i, 1);
					break;
				}
			}
			
			(inPool == false) ? e = new M_Entity () : 1;
			e.SetGenericEntityType (type);
			entities.push (e);
			genEntityCont.push (e);
			(cancelDispatch) ? 1 : dispatchEvent (new ModelEvent (ModelEvent.MakeGenericEntity, e));
			return e;
		}
		
		private function RemoveGenericEntity (e:M_Entity, genEntityCont, dispatch:Boolean) {
			(dispatch) ? dispatchEvent (new ModelEvent (ModelEvent.RemoveGenericEntity, e)) : 1;
			entities.splice (entities.indexOf (e), 1);
			genEntityCont.splice (genEntityCont.indexOf (e), 1);
			pool.push (e);
		}
		
		public function MakeGenericEntityByType (type:int) {
			if (type == GenericEntityType.Meteor) {
				var meteor:M_Entity = MakeGenericEntity (GenericEntityType.Meteor, meteors, true);
				meteor.SetCoords (runner.worldX + Math.random () * (screenWidth * 2), cam.worldY - M_GameScreen.screenHeight / 2 - 20);
				meteor.SetSize (15, 15);
				meteor.xSpeed = minEntityXSpeed;
				meteor.ySpeed = 30;
				dispatchEvent (new ModelEvent (ModelEvent.MakeGenericEntity, meteor));
			} else if (type == GenericEntityType.Geyser) {
				var geyser:M_Entity = MakeGenericEntity (GenericEntityType.Geyser, geysers, true);
				var x:Number = cam.worldX + Math.random () * (screenWidth * 2);
				var y:Number;
				var xFloating:Boolean = true;
				
				while (xFloating) {
					for (var i:int = 0; i < lands.length; i++) {
						if (lands [i].bounds.x < x && lands [i].bounds.x + lands [i].bounds.width > x) {
							xFloating = false;
							y = lands [i].worldY;
							break;
						}
					}
					
					(xFloating) ? x = cam.worldX + Math.random () * (screenWidth * 2) : 1;
				}
				
				geyser.SetCoords (x, y);
			} else if (type == GenericEntityType.Flash) {
				var flash:M_Entity = MakeGenericEntity (GenericEntityType.Flash, flashes);
				flash.worldX = Math.random () * M_GameScreen.screenWidth - M_GameScreen.screenWidth / 2;
				flash.worldY = Math.random () * M_GameScreen.screenHeight - M_GameScreen.screenHeight / 2;
			}
		}
		
		public function DistortionStarted () {
			if (runner.xSpeed < 25) {
				runner.xSpeed++;
			}
			
			frozen = true;
			landGapWidth = runner.xSpeed * 30 * 0.6;
			minLandWidth = runner.xSpeed * 30;
			minEntityXSpeed = (runner.xSpeed > 10) ? runner.xSpeed - 10 : 0;
		}
	}
}