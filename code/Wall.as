package code {
	
	import flash.display.MovieClip;
	
	
	public class Wall extends MovieClip {
		
		
		public function Wall(aX:int,aY:int,sX:int,sY:int) {
			// constructor code
			
			
			this.x = aX;
			this.y = aY;
			this.width = sX;
			this.height = sY;
		}
	}
	
}
