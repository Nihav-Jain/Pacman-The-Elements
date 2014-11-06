package  
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Nihav Jain
	 */
	public class Pacman extends Sprite 
	{
		private var xmlLoader:XMLLoader;
		private var maze:Maze;
		private var man:Man;
		
		private var xml:XML;
		
		public static const UNIT_WIDTH:int = 20;
		public static const UNIT_HEIGHT:int = 20;
		
		private var left:Boolean;
		private var right:Boolean;
		private var up:Boolean;
		private var down:Boolean;
		
		private var canMoveLeft:Boolean;
		private var canMoveRight:Boolean;
		private var canMoveUp:Boolean;
		private var canMoveDown:Boolean;
		
		private var totalScore:int;
		private var totalCoins:int;
		
		private var moveFactor:int;
		
		private var monsterBlinky:Monster_Blinky;
		private var monsterPinky:Monster_Pinky;
		private var monsterInky:Monster_Inky;
		private var monster:Monster;
		
		private var isPinkyActive:Boolean;
		private var isInkyActive:Boolean;
		
		private var timer:int;
		
		private var resumePanel:gamerestart;
		private var resumeTimer:int;
		
		private var scorecard:ScorePanel;
		private var levelNumber:int;
		
		private var request:URLRequest;
		private var variables:URLVariables;
		private var loader:URLLoader;
		
		private var isFireActive:Boolean;
		private var isWaterActive:Boolean;
		private var isEtherActive:Boolean;
		private var uid:String;
		
		private var loader2:URLLoader;
		
		private var restartFunc:Function;
		
		public function Pacman(link:String, lvl:int, id:String, restartFunc:Function) 
		{
			uid = id;
			//trace(uid);
			levelNumber = lvl;
			this.restartFunc = restartFunc;
			xmlLoader = new XMLLoader(link, { name:"mazexml", onComplete: xmlLoadComplete } );
			xmlLoader.load();
		}
		
		private function xmlLoadComplete(ev:LoaderEvent):void 
		{
			xml = new XML(LoaderMax.getContent("mazexml"));
			maze = new Maze(xml);
			this.addChild(maze);
			
			man = new Man();
			man.x = parseInt(xml.dta.@manx) * UNIT_WIDTH + UNIT_WIDTH / 2;
			man.y = parseInt(xml.dta.@many) * UNIT_HEIGHT + UNIT_HEIGHT / 2;
			this.addChild(man);
			man.gotoAndStop(1);
			man.width = 15;
			man.height = 15;
			
			left = false;
			right = false;
			up = false;
			down = false;
			
			canMoveLeft = false;
			canMoveRight = false;
			canMoveUp = false;
			canMoveDown = false;
			
			totalScore = 0;
			totalCoins = maze.getTotalCoins();
			
			moveFactor = 4;
			
			monsterInky = new Monster_Inky(maze, parseInt(xml.inky.@x), parseInt(xml.inky.@y));
			this.addChild(monsterInky);
			isInkyActive = false;
			monsterInky.visible = false;
			monsterInky.target = new Point(Math.floor(man.x), Math.floor(man.y));
			
			monsterPinky = new Monster_Pinky(maze, parseInt(xml.pinky.@x), parseInt(xml.pinky.@y));
			this.addChild(monsterPinky);
			isPinkyActive = false;
			monsterPinky.visible = false;
			monsterPinky.target = new Point(Math.floor(man.x), Math.floor(man.y));
			
			monsterBlinky = new Monster_Blinky(maze, parseInt(xml.blinky.@x), parseInt(xml.blinky.@y));
			this.addChild(monsterBlinky);
			monsterBlinky.target = new Point(Math.floor(man.x), Math.floor(man.y));
			monsterBlinky.enter_frame();
			
			monster = new Monster(maze, parseInt(xml.blinky.@x), parseInt(xml.blinky.@y), "green");
			this.addChild(monster);
			monster.enter_frame();
			
			monster.speed = (4 + Math.floor(levelNumber / 8)) * 30;
			monsterBlinky.speed = (4 + Math.floor(levelNumber / 8)) * 30;
			monsterInky.speed = (4 + Math.floor(levelNumber / 8)) * 30;
			monsterPinky.speed = (4 + Math.floor(levelNumber / 8)) * 30;
			//monster.target = new Point(Math.floor(man.x), Math.floor(man.y));
			
			timer = 0;
			TweenLite.delayedCall(1, timerFunc);
			//trace(this.width, this.height);
			
			resumePanel = new gamerestart();
			this.addChild(resumePanel);
			resumePanel.visible = false;
			
			scorecard = new ScorePanel();
			scorecard.x = 27 * UNIT_WIDTH + 2.5;
			//scorecard.y = this.height - UNIT_HEIGHT;
			this.addChild(scorecard);
			
			scorecard.levelnumtxt.text = "Level: " + levelNumber;
			scorecard.timetxt.text = "Time: " + timer + " secs.";
			scorecard.scoretxt.text = "Score: " + totalScore;
			
			scorecard.earthmc.alpha = 0.3;
			scorecard.airmc.alpha = 0.3;
			scorecard.firemc.alpha = 0.3;
			scorecard.watermc.alpha = 0.3;
			scorecard.ethermc.alpha = 0.3;
			
			isEtherActive = false;
			isFireActive = false;
			isWaterActive = false;
			
			scorecard.message.text = "Avoid the Monsters. Collect all Gandour Safari chocolates to goto next level";
			stage.focus = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
			this.addEventListener(Event.ENTER_FRAME, enter_frame);
			//stage.addEventListener(MouseEvent.CLICK, mouse_click);
		}
		
		private function mouse_click(e:MouseEvent):void 
		{
			//trace(maze.canMoveLeft(man.x - man.width / 2, man.y - man.height / 2, moveFactor), maze.canMoveRight(man.x - man.width / 2, man.y - man.height / 2, moveFactor));
			//trace(maze.canMoveUp(man.x - man.width / 2, man.y - man.height / 2, moveFactor), maze.canMoveDown(man.x - man.width / 2, man.y - man.height / 2, moveFactor));
			//trace(man.x - man.width / 2, man.y - man.height / 2, moveFactor);
		}
		
		
		
		private function enter_frame(e:Event):void 
		{
			////trace(left, right, up, down);
			////trace("here");
			if (left)
			{
				man.rotation = 270;
				if (maze.canMoveLeft(man.x - man.width / 2, man.y - man.height / 2, moveFactor))
					man.x -= moveFactor;
			}
			if (right)
			{
				man.rotation = 90;
				if (maze.canMoveRight(man.x - man.width / 2, man.y - man.height / 2, moveFactor))
					man.x += moveFactor;
			}
			if (up)
			{
				man.rotation = 0;
				if (maze.canMoveUp(man.x - man.width / 2, man.y - man.height / 2, moveFactor))
					man.y -= moveFactor;
			}
			if (down)
			{
				man.rotation = 180;
				if (maze.canMoveDown(man.x - man.width / 2, man.y - man.height / 2, moveFactor))
					man.y += moveFactor;
			}
			
			if (!(left || right || up || down))
			{
				man.gotoAndStop(1);
			}
			
			var coinType:int = maze.getCellContent(Math.floor(man.x / UNIT_WIDTH), Math.floor(man.y / UNIT_HEIGHT));
			maze.removeCellContent(Math.floor(man.x / UNIT_WIDTH), Math.floor(man.y / UNIT_HEIGHT));
			if (coinType == Cell.COIN_TYPE_SIMPLE)
			{
				totalCoins--;
				totalScore += 5;
				scorecard.scoretxt.text = "Score: " + totalScore;
				//trace(totalCoins);
				if (totalCoins <= 0)
				{	/*
					this.removeEventListener(Event.ENTER_FRAME, enter_frame);
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
					stage.removeEventListener(KeyboardEvent.KEY_UP, key_up);
					TweenLite.killDelayedCallsTo(timerFunc);
					*/
					pauseGame();
					/*
					variables = new URLVariables();
					variables.score = totalScore - timer;
					
					request = new URLRequest("http://www.bits-oasis.org/2013test/backend/game/");
					request.method = URLRequestMethod.POST;
					request.data = variables;
					
					loader = new URLLoader(request);
					loader.dataFormat = URLLoaderDataFormat.VARIABLES;
					loader.addEventListener(Event.COMPLETE, loadComp);
					loader.load(request);
					var req2:URLRequest = new URLRequest("http://www.bits-oasis.org/posttofb.php");
					req2.method = URLRequestMethod.POST;
					req2.data = variables;

					loader2 = new URLLoader(req2);
					loader2.dataFormat = URLLoaderDataFormat.VARIABLES;
					loader2.addEventListener(Event.COMPLETE, loadComp2);
					//loader2.load(req2);
					*/
					this.restartFunc.call(this, this.levelNumber, this.uid);
				}
			}
			else if (coinType == Cell.COIN_TYPE_AIR)
			{
				pauseGame();
				this.addEventListener(MouseEvent.MOUSE_MOVE, teleportmenu);
				this.addEventListener(MouseEvent.CLICK, teleportTo);
				scorecard.airmc.alpha = 1;
				scorecard.message.text = "Air Power :\nClick on any tile to teleport there.";				
			}
			else if (coinType == Cell.COIN_TYPE_EARTH)
			{
				pauseGame();
				this.addEventListener(MouseEvent.MOUSE_MOVE, earthmenu);
				this.addEventListener(MouseEvent.CLICK, earthTo);
				scorecard.earthmc.alpha = 1;
				scorecard.message.text = "Earth Power :\nClick on a tile to add a horizontal / vertical wall. ";
			}
			else if (coinType == Cell.COIN_TYPE_ETHER)
			{
				isEtherActive = true;
				TweenLite.delayedCall(10, resetEther);
				scorecard.ethermc.alpha = 1;
				scorecard.message.text = "Ether Power : \nMonsters cannot harm you for the next 10 seconds.";
			}
			else if (coinType == Cell.COIN_TYPE_FIRE)
			{
				/*
				scorecard.watermc.alpha = 1;
				scorecard.watermc.buttonMode = true;
				scorecard.watermc.addEventListener(MouseEvent.CLICK, waterClicked);				
				*/
				isFireActive = true;
				scorecard.firemc.alpha = 1;
				TweenLite.delayedCall(10, douseFire);
				scorecard.message.text = "Fire Power:\nMonsters will return home on touching you for the next 10 seconds.";
			}
			else if (coinType == Cell.COIN_TYPE_WATER)
			{
				/*
				scorecard.watermc.alpha = 1;
				scorecard.watermc.buttonMode = true;
				scorecard.watermc.addEventListener(MouseEvent.CLICK, waterClicked);
				*/
				moveFactor = 8;			
				maze.makeIce();
				scorecard.watermc.alpha = 1;
				TweenLite.delayedCall(10, breakIce);
				scorecard.message.text = "Water Power:\nSlide on the Ice. Evade monsters, collect Gandour Safari Chocolates. But be quick, the ice melts in 10 seconds";
			}
			
			if (man.x / UNIT_WIDTH != monsterBlinky.target.x / UNIT_WIDTH || man.y / UNIT_HEIGHT != monsterBlinky.target.y / UNIT_HEIGHT)
				monsterBlinky.target = new Point(Math.floor(man.x / UNIT_WIDTH) * UNIT_WIDTH + UNIT_WIDTH / 2, Math.floor(man.y / UNIT_HEIGHT) * UNIT_HEIGHT + UNIT_HEIGHT / 2);
			//monsterBlinky.enter_frame();
			
			if (Math.floor(man.x / UNIT_WIDTH) == Math.floor(monsterBlinky.x / UNIT_WIDTH) && Math.floor(man.y / UNIT_HEIGHT) == Math.floor(monsterBlinky.y / UNIT_HEIGHT))
			{
				if (isFireActive)
				{
					TweenLite.killDelayedCallsTo(monsterBlinky.enter_frame);
					TweenLite.killTweensOf(monsterBlinky);
					monsterBlinky.x = parseInt(xml.blinky.@x) * Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH / 2;
					monsterBlinky.y = parseInt(xml.blinky.@y) * Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT / 2;
					monsterBlinky.target = new Point(Math.floor(man.x), Math.floor(man.y));
					monsterBlinky.nextCell = new Point(monsterBlinky.x, monsterBlinky.y);
					monsterBlinky.curDirection = "up";
					TweenLite.delayedCall(1, startMonsterBlinky);
				}
				else if(!isEtherActive)
				{
					restartPrep();
				}
			}
			
			//monster.enter_frame();
			
			if (Math.floor(man.x / UNIT_WIDTH) == Math.floor(monster.x / UNIT_WIDTH) && Math.floor(man.y / UNIT_HEIGHT) == Math.floor(monster.y / UNIT_HEIGHT))
			{
				if (isFireActive)
				{
					TweenLite.killDelayedCallsTo(monster.enter_frame);
					TweenLite.killTweensOf(monster);
					monster.x = parseInt(xml.blinky.@x) * Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH / 2;
					monster.y = parseInt(xml.blinky.@y) * Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT / 2;
					monster.targetIndex = 0;
					monster.target = monster.arr[monster.targetIndex];
					monster.nextCell = new Point(monster.x, monster.y);
					monster.curDirection = "up";	
					TweenLite.delayedCall(1, startMonster);
				}
				else if(!isEtherActive)
				{
					restartPrep();				
				}
			}
			
			var monsterToManDist:int = Math.abs(Math.floor(monster.x / UNIT_WIDTH) - Math.floor(man.x / UNIT_WIDTH)) + Math.abs(Math.floor(monster.y / UNIT_WIDTH) - Math.floor(man.y / UNIT_WIDTH));
			if (monsterToManDist <= 8)
			{
				monster.target.x = Math.floor(man.x / UNIT_WIDTH) * UNIT_WIDTH + UNIT_WIDTH / 2;
				monster.target.y = Math.floor(man.y / UNIT_WIDTH) * UNIT_HEIGHT + UNIT_HEIGHT / 2;
			}
			else
			{
				monster.target = monster.arr[monster.targetIndex];
			}
			
			var targetX:int, targetY:int;
			
			if (isPinkyActive)
			{
				targetX = Math.floor(man.x / UNIT_WIDTH) * UNIT_WIDTH + UNIT_WIDTH / 2;
				targetY = Math.floor(man.y / UNIT_HEIGHT) * UNIT_HEIGHT + UNIT_HEIGHT / 2;
				
				if (left)
					targetX -= 4 * UNIT_WIDTH;
				else if (right)
					targetX += 4 * UNIT_WIDTH;
				else if (up)
					targetY -= 4 * UNIT_HEIGHT;
				else if (down)
					targetY += 4 * UNIT_HEIGHT;
				
				monsterPinky.target.x = targetX;
				monsterPinky.target.y = targetY;
				//monsterPinky.enter_frame();
				
				if (Math.floor(man.x / UNIT_WIDTH) == Math.floor(monsterPinky.x / UNIT_WIDTH) && Math.floor(man.y / UNIT_HEIGHT) == Math.floor(monsterPinky.y / UNIT_HEIGHT))
				{
					if (isFireActive)
					{
						TweenLite.killDelayedCallsTo(monsterPinky.enter_frame);
						TweenLite.killTweensOf(monsterPinky);
						monsterPinky.x = parseInt(xml.pinky.@x) * Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH / 2;
						monsterPinky.y = parseInt(xml.pinky.@y) * Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT / 2;
						monsterPinky.target = new Point(Math.floor(man.x), Math.floor(man.y));
						monsterPinky.nextCell = new Point(monsterPinky.x, monsterPinky.y);
						monsterPinky.curDirection = "up";
						TweenLite.delayedCall(1, startMonsterPinky);
					}
					else if(!isEtherActive)
					{
						restartPrep();
					}
				}
				
			}
			
			if (isInkyActive)
			{
				targetX = Math.floor(man.x / UNIT_WIDTH) * UNIT_WIDTH + UNIT_WIDTH / 2;
				targetY = Math.floor(man.y / UNIT_HEIGHT) * UNIT_HEIGHT + UNIT_HEIGHT / 2;
				
				if (left)
					targetX -= 2 * UNIT_WIDTH;
				else if (right)
					targetX += 2 * UNIT_WIDTH;
				else if (up)
					targetY -= 2 * UNIT_HEIGHT;
				else if (down)
					targetY += 2 * UNIT_HEIGHT;
				
				monsterInky.target.x = targetX;
				monsterInky.target.y = targetY;
				//monsterInky.enter_frame();
				
				if (Math.floor(man.x / UNIT_WIDTH) == Math.floor(monsterInky.x / UNIT_WIDTH) && Math.floor(man.y / UNIT_HEIGHT) == Math.floor(monsterInky.y / UNIT_HEIGHT))
				{
					if (isFireActive)
					{
						TweenLite.killDelayedCallsTo(monster.enter_frame);
						TweenLite.killTweensOf(monster);
						monsterInky.x = parseInt(xml.inky.@x) * Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH / 2;
						monsterInky.y = parseInt(xml.inky.@y) * Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT / 2;
						monsterInky.target = new Point(Math.floor(man.x), Math.floor(man.y));
						monsterInky.nextCell = new Point(monsterInky.x, monsterInky.y);
						monsterInky.curDirection = "up";
						TweenLite.delayedCall(1, startMonsterInky);
					}
					else if(!isEtherActive)
					{
						restartPrep();
					}
				}
			}
			
		}
		
		private function restartPrep():void
		{
				this.removeEventListener(Event.ENTER_FRAME, enter_frame);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
				stage.removeEventListener(KeyboardEvent.KEY_UP, key_up);
				TweenLite.killDelayedCallsTo(timerFunc);
				TweenLite.killDelayedCallsTo(removeReversal);
				removeReversal();
				
				left = false;
				right = false;
				up = false;
				down = false;
				
				totalScore -= 50;
				scorecard.scoretxt.text = "Score: " + totalScore;
				
				man.x = parseInt(xml.dta.@manx) * UNIT_WIDTH + UNIT_WIDTH / 2;
				man.y = parseInt(xml.dta.@many) * UNIT_HEIGHT + UNIT_HEIGHT / 2;
				 
				TweenLite.killDelayedCallsTo(monsterBlinky.enter_frame);
				TweenLite.killTweensOf(monsterBlinky);
				monsterBlinky.x = parseInt(xml.blinky.@x) * Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH / 2;
				monsterBlinky.y = parseInt(xml.blinky.@y) * Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT / 2;
				monsterBlinky.target = new Point(Math.floor(man.x), Math.floor(man.y));
				monsterBlinky.nextCell = new Point(monsterBlinky.x, monsterBlinky.y);
				monsterBlinky.curDirection = "up";
				
				TweenLite.killDelayedCallsTo(monsterPinky.enter_frame);
				TweenLite.killTweensOf(monsterPinky);
				monsterPinky.x = parseInt(xml.pinky.@x) * Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH / 2;
				monsterPinky.y = parseInt(xml.pinky.@y) * Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT / 2;
				monsterPinky.target = new Point(Math.floor(man.x), Math.floor(man.y));
				monsterPinky.nextCell = new Point(monsterPinky.x, monsterPinky.y);
				monsterPinky.curDirection = "up";

				TweenLite.killDelayedCallsTo(monsterInky.enter_frame);
				TweenLite.killTweensOf(monsterInky);
				monsterInky.x = parseInt(xml.inky.@x) * Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH / 2;
				monsterInky.y = parseInt(xml.inky.@y) * Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT / 2;
				monsterInky.target = new Point(Math.floor(man.x), Math.floor(man.y));
				monsterInky.nextCell = new Point(monsterInky.x, monsterInky.y);
				monsterInky.curDirection = "up";

				TweenLite.killDelayedCallsTo(monster.enter_frame);
				TweenLite.killTweensOf(monster);
				monster.x = parseInt(xml.blinky.@x) * Pacman.UNIT_WIDTH + Pacman.UNIT_WIDTH / 2;
				monster.y = parseInt(xml.blinky.@y) * Pacman.UNIT_HEIGHT + Pacman.UNIT_HEIGHT / 2;
				monster.targetIndex = 0;
				monster.target = monster.arr[monster.targetIndex];
				monster.nextCell = new Point(monster.x, monster.y);
				monster.curDirection = "up";

				resumeTimer = 5;
				resumePanel.visible = true;
				resumePanel.timertxt.text = resumeTimer + " secs.";
				TweenLite.delayedCall(1, resumeFunc);
				
				breakIce();
		}
		
		private function key_up(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.LEFT)
			{
				left = false;
			}
			if (e.keyCode == Keyboard.RIGHT)
			{
				right = false;
			}
			if (e.keyCode == Keyboard.UP)
			{
				up = false;
			}
			if (e.keyCode == Keyboard.DOWN)
			{
				down = false;
			}
		}
		
		private function key_down(e:KeyboardEvent):void 
		{
			////trace(e.keyCode);
			if (e.keyCode == Keyboard.LEFT)
			{
				left = maze.canMoveLeft(man.x - man.width / 2, man.y - man.height / 2, moveFactor);
				man.play();
			}
			if (e.keyCode == Keyboard.RIGHT)
			{
				right = maze.canMoveRight(man.x - man.width / 2, man.y - man.height / 2, moveFactor);
				man.play();
			}
			if (e.keyCode == Keyboard.UP)
			{
				up = maze.canMoveUp(man.x - man.width / 2, man.y - man.height / 2, moveFactor);
				man.play();
			}
			if (e.keyCode == Keyboard.DOWN)
			{
				down = maze.canMoveDown(man.x - man.width / 2, man.y - man.height / 2, moveFactor);
				man.play();
			}
		}
		
		private function timerFunc():void
		{
			timer++;
			scorecard.timetxt.text = "Time: " + timer + " secs.";
			TweenLite.delayedCall(1, timerFunc);
			
			if (timer > 20 / levelNumber)
			{
				isPinkyActive = true;
				monsterPinky.visible = true;
				monsterPinky.enter_frame();
			}
			if (timer > 40 / levelNumber)
			{
				isInkyActive = true;
				monsterInky.visible = true;
				monsterInky.enter_frame();
			}
			/*
			if (timer % 15 == 0)
			{
				monsterBlinky.canReverse = true;
				monsterInky.canReverse = true;
				monsterPinky.canReverse = true;
				monster.canReverse = true;
				TweenLite.delayedCall(5, removeReversal);
			}*/
		}
		
		private function removeReversal():void 
		{
				monsterBlinky.canReverse = false;
				monsterInky.canReverse = false;
				monsterPinky.canReverse = false;
				monster.canReverse = false;			
		}
		
		private function resumeFunc():void
		{
			resumeTimer--;
			if (resumeTimer == 0)
			{
				resumePanel.visible = false;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
				stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
				this.addEventListener(Event.ENTER_FRAME, enter_frame);
				TweenLite.delayedCall(1, timerFunc);
				
				monsterBlinky.enter_frame();
				monster.enter_frame();
				if (isPinkyActive)
					monsterPinky.enter_frame();
				if (isInkyActive)
					monsterInky.enter_frame();
			}
			else
			{
				resumePanel.timertxt.text = resumeTimer + " secs.";
				TweenLite.delayedCall(1, resumeFunc);
			}
			
		}
		
		private function pauseGame():void
		{
				this.removeEventListener(Event.ENTER_FRAME, enter_frame);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
				stage.removeEventListener(KeyboardEvent.KEY_UP, key_up);
				TweenLite.killDelayedCallsTo(timerFunc);
				TweenLite.killDelayedCallsTo(removeReversal);
				removeReversal();
				
				left = false;
				right = false;
				up = false;
				down = false;
				
				TweenLite.killDelayedCallsTo(monster.enter_frame);
				TweenLite.killTweensOf(monster);
				TweenLite.killDelayedCallsTo(monsterBlinky.enter_frame);
				TweenLite.killTweensOf(monsterBlinky);
				TweenLite.killDelayedCallsTo(monsterPinky.enter_frame);
				TweenLite.killTweensOf(monsterPinky);
				TweenLite.killDelayedCallsTo(monsterInky.enter_frame);
				TweenLite.killTweensOf(monsterInky);
				
				monsterBlinky.x = monsterBlinky.nextCell.x;
				monsterBlinky.y = monsterBlinky.nextCell.y;
				
				monsterPinky.x = monsterPinky.nextCell.x;
				monsterPinky.y = monsterPinky.nextCell.y;
				
				monsterInky.x = monsterInky.nextCell.x;
				monsterInky.y = monsterInky.nextCell.y;
				
				monster.x = monster.nextCell.x;
				monster.y = monster.nextCell.y;
		}
		
		private function playGame():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
				stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
				this.addEventListener(Event.ENTER_FRAME, enter_frame);
				TweenLite.delayedCall(1, timerFunc);
				
				monsterBlinky.enter_frame();
				monster.enter_frame();
				if (isPinkyActive)
					monsterPinky.enter_frame();
				if (isInkyActive)
					monsterInky.enter_frame();
		}
		
		private function waterClicked(ev:MouseEvent):void
		{
			scorecard.watermc.buttonMode = false;
			scorecard.watermc.alpha = 0.3;
			scorecard.watermc.removeEventListener(MouseEvent.CLICK, waterClicked);
			
			moveFactor = 8;
			
			maze.makeIce();
			TweenLite.delayedCall(10, breakIce);
		}
		
		private function breakIce():void
		{
			moveFactor = 4;
			maze.breakIce();
			scorecard.watermc.alpha = 0.3;
		}
		
		private function douseFire():void
		{
			isFireActive = false;
			scorecard.firemc.alpha = 0.3;
		}
		
		private function teleportmenu(ev:MouseEvent):void
		{
			maze.forTeleport(Math.floor(this.mouseX / UNIT_WIDTH), Math.floor(this.mouseY / UNIT_HEIGHT));
		}
		
		private function teleportTo(ev:MouseEvent):void
		{
			if (maze.forTeleport(Math.floor(this.mouseX / UNIT_WIDTH), Math.floor(this.mouseY / UNIT_HEIGHT)))
			{
				man.x = Math.floor(this.mouseX / UNIT_WIDTH) * UNIT_WIDTH + UNIT_WIDTH / 2;
				man.y = Math.floor(this.mouseY / UNIT_HEIGHT) * UNIT_HEIGHT + UNIT_HEIGHT / 2;
				this.removeEventListener(MouseEvent.CLICK, teleportTo);
				this.removeEventListener(MouseEvent.MOUSE_MOVE, teleportmenu);
				maze.removeRect(Math.floor(this.mouseX / UNIT_WIDTH), Math.floor(this.mouseY / UNIT_HEIGHT));
				playGame();
				scorecard.airmc.alpha = 0.3;
			}
		}
		
		private function earthmenu(ev:MouseEvent):void
		{
			maze.forEarth(this.mouseX, this.mouseY);
		}
		
		private function earthTo(ev:MouseEvent):void
		{
			if (maze.forEarth(this.mouseX, this.mouseY))
			{
				maze.addWall(this.mouseX, this.mouseY);
				this.removeEventListener(MouseEvent.CLICK, earthTo);
				this.removeEventListener(MouseEvent.MOUSE_MOVE, earthmenu);
				maze.removeRect(Math.floor(this.mouseX / UNIT_WIDTH), Math.floor(this.mouseY / UNIT_HEIGHT));
				playGame();	
				scorecard.earthmc.alpha = 0.3;
			}
		}
		
		private function startMonsterBlinky():void
		{
			monsterBlinky.enter_frame();
		}
		
		private function startMonsterPinky():void
		{
			monsterPinky.enter_frame();
		}
		private function startMonsterInky():void
		{
			monsterInky.enter_frame();
		}

		private function startMonster():void
		{
			monster.enter_frame();
		}
		
		private function resetEther():void
		{
			isEtherActive = false;
			scorecard.ethermc.alpha = 0.3;
		}
		
		private function showGrid():void
		{
			
		}
		
		private function loadComp(ev:Event):void
		{
			//navigateToURL(new URLRequest("http://www.bits-oasis.org/2013test/backend/pacman/?id=" + uid), "_self");
		}
		private function loadComp2(ev:Event):void
		{
			//navigateToURL(new URLRequest("http://www.bits-oasis.org/2013test/backend/pacman/?id=" + uid), "_self");
		}
	}

}