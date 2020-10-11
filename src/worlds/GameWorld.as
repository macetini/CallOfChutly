package worlds
{
	import entities.*;
	import entities.allies.*;
	import entities.enemies.*;
	import entities.enemies.interfaces.*;
	import entities.hud.*;
	import entities.points.*;
	import entities.points.planets.*;
	import meta.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import UI.*;
	import util.*;
	
	/**
	 * 
	 * Base World class that all other level world classes derive from.
	 * 
	 * @author Marko Cetinic
	 */
	
	public class GameWorld extends World
	{
		/**
		 * Small lightning distance. If the distance between target and player is higer than SMALL_LIGHTNING_HIT_DISTANCE
		 * effect is removed
		 */
		public static const SMALL_LIGHTNING_HIT_DISTANCE:uint = 145;
		
		/**
		 * Shield effect duration
		 */
		public static const SHIELD_DURATION:Number = 3.5;
		
		/**
		 * Shield effect color
		 */
		public static const SHIELD_COLOR:uint = 0xE65CD2;
		
		public static const HUD_COINT_COUNT_TEXT_SIZE:uint = 24;
		
		/**
		 * Min Single Entity Spawn Rate
		 */
		public static var SingleMinSpawnRate:Number = 2;
		
		/**
		 * Max SingleEntity Spawn Rate
		 */
		public static var SingleMaxdSpawnRate:Number = 2.75;
		
		/**
		 * Min Multy Entity Spawn Rate
		 */
		public var MultyMinSpawnRate:Number = 0.5;
		
		/**
		 * Max Multy Entity Spawn Rate
		 */
		public var MultyMaxSpawnRate:Number = 0.75;
		
		/**
		 * Single Entity Spawn Time Counter
		 */
		protected var _singleTimeLeft:Number;
		
		/**
		 * Multy Entity Spawn Time Counter
		 */
		protected var _multyTimeLeft:Number;
		
		/**
		 * Last element spawned
		 */
		protected var _lastSingleSpawned:Entity = null;
		
		/**
		 * Player
		 */
		protected var _chutly:Chutly;
		
		/**
		 * Shield effect entity
		 */
		protected var _shield:Shield = null;
		
		/**
		 * Shield time counter
		 */
		protected var _shieldCounter:Number;
		
		/**
		 * Game options
		 */
		protected var _optionsEntity:OptionsDialogEntity;
		
		//HUD
		protected var _hudCoinIcon:Image;
		protected var _hudCoinCount:NiceTextEnt;
		
		protected var _hudSoundIconEntity:SoundIconEntity;
		protected var _healthIcons:Vector.<Entity>;
		
		public function GameWorld()
		{
			super();
			
			GameVariables.Score = 0;
			GameVariables.ChutlyHealth = GameConstants.CHUTLY_MAX_HEALTH;
			
			GameVariables.BackgroundImage.randomizeContnet();
			
			this._shieldCounter = 0;
			this._singleTimeLeft = 1;
			this._multyTimeLeft = 1;
			
			this._chutly = new Chutly();
		}
		
		/**
		 *
		 * ResourcesUtil helper function
		 *
		 * @param resourceName resource key.
		 *
		 * @see ResourceUtil
		 *
		 * @return string from resource bundle
		 *
		 */
		public function grs(resourceName:String):String
		{
			return ResourcesUtil.grs(resourceName);
		}
		
		override public function begin():void
		{
			this.addGraphic(new Backdrop(GameVariables.BackgroundImage.content));
			
			this._hudCoinCount = new NiceTextEnt("x0/" + GameVariables.NextLevelScore, 58, 10);
			this._hudCoinCount.textGraphic.size = HUD_COINT_COUNT_TEXT_SIZE;
			this.add(_hudCoinCount);
			
			this._hudCoinIcon = new Image(GraphicConstants.BRONZE_COIN);
			this.addGraphic(_hudCoinIcon);
			
			this._hudSoundIconEntity = new SoundIconEntity;
			this._hudSoundIconEntity.x = FP.width - 210;
			this.add(this._hudSoundIconEntity);
			
			//Set up healts
			this._healthIcons = new Vector.<Entity>();
			
			this._healthIcons.push(this.addGraphic(new Image(GraphicConstants.HUD_HEART_FULL)));
			this._healthIcons.push(this.addGraphic(new Image(GraphicConstants.HUD_HEART_FULL)));
			this._healthIcons.push(this.addGraphic(new Image(GraphicConstants.HUD_HEART_FULL)));
			
			updateHealth();
			
			//this._chutly = new Chutly();
			_chutly.x = FP.halfWidth - _chutly.halfWidth;
			_chutly.y = FP.halfHeight - _chutly.halfHeight;
			this.add(_chutly);
			
			super.begin();
		}
		
		/**
		 * Update health icon after hit
		 * 
		 * @see hitChutly()
		 */
		protected function updateHealth():void
		{
			for (var i:uint = 0; i < 3; i++)
			{
				if (GameVariables.ChutlyHealth > i)
					this._healthIcons[i].graphic = new Image(GraphicConstants.HUD_HEART_FULL);
				else
					this._healthIcons[i].graphic = new Image(GraphicConstants.HUD_HEART_EMPTY);
				
				this._healthIcons[i].x = FP.width - 53 * (i + 1);
			}
		}
		
		/**
		 * Called when player is hit by enemy
		 * 
		 * @param	entity  Enemy that hit player
		 */
		protected function hitChutly(entity:Entity = null):void
		{
			if (entity != null)
				(entity as IEnemy).die();
			
			if (GameVariables.ChutlyHealth > 0 && _chutly.collidable && this._shield == null)
			{
				GameVariables.ChutlyHealth--;
				updateHealth();
				this._chutly.hit();
			}
			
			if (GameVariables.ChutlyHealth == 0 && _chutly.collidable)
				this._chutly.die();
		}
		
		/**
		 * Multy spawn generator.
		 * 
		 * @return New multy spawn class
		 */
		protected function returnMultySpawn():Class
		{
			var spawn:Class = WeightUtil.returnMultySpawn();
			
			return spawn;
		}
		
		/**
		 * Single spawn
		 * 
		 * @return New single spawn class
		 */
		protected function returnSingleSpawn():Class
		{
			var spawn:Class = WeightUtil.returnSingleSpawn();
			
			// I player at full life no need for life
			if (spawn == Life)
			{
				if (GameVariables.ChutlyHealth == 3)
					return null;
				
				spawn.TimeOutCounter = spawn.TIMEOUT;
			}
			
			if (this._lastSingleSpawned != null && this._lastSingleSpawned.getClass() == spawn)
				return null;
			
			var enemyList:Array = new Array;
			
			var enemies:Array = [Comet, Ship, Missile, FlyingSpaMonst];
			
			//if no enemies present no need fo Lightning star
			if (spawn == LightningStar)
			{
				for each (var enemy:Class in enemies)
					getClass(enemy, enemyList);
				
				if (enemyList.length == 0)
					return null;
			}
			
			enemyList = new Array;
			
			FP.world.getClass(spawn, enemyList);
			
			if (enemyList.length > 0)
				return null;
			
			if (spawn == ShieldStar && this._shield != null)
				return null;
			
			return spawn;
		}
		
		/**
		 * New spawn genrator
		 */
		protected function updateSpawn():void
		{
			//Update single spawn Timeout
			WeightUtil.updateTimeOut(WeightUtil.singleSpawnArr, FP.elapsed);
			
			if (WeightUtil.singleSpawnArr.length > 0)
				this._singleTimeLeft -= FP.elapsed;
			
			this._multyTimeLeft -= FP.elapsed;
			
			var spawn:Class;
			
			if (this._multyTimeLeft <= 0)
			{
				spawn = WeightUtil.returnMultySpawn();
				
				if (spawn != null)
				{
					this._lastSingleSpawned = this.create(spawn, true);
					this._multyTimeLeft = FP.random * (MultyMaxSpawnRate - MultyMinSpawnRate) + MultyMinSpawnRate;
				}
			}
			
			if (_singleTimeLeft <= 0)
			{
				spawn = returnSingleSpawn();
				
				if (spawn != null)
				{
					this._lastSingleSpawned = this.create(spawn, true);
					
					if (_lastSingleSpawned.type == FlyingSpaMonst.TYPE && this.classCount(Chutly) > 0)
						(_lastSingleSpawned as FlyingSpaMonst).target = _chutly;
					
					this._singleTimeLeft = FP.random * (SingleMaxdSpawnRate - SingleMinSpawnRate) + SingleMinSpawnRate;
				}
			}
		}
		
		/**
		 * Pause game and show options.
		 */
		public function pauseUnpauseGame():void
		{
			GameVariables.Pause = !GameVariables.Pause;
			
			if (!GameVariables.Pause)
			{
				this.remove(_optionsEntity);
				_optionsEntity = null;
			}
			else
			{
				_optionsEntity = new OptionsDialogEntity;
				this.add(_optionsEntity);
			}
		}
		
		/**
		 * Update mute music text.
		 * 
		 * @see entities.hud.SoundIconEntity
		 * 
		 */
		public function updateMuteMusicTextEntity():void
		{
			if (GameVariables.MuteMusic)
			{
				if (_optionsEntity != null)
					_optionsEntity.muteMusicEntity.textGraphic.text = grs("muteEffects_l1");
				
			}
			else
			{
				if (_optionsEntity != null)
					_optionsEntity.muteMusicEntity.textGraphic.text = grs("muteEffects_l2");
			}
		}
		
		/**
		 * Mute or unmute music
		 */
		public function muteUnMuteMusic():void
		{
			if (GameVariables.MuteMusic)
			{
				SoundUtil.unMuteMusic();
				GameVariables.MuteLevel++;
			}
			else
			{
				SoundUtil.muteMusic();
				GameVariables.MuteLevel--;
			}
			
			updateMuteMusicTextEntity();
			_hudSoundIconEntity.updateSoundIconImage();
		}
		
		/**
		 * Mute music text click handler.
		 */
		protected function checkForMuteMusicTextClick():void
		{
			if (Input.mouseReleased)
			{
				var muteMusicTextEntity:Entity = FP.world.collidePoint(OptionsDialogEntity.MUTE_MUSIC_TEXT_ENT_TYPE, FP.world.mouseX, FP.world.mouseY);
				
				if (muteMusicTextEntity != null)
					muteUnMuteMusic();
			}
		}
		
		/**
		 * Update effect text entity.
		 * 
		 * @see entities.hud.SoundIconEntity
		 */
		public function updateMuteEffectTextEntity():void
		{
			if (GameVariables.MuteEffects)
			{
				if (_optionsEntity != null)
					_optionsEntity.muteEffectsEntity.textGraphic.text = grs("muteEffects_l1");
				
			}
			else
			{
				if (_optionsEntity != null)
					_optionsEntity.muteEffectsEntity.textGraphic.text = grs("muteEffects_l2");
			}
		}
		
		/**
		 * Mute or un mute effects.
		 */
		public function muteUnMuteEffects():void
		{
			if (GameVariables.MuteEffects)
			{
				SoundUtil.unMuteEffects();
				GameVariables.MuteLevel++;
			}
			else
			{
				SoundUtil.muteEffects();
				GameVariables.MuteLevel--;
			}
			
			_hudSoundIconEntity.updateSoundIconImage();
			updateMuteEffectTextEntity();
		}
		
		/**
		 * Mute effects text handler.
		 */
		protected function checkForMuteEffectsTextClick():void
		{
			if (Input.mouseReleased)
			{
				var muteEffectsTextEntity:Entity = FP.world.collidePoint(OptionsDialogEntity.MUTE_EFFECTS_TEXT_ENT_TYPE, FP.world.mouseX, FP.world.mouseY);
				
				if (muteEffectsTextEntity != null)
					muteUnMuteEffects();
			}
		}
		
		/**
		 * Eat point handler.
		 * 
		 * @param	points point value that is added to the GameVariables.Score.
		 */
		protected function eat(points:int):void
		{
			//SoundUtil.playEat1();
			
			switch (points)
			{
				case BluePlanet.VALUE: 
					SoundUtil.playEat1();
					break;
				case GreenPlanet.VALUE: 
					SoundUtil.playEat2();
					break;
				case DeadPlanet.VALUE: 
					SoundUtil.playBurp();
					break;
				case ElderOne.VALUE: 
					SoundUtil.playEat3();
					break;
			}
			
			if (GameVariables.Score + points <= 0)
				GameVariables.Score = 0;
			else
				GameVariables.Score += points;
			
			if (GameVariables.Score >= GameVariables.NextLevelScore)
			{
				LevelsUtil.nextLevelInfo();
			}
			else
				this._hudCoinCount.textGraphic.text = "x" + GameVariables.Score.toString() + "/" + GameVariables.NextLevelScore;
		}
		
		/**************************************************************************************
		
		Collision checks
		
		**************************************************************************************/
		
		protected function checkForPlanetCollision():void
		{
			var collisionPlanet:Entity = _chutly.collideTypes(Planet.TYPE, _chutly.x, _chutly.y) as Entity;
			if (collisionPlanet != null && _chutly.collidable)
			{
				eat(collisionPlanet.getClass().VALUE as int);
				this.remove(collisionPlanet as Entity);
			}
		}
		
		protected function checkForCometCollision():void
		{
			var collisionComet:Comet = _chutly.collideTypes(Comet.TYPE, _chutly.x, _chutly.y) as Comet;
			if (collisionComet != null && _chutly.collidable)
				hitChutly(collisionComet);
		}
		
		protected function checkForShipCollision():void
		{
			var collisionShip:Ship = _chutly.collideTypes(Ship.TYPE, _chutly.x, _chutly.y) as Ship;
			if (collisionShip != null && _chutly.collidable)
			{
				SoundUtil.playSmallLightning();
				this._chutly.hitWithLightning(collisionShip, 0xFFFF00, SMALL_LIGHTNING_HIT_DISTANCE);
				collisionShip.die();
			}
		}
		
		protected function checkForMissleCollision():void
		{
			var collisionMissile:Missile = _chutly.collideTypes(Missile.TYPE, _chutly.x, _chutly.y) as Missile;
			if (collisionMissile != null && _chutly.collidable)
				hitChutly(collisionMissile);
		}
		
		protected function checkForLifeCollision():void
		{
			var collisionLife:Life = _chutly.collideTypes(Life.TYPE, _chutly.x, _chutly.y) as Life;
			if (collisionLife != null && _chutly.collidable)
			{
				Life.TimeOutCounter = Life.Timeout;
				
				if (GameVariables.ChutlyHealth > 0)
				{
					SoundUtil.playPickUpLifeSound();
					
					GameVariables.ChutlyHealth++;
					updateHealth();
					
					this.remove(collisionLife);
				}
			}
		}
		
		protected function checkForLightningCollision():void
		{
			var collisionLightning:LightningStar = _chutly.collideTypes(LightningStar.TYPE, _chutly.x, _chutly.y) as LightningStar;
			if (collisionLightning != null && _chutly.collidable)
			{
				SoundUtil.playLightning();
				
				this.remove(collisionLightning);
				
				var enemyList:Array = [];
				
				this.getClass(Comet, enemyList);
				this.getClass(Missile, enemyList);
				this.getClass(Ship, enemyList);
				this.getClass(FlyingSpaMonst, enemyList);
				
				for each (var enemy:Entity in enemyList)
					if (enemy.collidable)
					{
						this._chutly.hitWithLightning(enemy);
						(enemy as IEnemy).die();
					}
			}
		}
		
		protected function checkForFSMCollision():void
		{
			var collisionFlyingSpaMonst:FlyingSpaMonst = this._chutly.collideTypes(FlyingSpaMonst.TYPE, this._chutly.x, this._chutly.y) as FlyingSpaMonst;
			if (collisionFlyingSpaMonst != null && this._chutly.collidable)
			{
				SoundUtil.playSmallLightning();
				this._chutly.hitWithLightning(collisionFlyingSpaMonst.tentacle, 0xFFFF00);
				collisionFlyingSpaMonst.die();
			}
		}
		
		protected function checkForTentacleCollision():void
		{
			var collisionTentacleElem:TentacleElem = _chutly.collideTypes(TentacleElem.TYPE, _chutly.x, _chutly.y) as TentacleElem;
			if (collisionTentacleElem != null && _chutly.collidable)
			{
				collisionTentacleElem.parent.changeGrowthDirection();
				
				if (this._shield == null)
				{
					SoundUtil.playFireballExplode();
					collisionTentacleElem.emitExplosion();
					
					collisionTentacleElem.parent.collidableSetter = false;
					
					hitChutly();
				}
			}
		}
		
		private function checkForShieldCollision():void
		{
			var collisionShild:ShieldStar = _chutly.collideTypes(ShieldStar.TYPE, _chutly.x, _chutly.y) as ShieldStar;
			if (collisionShild != null && _chutly.collidable)
			{
				SoundUtil.playShield();
				
				this.remove(collisionShild);
				
				this._shieldCounter = 0;
				
				if (this._shield == null)
				{
					this._shield = new Shield(this._chutly, SHIELD_COLOR, 29, -3, 2, 0.8);
					this.add(this._shield);
				}
			}
			
			if (this._shield != null)
			{
				this._shieldCounter += FP.elapsed;
				if (this._shieldCounter >= SHIELD_DURATION)
				{
					this._shieldCounter = 0;
					this.remove(_shield);
					this._shield = null;
				}
			}
		}
		
		protected function checkForElderOneCollision():void
		{
			var collisionElderOne:ElderOne = _chutly.collideTypes(ElderOne.TYPE, _chutly.x, _chutly.y) as ElderOne;
			
			if (collisionElderOne != null && _chutly.collidable)
			{
				eat(ElderOne.VALUE);
				collisionElderOne.removeMe();
			}
		}
		
		/**************************************************************************************
		
		/Collision checks
		
		**************************************************************************************/
		
		/**
		 * Pause/Unpause game
		 */
		protected function gamePausedHandler():void
		{
			_optionsEntity.update();
			
			_hudSoundIconEntity.update();
			
			var niceTextEntArr:Array = new Array;
			
			getClass(NiceTextEnt, niceTextEntArr);
			
			for each (var niceTextEnt:NiceTextEnt in niceTextEntArr)
				niceTextEnt.update();
		}
		
		override public function update():void
		{
			checkForMuteMusicTextClick();
			checkForMuteEffectsTextClick();
			
			if (Input.pressed(Key.ESCAPE))
				pauseUnpauseGame();
			
			if (GameVariables.Pause)
			{
				gamePausedHandler();
				return;
			}
			
			/* ******************************* New Entity ******************************* */
			updateSpawn();
			/* ************************************************************************** */
			
			/* ******************************* Planet *********************************** */
			checkForPlanetCollision();
			/* ************************************************************************** */
			
			/* ******************************* Fireball *********************************** */
			checkForCometCollision();
			/* ************************************************************************** */
			
			/* ******************************* Ship *********************************** */
			checkForShipCollision();
			/* ************************************************************************** */
			
			/* ******************************* Missile *********************************** */
			checkForMissleCollision();
			/* ************************************************************************** */
			
			/* ******************************* Life *********************************** */
			checkForLifeCollision();
			/* ************************************************************************** */
			
			/* ******************************* Lightning *********************************** */
			checkForLightningCollision();
			/* ************************************************************************** */
			
			/* ******************************* FSM *********************************** */
			checkForFSMCollision();
			/* ************************************************************************** */
			
			/* ******************************* Tentacle *********************************** */
			checkForTentacleCollision();
			/* ************************************************************************** */
			
			/* ******************************* Shield *********************************** */
			checkForShieldCollision();
			/* ************************************************************************** */
			
			/* ******************************* ElderOne *********************************** */
			checkForElderOneCollision();
			/* ************************************************************************** */
			
			super.update();
		}
	}
}