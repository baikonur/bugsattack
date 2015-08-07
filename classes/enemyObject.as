//自機と衝突判定のあるMC (シェイプ判定)
package {
	import flash.display.*;
	import flash.events.*;
	
	public class enemyObject extends MovieClip {
		public var enable:Boolean = true;
		public var shape:Boolean = true;
		public var mcHilite:MovieClip;
		
		function enemyObject(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 		
		public var _root:MovieClip;
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			if ( _root.stageNo > 0 ) {
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			}
		}
		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			if(  enable && _root.mcShip.stat == 1 ){
				var tx:Number = _root.mcShip.x;
				var ty:Number = _root.mcShip.y;
				if( hitTestPoint(tx, ty, shape ) ||
					hitTestPoint(tx+11*_root.NEW_SIZE_RATIO, ty+15*_root.NEW_SIZE_RATIO, shape ) ||
					hitTestPoint(tx+11*_root.NEW_SIZE_RATIO, ty-15*_root.NEW_SIZE_RATIO, shape ) ||
					hitTestPoint(tx-11*_root.NEW_SIZE_RATIO, ty+15*_root.NEW_SIZE_RATIO, shape ) ||
					hitTestPoint(tx-11*_root.NEW_SIZE_RATIO, ty-15*_root.NEW_SIZE_RATIO, shape ) ){
					_root.mcShip.hit();
				}
			}
		}
	}
}