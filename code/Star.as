package code {
	
	import flash.display.MovieClip;
	
	
	public class Star extends MovieClip {
		
		
		public function Star(aX:int,aY:int,sX:Number,sY:Number,rotate:Number) {
			// constructor code
			this.x = aX;
			this.y = aY;
			this.width *= sX;
			this.height *= sY;
			this.rotation = rotate;
		}
	}
	
}
