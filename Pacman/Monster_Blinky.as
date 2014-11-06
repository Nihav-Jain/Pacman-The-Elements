package  
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Nihav Jain
	 */
	public class Monster_Blinky extends Sprite 
	{
		private var monster:Monster_Brown;
		private var _target:Point;
		public var nextCell:Point;
		private var nextDirection:String;
		public var curDirection:String;
		
		private var maze:Maze;
		private var minDist:int;
		private var moveFactor:int;
		
		public var canReverse:Boolean;
		public var speed:Number;
		
		
		public function Monster_Blinky(_maze:Maze, _x:int, _y:int) 
		{
			monster = new Monster_Brown();
			this.addChild(monster);
			this.x = _x * Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH / 2;
			this.y = _y * Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT / 2;
			
			moveFactor = 4;
			speed = moveFactor * 30;
			maze = _maze;
			curDirection = "up";
			nextDirection = "left";
			nextCell = new Point(this.x, this.y);
			
			canReverse = false;
		}
		
		public function start():void
		{
			if(curDirection == "left" || curDirection == "right")
				TweenLite.to(this, Pacman.UNIT_WIDTH / speed, { x: nextCell.x, ease: Linear.easeNone, onComplete: enter_frame } );
			else if (curDirection == "up" || curDirection == "down")
				TweenLite.to(this, Pacman.UNIT_HEIGHT / speed, { y: nextCell.y, ease: Linear.easeNone, onComplete: enter_frame } );
		}
		
		public function enter_frame():void
		{
			var distLeft:int = 100 * Pacman.UNIT_WIDTH;
			var distRight:int = 100 * Pacman.UNIT_WIDTH;
			var distUp:int = 100 * Pacman.UNIT_HEIGHT;
			var distDown:int = 100 * Pacman.UNIT_HEIGHT;
			if (this.x == nextCell.x && this.y == nextCell.y)
			{
				/*
			var dirs:Array = new Array("left", "right", "up", "down");
			var dists:Array = new Array(100 * Pacman.UNIT_WIDTH,100 * Pacman.UNIT_WIDTH,100 * Pacman.UNIT_WIDTH,100 * Pacman.UNIT_WIDTH);
				var i:int = Math.floor(nextCell.x / Pacman.UNIT_WIDTH);
				var j:int = Math.floor(nextCell.y / Pacman.UNIT_HEIGHT);
				//trace(i, j, maze.getUpOf(i, j + 1), nextDirection);
				if ((curDirection != "right" || canReverse) && !maze.getLeftOf(i, j))
				{
					dists[0] = Math.abs(target.x - (nextCell.x - Pacman.UNIT_WIDTH)) + Math.abs(target.y - nextCell.y);
				}
				if ((curDirection != "left" ||  canReverse) && !maze.getLeftOf(i + 1, j))
				{
					dists[1] = Math.abs(target.x - (nextCell.x + Pacman.UNIT_WIDTH)) + Math.abs(target.y - nextCell.y);
				}
				if ((curDirection != "down" || canReverse) && !maze.getUpOf(i, j))
				{
					dists[2] = Math.abs(target.x - nextCell.x) + Math.abs(target.y - (nextCell.y - Pacman.UNIT_HEIGHT));
				}
				if ((curDirection != "up" || canReverse) && !maze.getUpOf(i, j + 1))
				{
					dists[3] = Math.abs(target.x - nextCell.x) + Math.abs(target.y - (nextCell.y + Pacman.UNIT_HEIGHT));
				}

				trace(i, j, distLeft, distRight, distUp, distDown, curDirection);
				var temp:int, m:int, n:int;
				var tempdir:String;
				for (m = 0; m < 4; m++)
				{
					for (n = i + 1; n < 4; n++)
					{
						if (dists[n] < dists[m])
						{
							temp = dists[m];
							dists[m] = dists[n];
							dists[n] = temp;
							
							tempdir = dirs[m];
							dirs[m] = dirs[n];
							dirs[n] = temp;
						}
					}
				}
				trace(curDirection, dirs[0], dirs[1], dirs[2], dirs[3], dists[0], dists[1], dists[2], dists[3]);
				for (m = 0; m < 4; m++)
				{
					if (dirs[m] == "left" && !maze.getLeftOf(i, j))
					{
						curDirection = "left";
						nextCell.x -= Pacman.UNIT_WIDTH;
						break;
					}
					else if (dirs[m] == "right" && !maze.getLeftOf(i + 1, j))
					{
						curDirection = "right";
						nextCell.x += Pacman.UNIT_WIDTH;
						break;
					}
					else if (dirs[m] == "up" && !maze.getUpOf(i, j))
					{
						curDirection = "up";
						nextCell.y -= Pacman.UNIT_HEIGHT;						
						break;
					}
					else if (dirs[m] == "down" && !maze.getUpOf(i, j + 1))
					{
						curDirection = "down";
						nextCell.y += Pacman.UNIT_HEIGHT;
						break;
					}
				}*/
				//trace(curDirection);
				var i:int = Math.floor(nextCell.x / Pacman.UNIT_WIDTH);
				var j:int = Math.floor(nextCell.y / Pacman.UNIT_HEIGHT);
				//trace(i, j, maze.getUpOf(i, j + 1), nextDirection);
				if ((curDirection != "right" || canReverse) && !maze.getLeftOf(i, j))
				{
					distLeft = Math.abs(target.x - (nextCell.x - Pacman.UNIT_WIDTH)) + Math.abs(target.y - nextCell.y);
				}
				if ((curDirection != "left" ||  canReverse) && !maze.getLeftOf(i + 1, j))
				{
					distRight = Math.abs(target.x - (nextCell.x + Pacman.UNIT_WIDTH)) + Math.abs(target.y - nextCell.y);
				}
				if ((curDirection != "down" || canReverse) && !maze.getUpOf(i, j))
				{
					distUp = Math.abs(target.x - nextCell.x) + Math.abs(target.y - (nextCell.y - Pacman.UNIT_HEIGHT));
				}
				if ((curDirection != "up" || canReverse) && !maze.getUpOf(i, j + 1))
				{
					distDown = Math.abs(target.x - nextCell.x) + Math.abs(target.y - (nextCell.y + Pacman.UNIT_HEIGHT));
				}
				
				if (distDown == distLeft && distDown == distRight && distDown == distUp)
				{
					if (curDirection == "left")
					{
						curDirection = "right";
						nextCell.x += Pacman.UNIT_WIDTH; 
					}
					else if (curDirection == "right")
					{
						curDirection = "left";
						nextCell.x -= Pacman.UNIT_WIDTH;
					}
					else if (curDirection == "up")
					{
						curDirection = "down";
						nextCell.y += Pacman.UNIT_HEIGHT;
					}
					else if (curDirection == "down")
					{
						curDirection = "up";
						nextCell.y -= Pacman.UNIT_HEIGHT;
					}
				}
				else
				{
				if (distUp <= distRight && distUp <= distLeft && distUp <= distDown)
				{
					curDirection = "up";
					nextCell.y -= Pacman.UNIT_HEIGHT;
				}
				else if (distLeft <= distRight && distLeft <= distUp && distLeft <= distDown)
				{
					curDirection = "left";
					nextCell.x -= Pacman.UNIT_WIDTH;
				}
				else if (distDown <= distUp && distDown <= distLeft && distDown <= distRight)
				{
					curDirection = "down";
					nextCell.y += Pacman.UNIT_HEIGHT;
				}
				else
				{
					curDirection = "right";
					nextCell.x += Pacman.UNIT_WIDTH;
				}
				}
				//start();
				if(curDirection == "left" || curDirection == "right")
					TweenLite.to(this, Pacman.UNIT_WIDTH / speed, { x: nextCell.x, ease: Linear.easeNone, onComplete: enter_frame } );
				else if (curDirection == "up" || curDirection == "down")
					TweenLite.to(this, Pacman.UNIT_HEIGHT / speed, { y: nextCell.y, ease: Linear.easeNone, onComplete: enter_frame } );
			}
			
		}
		
		public function get target():Point 
		{
			return _target;
		}
		
		public function set target(value:Point):void 
		{
			_target = value;
		}
		
	}

}