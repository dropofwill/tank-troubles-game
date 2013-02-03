package code {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class TimedTargets extends MovieClip {
	
	private var manager:Main;
	private var speed:int = 3;
	private var fX:int;
	private var fY:int;
	private var pointsAwarded:int;
	private var exploding:Boolean = false;
	
	private var timer:Timer;
	
	
		public function TimedTargets(aX,aY,mgr,aAngle,aScale,lifeExpect,points) {
			// constructor code
			this.x = aX;
			this.y = aY + 100;
			this.manager = mgr;
			this.rotation = aAngle;
			this.width = this.width * aScale;
			
			pointsAwarded = points;
			
			fX = this.x;
			fY = this.y;
			
			if (aAngle == 180) //Bottom
			{
				fY = 650;				
			}
			else if (aAngle == 0) //Top
			{
				fY = 150;
			}
			else if (aAngle == 90) //Right
			{
				fX = 950;
			}
			else if (aAngle == 270)//Left
			{
				fX = 100;
			}
			else if (aAngle == 90.1) //Right second round
			{
				fX = 750;
			}
			else if (aAngle == 270.1) //Left second round 
			{
				fX = 250;
			}
			
			addEventListener(Event.ENTER_FRAME, frameLoop);
			
			timer = new Timer(lifeExpect,1);
			timer.addEventListener(TimerEvent.TIMER, timerDeath);
			timer.start();
			
		}
		
		public function explode()
		{
			this.play();
			exploding = true;
		}
		
		public function timerDeath(e:TimerEvent):void
		{
			//Makes sure the target isn't already been shot before removing it
			if (exploding == false)
			{
				this.manager.deleteTimedTargets(this,0);
				this.timedTargetsCleaner();
			}
		}
		
		public function targetsOver():void
		{
			this.manager.deleteTimedTargets(this,0);
			this.timedTargetsCleaner();
		}
		
		public function frameLoop(e:Event)
		{
			//Slides the targets in from the appropriate angle
			if(this.x != fX)
			{
				var dX:int = this.x - fX;
				this.x -= dX/speed;
			}
			
			if(this.y != fY)
			{
				var dY:int = this.y - fY;
				this.y -= dY/speed;
			}
			
			// check for explosion complete
			if(currentFrame == totalFrames)
			{
				// time to die
				this.manager.deleteTimedTargets(this,pointsAwarded);
			}
		}
		
		public function setMultiplier(multiplier)
		{
			pointsAwarded *= multiplier;
			
		}
		
		function timedTargetsCleaner():void
		{
			removeEventListener(Event.ENTER_FRAME, frameLoop);
			timer.removeEventListener(TimerEvent.TIMER, timerDeath);
		}
	}
}
