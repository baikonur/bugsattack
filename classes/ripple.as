//汎用弾
package {
	import flash.display.*;
	import flash.events.*;
	
	public class ripple extends flash.display.MovieClip {
		public var initX:Number = 0;
		public var initY:Number = 0;
		public var dy:Number;
		
		function ripple(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 		
		public var _root:MovieClip;
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			if ( _root.stageNo == 0 ) {
				stop();
				return;
			}			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			x = initX;
			y = initY;
			dy = 14*_root.NEW_SIZE_RATIO;
		}
		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}		
		
		private function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			y += dy;
			if( _root.mcShip.shield > 0 && hitTestObject(_root.mcShip.ha) ){
				_root.mcShip.hit();
			}
			if( y > 600 ) {
				end();
			}
		}
		public function end():void{
			parent.removeChild(this);
		}
	}
}