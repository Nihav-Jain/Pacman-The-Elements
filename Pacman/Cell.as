package  
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Nihav Jain
	 */
	public class Cell extends Sprite
	{
		public static const WALL_ORIENT_VERTI:int = 1;
		public static const WALL_ORIENT_HORIZ:int = 2;
		public static const FLOOR_TYPE_GRASS:int = 3;
		public static const FLOOR_TYPE_DUST:int = 4;
		
		public static const COIN_TYPE_SIMPLE:int = 5;
		public static const COIN_TYPE_EARTH:int = 6;
		public static const COIN_TYPE_AIR:int = 7;
		public static const COIN_TYPE_FIRE:int = 8;
		public static const COIN_TYPE_WATER:int = 9;
		public static const COIN_TYPE_ETHER:int = 10;
		
		private var _upwall:Boolean;
		private var _leftwall:Boolean;
		private var _property:String;
		
		private var floorSpriteNormal:Sprite;
		private var floorSpriteIce:Sprite;
		
		private var wallSpriteHorizNormal:Sprite;
		private var wallSpriteHorizIce:Sprite;
		private var wallSpriteVertiNormal:Sprite;
		private var wallSpriteVertiIce:Sprite;
		
		private var coin:Sprite;
		private var _coinType:int;
		
		private var rect:Sprite;
		private var horiz:Wall_Horizontal;
		private var verti:Wall_Vertical;
		
		public function Cell() 
		{
			floorSpriteIce = null;
			floorSpriteNormal = null;
			
			wallSpriteHorizIce = null;
			wallSpriteHorizNormal = null;
			wallSpriteVertiIce = null;
			wallSpriteVertiNormal = null;
			
			rect = null;
			coin = null;
			coinType = -1;
			
			upwall = false;
			leftwall = false;
		}
		
		public function addWall(orient:int):void
		{
			if (orient == WALL_ORIENT_HORIZ)
			{
				wallSpriteHorizNormal = new Wall_Horizontal();
				wallSpriteHorizIce = new IceWall_Horizontal();
				wallSpriteHorizIce.visible = false;
				
				this.addChild(wallSpriteHorizNormal);
				this.addChild(wallSpriteHorizIce);
				
				upwall = true;
			}
			else if (orient == WALL_ORIENT_VERTI)
			{
				wallSpriteVertiNormal = new Wall_Vertical();
				wallSpriteVertiIce = new IceWall_Vertical();
				wallSpriteVertiIce.visible = false;
				
				this.addChild(wallSpriteVertiNormal);
				this.addChild(wallSpriteVertiIce);
				
				leftwall = true;
			}
		}
		
		public function addFloor(floorType:int):void
		{
			if (floorType == FLOOR_TYPE_DUST)
			{
				floorSpriteNormal = new Floor_Dust();
				floorSpriteIce = new Floor_Ice();
				floorSpriteIce.visible = false;
				
				this.addChild(floorSpriteNormal);
				this.addChild(floorSpriteIce);
				
				rect = new Sprite();
				rect.graphics.beginFill(0x000000, 0.3);
				rect.graphics.drawRect(0, 0, Pacman.UNIT_WIDTH, Pacman.UNIT_HEIGHT);
				rect.graphics.endFill();
				rect.visible = false;
				horiz = new Wall_Horizontal();
				verti = new Wall_Vertical();
				horiz.visible = false;
				verti.visible = false;
				rect.addChild(horiz);
				rect.addChild(verti);
				
				this.addChild(rect);
			}
			else if (floorType == FLOOR_TYPE_GRASS)
			{
				floorSpriteNormal = new Floor_Grass();
				this.addChild(floorSpriteNormal);
			}
		}
		
		public function addCoin(coinType:int):void
		{
			this.coinType = coinType;
			if (coinType == COIN_TYPE_SIMPLE)
			{
				coin = new Coin();
			}
			else if (coinType == COIN_TYPE_AIR)
			{
				coin = new AirCoin();
			}
			else if (coinType == COIN_TYPE_EARTH)
			{
				coin = new EarthCoin();
			}
			else if (coinType == COIN_TYPE_ETHER)
			{
				coin = new EtherCoin();
			}
			else if (coinType == COIN_TYPE_FIRE)
			{
				coin = new FireCoin();
			}
			else if (coinType == COIN_TYPE_WATER)
			{
				coin = new WaterCoin();
			}
			
			this.addChild(coin);
			coin.x = Pacman.UNIT_WIDTH / 2;
			coin.y = Pacman.UNIT_HEIGHT / 2;
		}
		
		public function removeCoin():void
		{
			if (coin != null)
			{
				coinType = -1;
				coin.visible = false;
				this.removeChild(coin);
				coin = null;
			}
		}
		
		public function makeIce():void
		{
			if (floorSpriteIce != null)
			{
				floorSpriteIce.visible = true;
				floorSpriteIce.alpha = 0;
				TweenLite.to(floorSpriteIce, 1, { alpha:1 } );
			}
			if (wallSpriteHorizIce != null)
			{
				wallSpriteHorizIce.visible = true;
				wallSpriteHorizIce.alpha = 0;
				TweenLite.to(wallSpriteHorizIce, 1, { alpha: 1 } );
			}
			if (wallSpriteVertiIce != null)
			{
				wallSpriteVertiIce.visible = true;
				wallSpriteVertiIce.alpha = 0;
				TweenLite.to(wallSpriteVertiIce, 1, { alpha: 1 } );
			}
			
		}
		
		public function breakIce():void
		{
			if (floorSpriteIce != null)
			{
				//floorSpriteIce.visible = true;
				//floorSpriteIce.alpha = 0;
				TweenLite.to(floorSpriteIce, 1, { alpha:0 } );
			}
			if (wallSpriteHorizIce != null)
			{
				//wallSpriteHorizIce.visible = true;
				//wallSpriteHorizIce.alpha = 0;
				TweenLite.to(wallSpriteHorizIce, 1, { alpha: 0 } );
			}
			if (wallSpriteVertiIce != null)
			{
				//wallSpriteVertiIce.visible = true;
				//wallSpriteVertiIce.alpha = 0;
				TweenLite.to(wallSpriteVertiIce, 1, { alpha: 0 } );
			}
			
		}
		
		public function forTeleport():Boolean
		{
			if (rect != null)
			{
				rect.visible = true;
				return true;
			}
			return false;
		}
		
		public function removeRect():void
		{
			if (rect != null)
			{
				rect.visible = false;
				horiz.visible = false;
				verti.visible = false;
			}
		}
		
		public function forEarth(wall:String):Boolean
		{
			if (rect != null)
			{
				if (wall == "up")
				{
					horiz.visible = true;
					verti.visible = false;
					rect.visible = true;
				}
				else if (wall == "left")
				{
					verti.visible = true;
					horiz.visible = false;
					rect.visible = true;
				}
				return true;
			}
			return false;
		}
		
		public function get upwall():Boolean 
		{
			return _upwall;
		}
		
		public function set upwall(value:Boolean):void 
		{
			_upwall = value;
		}
		
		public function get leftwall():Boolean 
		{
			return _leftwall;
		}
		
		public function set leftwall(value:Boolean):void 
		{
			_leftwall = value;
		}
		
		public function get property():String 
		{
			return _property;
		}
		
		public function set property(value:String):void 
		{
			_property = value;
		}
		
		public function get coinType():int 
		{
			return _coinType;
		}
		
		public function set coinType(value:int):void 
		{
			_coinType = value;
		}
		
	}

}