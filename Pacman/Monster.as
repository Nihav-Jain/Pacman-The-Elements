package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author Nihav Jain
	 */
	public class Monster extends Sprite 
	{
		private var monster:MovieClip;
		private var _target:Point;
		public var nextCell:Point;
		private var nextDirection:String;
		public var curDirection:String;
		
		private var maze:Maze;
		private var minDist:int;
		private var moveFactor:int;
		
		public var isActive:Boolean;
		public var canReverse:Boolean;
		
		public var arr:Array;
		public var targetIndex:int;
		public var speed:Number;
		
		public var reverseDir:Boolean;
		
		public function Monster(_maze:Maze, _x:int, _y:int, type:String)
		{
			if (type == "brown")
				monster = new Monster_Brown();
			else if (type == "green")
				monster = new Monster_Green();
			
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
			
			reverseDir = false;
			
			//arr = new Array(new Point(1*Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH/2, 1*Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT/2), new Point(26*Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH/2, 1*Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT/2), new Point(1*Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH/2, 30*Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT/2), new Point(26*Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH/2, 30*Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT/2));
			arr = new Array(new Point(26*Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH/2, 29*Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT/2), new Point(1*Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH/2, 1*Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT/2), new Point(26*Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH/2, 1*Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT/2));
			targetIndex = 0;
			target = arr[(targetIndex) ];
			canReverse = false;
			//trace(arr[0].x, arr[0].y, target.x, target.y);
		}
		
		public function enter_frame():void
		{
			if (this.x == target.x && this.y == target.y)
			{
				targetIndex = (targetIndex + 1) % 3;
				target = arr[(targetIndex)];
				//trace(target.x, target.y);
			}
			var distLeft:int = 100 * Pacman.UNIT_WIDTH;
			var distRight:int = 100 * Pacman.UNIT_WIDTH;
			var distUp:int = 100 * Pacman.UNIT_HEIGHT;
			var distDown:int = 100 * Pacman.UNIT_HEIGHT;
			//if (this.x == nextCell.x && this.y == nextCell.y)
			
			//{
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
			//}
			
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