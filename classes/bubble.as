//泡
package {
	import flash.display.*;
	import flash.events.*;	
	
	public class bubble extends MovieClip {
		public var initX:Number = 0;
		public var initY:Number = 0;
		public var dy:Number;
		public var phase:Number;
	
		function bubble(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 		
		public var _root:MovieClip;
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			x = initX;
			y = initY;
			dy = 8;
			phase = 0;
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}		
		private function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			if( phase == 0 ){
				y += dy;
				if( y > 550 || y > _root.mcShip.y ) {
					phase = 1;
					gotoAndPlay("BURST");
				}
			}else{
				if( _root.mcShip.shield > 0 && hitTestObject(_root.mcShip.ha) ){
					_root.mcShip.Speed = 2;
				}
			}
		}
		public function end():void{
			_root.mcShip.Speed = 16;
		}
	}
}