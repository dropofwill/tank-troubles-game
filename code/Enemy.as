package code {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import Math;
	
	
	public class Enemy extends MovieClip {
		
		private var manager:Main;
		
		private var isLoaded:Boolean = false;
		private var reloadSpeed:int = 400;
		private var reloadTimer:Timer;
		
		private var startX:int;
		private var startY:int;
		
		private var targetX:int;
		private var targetY:int;
		
		private var index:int;
		
		public function Enemy(aX,aY,sX,sY,rotate,mgr,ind) {
			// constructor code
			this.x = aX;
			this.y = aY;
			this.width *= sX;
			this.height *= sY;
			this.rotation = rotate;
			
			this.index = ind;
			
			startX = aX;
			startY = aY;			
			
			this.manager = mgr;
			
			reloadTimer = new Timer(reloadSpeed,1);
			reloadTimer.addEventListener(TimerEvent.TIMER, reload);
			reloadTimer.start();
			
			addEventListener(Event.ENTER_FRAME, frameLoop);
		}
		
		public function explode():void
		{
			this.play();
		}
		
		private function frameLoop(e:Event):void
		{
			targetX = (parent as MovieClip).getCharX();
			targetY = (parent as MovieClip).getCharY();
			
			followChar();
			
			// check for explosion complete
			if(currentFrame == totalFrames)
			{
				// deleting enemy
				this.manager.deleteEnemy(this);
			}
		}
	
		public function followChar():void
		{
			var opposite:Number;
			var adjacent:Number;
			var degrees:Number;
			var radians:Number;

			//Just some basic trig to figure out how much to rotate
			opposite = targetY - this.y;
			adjacent = targetX - this.x;

			radians = Math.atan2(opposite,adjacent);

			degrees = radians * 180 / Math.PI;

			this.rotation = degrees;
		}
		
		//returns whether to fire bullet based on a timer
		public function allowedToFire(currentLevel:String):Boolean
		{
			var fire:Boolean;
			
			if (isLoaded == true)
			{
				//decides when to shoot based on character's position depending on the level
				if (currentLevel == "level_1")
				{					
					if (targetY > 600 || targetY < 200)
					{
						if (targetX > 450)
						{
							fire = true;
							isLoaded = false;
							
							reloadTimer = new Timer(reloadSpeed,1);
							reloadTimer.addEventListener(TimerEvent.TIMER, reload);
							reloadTimer.start();
						}
					}
				}
				else if (currentLevel == "level_2")
				{					
					if (targetY > 450 && index == 1)
					{
						fire = true;
						isLoaded = false;
						
						reloadTimer = new Timer(reloadSpeed,1);
						reloadTimer.addEventListener(TimerEvent.TIMER, reload);
						reloadTimer.start();
						
					}
					else if (targetY < 350 && index == 0)
					{
						fire = true;
						isLoaded = false;
						
						reloadTimer = new Timer(reloadSpeed,1);
						reloadTimer.addEventListener(TimerEvent.TIMER, reload);
						reloadTimer.start();
						
					}
					else if (targetX > 900)
					{
						fire = true;
						isLoaded = false;
						
						reloadTimer = new Timer(reloadSpeed,1);
						reloadTimer.addEventListener(TimerEvent.TIMER, reload);
						reloadTimer.start();
					}
				}
				else if (currentLevel == "level_3")
				{
					if (targetY > 450 && index == 1)
					{
						fire = true;
						isLoaded = false;
						
						reloadTimer = new Timer(reloadSpeed,1);
						reloadTimer.addEventListener(TimerEvent.TIMER, reload);
						reloadTimer.start();
						
					}
					else if (targetY < 350 && index == 0)
					{
						fire = true;
						isLoaded = false;
						
						reloadTimer = new Timer(reloadSpeed,1);
						reloadTimer.addEventListener(TimerEvent.TIMER, reload);
						reloadTimer.start();
						
					}
					else if (targetX > 450)
					{
						fire = true;
						isLoaded = false;
						
						reloadTimer = new Timer(reloadSpeed,1);
						reloadTimer.addEventListener(TimerEvent.TIMER, reload);
						reloadTimer.start();
					}
				}
			}
			else
			{
				fire = false;
			}
			
			return fire;
		}
		
		//"reloads" the enemy's guns
		private function reload(e:TimerEvent):void
		{
			isLoaded = true;
			
			e.target.stop();
			
			reloadTimer = null;
		}
		
		public function enemyCleaner():void
		{
			removeEventListener(Event.ENTER_FRAME, frameLoop);
		}
	}
	
}
