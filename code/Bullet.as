package code
{

	import flash.display.MovieClip;
	import Math;
	import flash.events.Event;


	public class Bullet extends MovieClip
	{
		private var speed:Number; 						
		private var angle:Number;						
		private var deltaX:Number;
		private var deltaY:Number;
		private var bulletBounceCheck:Boolean = false;
		private var bounceTracker:int = 0;
		private var wallCollision:String;
		private var bulletMultiplier:int = 1;
		private var parentName:String;
		private var allowedToKill:Boolean = true;

		public function Bullet(aX:Number,aY:Number,aAngle:Number,aSpeed:Number,madeBy:String)
		{
			// constructor code

			this.addEventListener(Event.ENTER_FRAME, frameLoop);

			speed = aSpeed;
			angle = aAngle;
			parentName = madeBy;
			
			this.x = aX;
			this.y = aY;
			this.rotation = angle;
			
			//Just some trig to figure out how much to move the bullet each frame
			var aAngle = angle * Math.PI / 180;
			
			deltaX = Math.cos(aAngle   - (Math.PI/2)) * speed;
			deltaY = Math.sin(aAngle - (Math.PI/2)) * speed;
		}
	
		private function frameLoop(e:Event)
		{
			this.moveMe(angle,speed);
		}

		//moves the bullet
		private function moveMe(angle,speed)
		{
			if (bulletBounceCheck == true)
			{
				if (wallCollision == "horizontal")
				{
					deltaY = deltaY * -1;
					if (bounceTracker != 1)
					{
						angle = -angle;
						this.rotation = angle + 180;
						bounceTracker++;
					}
					else
					{
						angle = angle + 180 ;
						this.rotation = angle;
						bounceTracker++;
					}
				}
				else if (wallCollision == "vertical")
				{
					deltaX = deltaX * -1;
					
					if (bounceTracker != 1)
					{
						angle = -angle;
						this.rotation = angle;
						bounceTracker++;
					}
					else
					{
						angle = angle + 180;
						this.rotation = angle;
						bounceTracker++;
					}
				}
				
				bulletBounceCheck = false;
			}
			
			this.x +=  deltaX;
			this.y +=  deltaY;
		}
		
		//returns whether a bullet needs to be destroyed based on whether it is off the stage
		public function bulletBoundaryCheck():Boolean
		{
			var destroy:Boolean = false;
			
			if (this.x > stage.stageWidth)
			{
				destroy = true;
			}
			else if (this.x < 0)
			{
				destroy = true;
			}		
			else if (this.y > stage.stageHeight)
			{
				destroy = true;
			}
			else if (this.y < 0)
			{
				destroy = true;
			}
			
			return destroy;
		}
		
		public function bulletBouncer():void
		{
			bulletBounceCheck = true;
		}
		
		
		//determines the orientation of a particular wall
		public function wallOrient(sX,sY):void
		{
			if (sX > sY)
			{
				wallCollision = "horizontal";
			}
			else
			{
				wallCollision = "vertical";
			}
		}
		
		
		//returns the number of bounces
		public function getBounces():int
		{
			return bounceTracker;
		}
		
		//returns who made the bullet
		public function getParent():String
		{
			return parentName;
		}
		
		
		public function getAllowedToKill():Boolean
		{
			return allowedToKill;
		}
		
		public function setAllowedToKill(boolean:Boolean):void
		{
			allowedToKill = boolean;
		}
		
		//sets the multiplier for the time trial mode
		public function setBulletMultiplier(multiplier):void
		{
			bulletMultiplier = multiplier;
		}
		
		//returns the multiplier for the time trial mode
		public function getBulletMultiplier():int
		{
			return bulletMultiplier;
		}
		
		public function bulletCleaner():void
		{
			this.removeEventListener(Event.ENTER_FRAME, frameLoop);
		}
	}

}