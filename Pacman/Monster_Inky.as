package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;

	/**
	 * ...
	 * @author Nihav Jain
	 */
	public class Monster_Inky extends Sprite 
	{
		private var monster:Monster_Brown;
		private var _target:Point;
		public var nextCell:Point;
		private var nextDirection:String;
		public var curDirection:String;
		
		private var maze:Maze;
		private var minDist:int;
		private var moveFactor:int;
		
		public var isActive:Boolean;
		public var canReverse:Boolean;
		public var speed:Number;
		
		public function Monster_Inky(_maze:Maze, _x:int, _y:int) 
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
			
			isActive = false;
			canReverse = false;
		}
		
		public function enter_frame():void
		{
			var distLeft:int = 100 * Pacman.UNIT_WIDTH;
			var distRight:int = 100 * Pacman.UNIT_WIDTH;
			var distUp:int = 100 * Pacman.UNIT_HEIGHT;
			var distDown:int = 100 * Pacman.UNIT_HEIGHT;
			if (this.x == nextCell.x && this.y == nextCell.y)
			{
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

				//trace(i, j, distLeft, distRight, distUp, distDown, curDirection);
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