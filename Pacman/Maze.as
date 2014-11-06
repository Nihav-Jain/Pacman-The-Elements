package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Nihav Jain
	 */
	public class Maze extends Sprite 
	{
		private var maze:Vector.<Vector.<Cell>>;
		private var rows:int;
		private var cols:int;
		private var totalCoins:int;
		
		public function Maze(xml:XML) 
		{
			var i:int, j:int;
			totalCoins = 0;
			
			rows = parseInt(xml.dta.@rows);
			cols = parseInt(xml.dta.@cols);
			
			maze = new Vector.<Vector.<Cell>>(cols, true);
			for (i = 0; i < cols; i++)
			{
				maze[i] = new Vector.<Cell>(rows, true);
				for (j = 0; j < rows; j++)
				{
					maze[i][j] = new Cell();
				}
			}
			
			for each(var cell in xml.maze.grid)
			{
				i = parseInt(cell.@x);
				j = parseInt(cell.@y);
				
				if (i < cols - 1 && j < rows - 1)
				{
					if (cell.@prop == "null")
					{
						maze[i][j].addFloor(Cell.FLOOR_TYPE_GRASS)
					}
					else
					{
						maze[i][j].addFloor(Cell.FLOOR_TYPE_DUST);
						if (cell.@prop == "coin")
						{
							maze[i][j].addCoin(Cell.COIN_TYPE_SIMPLE);
							totalCoins++;
						}
						else if (cell.@prop == "air")
						{
							maze[i][j].addCoin(Cell.COIN_TYPE_AIR);
						}
						else if (cell.@prop == "earth")
						{
							maze[i][j].addCoin(Cell.COIN_TYPE_EARTH);
						}
						else if (cell.@prop == "ether")
						{
							maze[i][j].addCoin(Cell.COIN_TYPE_ETHER);
						}
						else if (cell.@prop == "fire")
						{
							maze[i][j].addCoin(Cell.COIN_TYPE_FIRE);
						}
						else if (cell.@prop == "water")
						{
							maze[i][j].addCoin(Cell.COIN_TYPE_WATER);
						}
					}
				}	
				if (cell.@upwall == "true")
				{
					maze[i][j].addWall(Cell.WALL_ORIENT_HORIZ);
				}
				if (cell.@leftwall == "true")
				{
					maze[i][j].addWall(Cell.WALL_ORIENT_VERTI);
				}
				
				maze[i][j].x = Pacman.UNIT_WIDTH * i;
				maze[i][j].y = Pacman.UNIT_HEIGHT * j;
				this.addChild(maze[i][j]);
			}
		}
		/*
		public function canMoveLeft(posX:Number, posY:Number, moveFactor:int):Boolean
		{
			var i:int = Math.floor(posX / Pacman.UNIT_WIDTH);
			var j:int = Math.floor(posY / Pacman.UNIT_HEIGHT);
			
			if (Math.floor((posX - moveFactor) / Pacman.UNIT_WIDTH) != i)
			{
				if (maze[i][j].leftwall || maze[i][Math.floor((posY + Pacman.UNIT_HEIGHT - 2) / Pacman.UNIT_HEIGHT)].leftwall)
					return false;
			}
			if (posY % Pacman.UNIT_HEIGHT == 0)
				return true;
			else if (maze[Math.floor((posX - moveFactor) / Pacman.UNIT_WIDTH)][Math.floor((posY + Pacman.UNIT_HEIGHT - 2) / Pacman.UNIT_HEIGHT)].upwall == false)
				return true;
			return false;
		}
		
		public function canMoveRight(posX:Number, posY:Number, moveFactor:int):Boolean
		{
			var i:int = Math.floor(posX / Pacman.UNIT_WIDTH);
			var j:int = Math.floor(posY / Pacman.UNIT_HEIGHT);
			
			if (maze[Math.floor((posX + moveFactor - 1) / Pacman.UNIT_WIDTH) + 1][j].leftwall == false && maze[Math.floor((posX + moveFactor - 1) / Pacman.UNIT_WIDTH) + 1][Math.floor((posY + Pacman.UNIT_HEIGHT - 2) / Pacman.UNIT_HEIGHT)].leftwall == false)
			{
				if (posY % Pacman.UNIT_HEIGHT == 0)
					return true;
				else if (maze[Math.floor((posX + moveFactor - 1) / Pacman.UNIT_WIDTH) + 1][Math.floor((posY + Pacman.UNIT_HEIGHT - 2) / Pacman.UNIT_HEIGHT)].upwall == false)
					return true;
			}
			return false;
		}
		
		public function canMoveUp(posX:Number, posY:Number, moveFactor:int):Boolean
		{
			var i:int = Math.floor(posX / Pacman.UNIT_WIDTH);
			var j:int = Math.floor(posY / Pacman.UNIT_HEIGHT);
			
			if (Math.floor((posY - moveFactor) / Pacman.UNIT_HEIGHT) != j)
			{
				if (maze[i][j].upwall == true || maze[Math.floor((posX +Pacman.UNIT_WIDTH - 2) / Pacman.UNIT_WIDTH)][j].upwall == true)
					return false;
			}
			if (posX % Pacman.UNIT_WIDTH == 0)
				return true;
			else if (maze[Math.floor((posX +Pacman.UNIT_WIDTH - 2) / Pacman.UNIT_WIDTH)][Math.floor((posY - moveFactor) / Pacman.UNIT_HEIGHT)].leftwall == false)
				return true;
			return false;	
		}
		
		public function canMoveDown(posX:Number, posY:Number, moveFactor:int):Boolean
		{
			var i:int = Math.floor(posX / Pacman.UNIT_WIDTH);
			var j:int = Math.floor(posY / Pacman.UNIT_HEIGHT);
			
			if (maze[i][Math.floor((posY + moveFactor - 1) / Pacman.UNIT_HEIGHT)+1].upwall == false && maze[Math.floor((posX + Pacman.UNIT_WIDTH - 2) / Pacman.UNIT_WIDTH)][Math.floor((posY + moveFactor - 1) / Pacman.UNIT_HEIGHT)+1].upwall == false)
			{
				if (posX % Pacman.UNIT_WIDTH == 0)
					return true;
				else if (maze[Math.floor((posX + Pacman.UNIT_WIDTH - 2) / Pacman.UNIT_WIDTH)][Math.floor((posY + moveFactor - 1) / Pacman.UNIT_HEIGHT)+1].leftwall == false)
					return true;
			}
			return false;
		}
		*/
		//takes i, j indexes
		
		public function makeIce():void
		{
			var i:int, j:int;
			for (i = 0; i < cols; i++)
			{
				for (j = 0; j < rows; j++)
				{
					maze[i][j].makeIce();
				}
			}
		}
		
		public function breakIce():void
		{
			var i:int, j:int;
			for (i = 0; i < cols; i++)
			{
				for (j = 0; j < rows; j++)
				{
					maze[i][j].breakIce();
				}
			}
		}
		
		public function removeRect(m:int, n:int):void
		{
			maze[m][n].removeRect();
		}
		
		public function forEarth(mx:Number, my:Number):Boolean
		{
			var i:int, j:int;
			for (i = 0; i < cols; i++)
			{
				for (j = 0; j < rows; j++)
				{
					maze[i][j].removeRect();
				}
			}
			var m:int, n:int;
			m = Math.floor(mx / Pacman.UNIT_WIDTH);
			n = Math.floor(my / Pacman.UNIT_HEIGHT);
			
			if (m >= cols || n >= 31)
				return false;
				
			if ((mx - m * Pacman.UNIT_WIDTH) > (my - n * Pacman.UNIT_HEIGHT))
			{
				return maze[m][n].forEarth("up");
			}
			return maze[m][n].forEarth("left");
		}
		
		public function addWall(mx:Number, my:Number):void
		{
			var m:int, n:int;
			m = Math.floor(mx / Pacman.UNIT_WIDTH);
			n = Math.floor(my / Pacman.UNIT_HEIGHT);
			if ((mx - m * Pacman.UNIT_WIDTH) > (my - n * Pacman.UNIT_HEIGHT))
			{
				maze[m][n].addWall(Cell.WALL_ORIENT_HORIZ);
			}
			else
			{
				maze[m][n].addWall(Cell.WALL_ORIENT_VERTI);
			}
		}
		
		public function forTeleport(m:int, n:int):Boolean
		{
			var i:int, j:int;
			for (i = 0; i < cols; i++)
			{
				for (j = 0; j < rows; j++)
				{
					maze[i][j].removeRect();
				}
			}
			if (m >= cols || n >= 31)
				return false;
			return maze[m][n].forTeleport();
		}
		
		public function getLeftOf(i:int, j:int):Boolean
		{
			return maze[i][j].leftwall;
		}
		
		public function getUpOf(i:int, j:int):Boolean
		{
			return maze[i][j].upwall;
		}
		
		public function getCellContent(i:int, j:int):int
		{
			return maze[i][j].coinType;
		}
		
		public function removeCellContent(i:int, j:int):void
		{
			maze[i][j].removeCoin();
		}
		
		public function getTotalCoins():int
		{
			return totalCoins;
		}
		
		
		public function canMoveLeft(posX:Number, posY:Number, moveFactor:int):Boolean
		{
			if (Math.floor(posX / Pacman.UNIT_WIDTH) == Math.floor((posX - moveFactor) / Pacman.UNIT_WIDTH))
			{
				/*
				if (Math.floor(posY / Pacman.UNIT_HEIGHT) == Math.floor((posY + 10) / Pacman.UNIT_HEIGHT))
				{
					return true;
				}
				else
				{
					
				}*/
				return true;
			}
			else
			{
				if (Math.floor(posY / Pacman.UNIT_HEIGHT) == Math.floor((posY + 10) / Pacman.UNIT_HEIGHT))
				{
					if (maze[Math.floor(posX / Pacman.UNIT_WIDTH)][Math.floor(posY / Pacman.UNIT_HEIGHT)].leftwall == true)
						return false;
					else
						return true;
				}
				else
				{
					if (maze[Math.floor(posX / Pacman.UNIT_WIDTH)][Math.floor((posY+10) / Pacman.UNIT_HEIGHT)].leftwall == true)
						return false;
					else if (maze[Math.floor(posX / Pacman.UNIT_WIDTH)][Math.floor((posY) / Pacman.UNIT_HEIGHT)].leftwall == true)
						return false;
					else if (maze[Math.floor((posX - moveFactor) / Pacman.UNIT_WIDTH)][Math.floor((posY + 10) / Pacman.UNIT_HEIGHT)].upwall == true)
						return false;
					else
						return true;
				}
			}
			return false;

		}
		
		public function canMoveRight(posX:Number, posY:Number, moveFactor:int):Boolean
		{
			if (Math.floor((posX + 10) / Pacman.UNIT_WIDTH) == Math.floor((posX + 10 + moveFactor) / Pacman.UNIT_WIDTH))
			{/*
				if (Math.floor(posY / Pacman.UNIT_HEIGHT) == Math.floor((posY + 10) / Pacman.UNIT_HEIGHT))
					return true;
				else	*/
				return true;
			}
			else
			{
				if (Math.floor(posY / Pacman.UNIT_HEIGHT) == Math.floor((posY + 10) / Pacman.UNIT_HEIGHT))
				{
					if (maze[Math.floor((posX+10) / Pacman.UNIT_WIDTH)+1][Math.floor((posY+10) / Pacman.UNIT_HEIGHT)].leftwall == true)
						return false;
					else
						return true;
				}
				else
				{
					if (maze[Math.floor((posX+10) / Pacman.UNIT_WIDTH)+1][Math.floor((posY+10) / Pacman.UNIT_HEIGHT)].leftwall == true)
						return false;
					else if (maze[Math.floor((posX+10) / Pacman.UNIT_WIDTH)+1][Math.floor((posY) / Pacman.UNIT_HEIGHT)].leftwall == true)
						return false;
					else if (maze[Math.floor((posX + 10 + moveFactor) / Pacman.UNIT_WIDTH)][Math.floor((posY + 10) / Pacman.UNIT_HEIGHT)].upwall == true)
						return false;
					else
						return true;
				}
			}
			return false;
		}
		
		public function canMoveUp(posX:Number, posY:Number, moveFactor:int):Boolean
		{
			if (Math.floor(posY / Pacman.UNIT_WIDTH) == Math.floor((posY - moveFactor) / Pacman.UNIT_HEIGHT))
				return true;
			else 
			{
				if (Math.floor(posX / Pacman.UNIT_WIDTH) == Math.floor((posX + 10) / Pacman.UNIT_WIDTH))
				{
					if (maze[Math.floor(posX / Pacman.UNIT_WIDTH)][Math.floor(posY / Pacman.UNIT_HEIGHT)].upwall == true)
						return false;
					else
						return true;
				}
				else
				{
					if (maze[Math.floor(posX / Pacman.UNIT_WIDTH)][Math.floor(posY / Pacman.UNIT_HEIGHT)].upwall == true)
						return false;
					else if (maze[Math.floor((posX + 10) / Pacman.UNIT_WIDTH)][Math.floor(posY / Pacman.UNIT_HEIGHT)].upwall == true)
						return false
					else if (maze[Math.floor((posX + 10) / Pacman.UNIT_WIDTH)][Math.floor((posY - moveFactor) / Pacman.UNIT_HEIGHT) - 1].leftwall == true)
						return false;
					else
						return true;
				}
			}
		
		}
		
		public function canMoveDown(posX:Number, posY:Number, moveFactor:int):Boolean
		{
			if (Math.floor((posY + 10) / Pacman.UNIT_WIDTH) == Math.floor((posY +10 + moveFactor) / Pacman.UNIT_HEIGHT))
			{
				return true;
			}
			else
			{
				if (Math.floor(posX / Pacman.UNIT_WIDTH) == Math.floor((posX + 10) / Pacman.UNIT_WIDTH))
				{
					if (maze[Math.floor(posX / Pacman.UNIT_WIDTH)][Math.floor((posY +10 + moveFactor) / Pacman.UNIT_HEIGHT)].upwall == true)
						return false;
					else
						return true;
				}
				else
				{
					if (maze[Math.floor(posX / Pacman.UNIT_WIDTH)][Math.floor((posY +10 + moveFactor) / Pacman.UNIT_HEIGHT)].upwall == true)
						return false;
					else if (maze[Math.floor((posX + 10) / Pacman.UNIT_WIDTH)][Math.floor((posY +10 + moveFactor) / Pacman.UNIT_HEIGHT)].upwall == true)
						return false;
					else if (maze[Math.floor((posX + 10) / Pacman.UNIT_WIDTH)][Math.floor((posY +10 + moveFactor) / Pacman.UNIT_HEIGHT)].leftwall == true)
						return false;
					else
						return true;
				}
			}
			return false;
		}
	}

}