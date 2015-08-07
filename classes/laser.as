//敵のレーザー
package {
	import flash.display.*;
	import flash.events.*;
	
	public class laser extends MovieClip {
		public var initX:Number;
		public var initY:Number;
		public var life:int = 18;
		public var master:MovieClip = null;
		public var stat:Number = 0;

		function laser(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 		
		public var _root:MovieClip;
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			if( _root.stageNo > 0 ){
				addEventListener(Event.ENTER_FRAME, _onEnterFrame);
				x = initX;
				y = initY;
				stat = 0;
				master.gotoAndStop("ATTACK");
			}
		}
		private function _onUnload(e:Event):void {
			try{
			_root.sfx_beam.stop();
			}catch(e:Error){}
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}		
		
		private function _onEnterFrame(e:Event):void {
			life--;
			if( life <= 0 ) {
				//die();
				if( life == 0 ) gotoAndPlay("FADE");
				//onEnterFrame = null;
			}else{
				if( stat > 0 ){
					if( hitTestPoint(_root.mcShip.x, _root.mcShip.y, true) ){
						_root.mcShip.hit();
					}
				}
			}
		}
		
		public function die():void {
			stop();
			if( master != null ){
				master.gotoAndStop(1);
				master.subWaponNotify(0, 0);
			}
			parent.removeChild(this);
		}
	}
}