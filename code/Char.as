package code
{

	import flash.display.MovieClip;
	import Math;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Char extends MovieClip
	{

		private var speed:Number = 0.25;
		private var isLoaded:Boolean = true;
		private var reloadSpeed:int = 200;
		private var reloadTimer:Timer;
		private var deltaX:Number;
		private var deltaY:Number;

		public function Char(aX:int,aY:int)
		{
			// constructor code
			this.x = aX;
			this.y = aY;
		}
		
		//moves the tank's turret towards (fX,fY)
		public function moveChar(fX,fY,fR,forward:Boolean):void
		{
			var dX:int = fX - this.x;
			var dY:int = fY - this.y;
			
			//slight accelaration
			if (speed < 2)
			{
				speed += 0.25;
			}
			
			if (dX * dX + dY * dY < speed * speed)
			{
				this.x = fX;
				this.y - fY;
			}
			else
			{
				var radians:Number = Math.atan2(dY,dX);
				var vX:Number = Math.cos(radians) * speed;
				var vY:Number = Math.sin(radians) * speed;
				
				
				//functionality for moving backwards, didn't end up using it
				if (forward == true)
				{
					this.x += vX;
					this.y += vY;
				}
				else 
				{
					this.x -= vX;
					this.y -= vY;
				}
			}
			
		}
		
		//returns whether to fire bullet based on a timer
		public function fireBullet():Boolean
		{
			var fire:Boolean;
			
			if (isLoaded == true)
			{
				fire = true;
				isLoaded = false;
				
				reloadTimer = new Timer(reloadSpeed,1);
				reloadTimer.addEventListener(TimerEvent.TIMER, reload);
				reloadTimer.start();
			}
			else
			{
				fire = false;
			}
			
			return fire;
		}
		
		//"reloads" the tank's gun
		public function reload(e:TimerEvent):void
		{
			isLoaded = true;
			
			e.target.stop();
			
			reloadTimer = null;
		}
		
		//Rotates the turret to follow the cursor
		public function followCursor(fX,fY):void
		{
			var opposite:Number;
			var adjacent:Number;
			var degrees:Number;
			var radians:Number;

			//Just some basic trig to figure out how much to rotate
			opposite = fY - this.y;
			adjacent = fX - this.x;

			radians = Math.atan2(opposite,adjacent);

			degrees = radians * 180 / Math.PI;

			this.rotation = degrees;
		}
		
		public function charCleaner():void
		{
			reloadTimer.removeEventListener(TimerEvent.TIMER, reload);
		}
	}

}