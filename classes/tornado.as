package {
	import flash.display.*;
	import flash.events.*;
	
	public class tornado extends MovieClip {
		var dx:Number = 0;
		var dy:Number = 0;
		var initX:Number = 0;
		var initY:Number = 0;
		var speed:Number = 8;
		var coeff:Number = 1.0;
		var master:MovieClip;
		var type:Number = 0;
		var stat:Number = 0;
		var r:Number = 0;
		var rad:Number = 0;
		var piv:Number = 0;

		function tornado(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 		
		public var _root:MovieClip;
		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}		
		
		// {initX:*, initY:*, speed:*}
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			if( _root.stageNo > 0 ){
				addEventListener(Event.ENTER_FRAME, _onEnterFrame);
				x = initX;
				y = initY;
				r = 0;
				rad = 1.0;
				stat = 1;
				if( _root.missileNo > 10000 ) _root.missileNo = 0;
				var ddx:Number = _root.mcShip.x - x;
				var ddy:Number = _root.mcShip.y - y;
				var r:Number = Math.sqrt( ddx*ddx + ddy* ddy );
				var t:Number = r / (speed);
				dx = ddx / t *_root.NEW_SIZE_RATIO;
				dy = ddy / t *_root.NEW_SIZE_RATIO;
				piv = Math.PI / 16;
				if( Math.random()*2 >= 1 ) piv *= -1;
				
				var radx:Number = _root.GetRadian( x, y, _root.mcShip.x, _root.mcShip.y );
				rotation = radx * 180 / Math.PI;
			}
		}
		private function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			if( stat ){
				if(r< 24) r += 2;
				rad += piv;
				x = r * Math.cos(rad) + initX;
				y = r * Math.sin(rad) + initY;
				initX += dx;
				initY += dy;
			}
			var ax:Number = x;
			var ay:Number = y;
			if( ay > _root.STAGE_HEIGHT || ax > _root.STAGE_WIDTH || ay < 0 || ax < 0 || r > 500*_root.NEW_SIZE_RATIO ){
				die();
			}
			if( _root.doHitChk ){
				if( _root.mcShip.shield > 0 && _root.mcShip.ha.hitTestPoint(ax, ay, true) ) {
					die();
					_root.mcShip.hit();
				}
			}
		}
		public function die():void{
			stat = 0;
			parent.removeChild(this);
		}
	}
}