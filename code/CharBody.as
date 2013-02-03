package code {
	
	import flash.display.MovieClip;

	
	public class CharBody extends MovieClip {
		
		private var speed:Number = 0.25;
		
		public function CharBody(aX:int,aY:int) {
			// constructor code
			this.x = aX;
			this.y = aY;
		}
		
		//moves the tank's body towards (fX,fY)
		public function moveCharBody(fX,fY,fR,forward:Boolean):void
		{
			var dX:int = fX - this.x;
			var dY:int = fY - this.y;
			
			this.rotation = fR;
			
			//Slight accelaration
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
	}
	
}
