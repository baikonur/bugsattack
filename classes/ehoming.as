package {
	import flash.display.*;
	import flash.events.*;
	
	public class ehoming extends homing {
		//public var hp:Number;
		
		function ehoming() {
			//super.homing();
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);	
		} 		
		
		public function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			
			ha.visible = false;
			x = initX;
			y = initY;
			IDn = parent.getChildIndex(this);
			stat = 1;
			rotateCoeff = 1.0;
			wait = 2;
			//_root.enemyManager.push(this);
			LifeTime = 10000;
			hp = 4;
		}
		

		/*
		function hit(damage:Number):Number{
			hp -= damage;
			if( hp <= 0 ) die();
			return hp;
		}
		*/
		/*
		function die(){
			stat = 0;
			wait = 10000;
			visible = false;
			_root.enemyManager.remove(this);
			removeMovieClip(this);
		}
		*/
	}
}