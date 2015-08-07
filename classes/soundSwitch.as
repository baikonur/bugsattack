package {
	import flash.display.*;
	import flash.events.*;
	
	public class soundSwitch extends MovieClip {
		function soundSwitch(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 		
		public var _root:MovieClip;
		public function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			removeEventListener(MouseEvent.MOUSE_UP, _onUp);
			removeEventListener(MouseEvent.MOUSE_OVER, _onRollOver);
			removeEventListener(MouseEvent.MOUSE_OUT, _onRollOut);
			_root = null;
		}	
		public function _onLoad(e:Event):void {
			_root = root as MovieClip;
			addEventListener(Event.ENTER_FRAME, setAt1st);
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(MouseEvent.MOUSE_DOWN, _onPress);
			addEventListener(MouseEvent.MOUSE_UP, _onUp);
			addEventListener(MouseEvent.MOUSE_OVER, _onRollOver);
			addEventListener(MouseEvent.MOUSE_OUT, _onRollOut);
		}
		
		private function setAt1st(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, setAt1st);
			if( _root != null ){
				try{
					if( _root.soundOn ) gotoAndStop("_up_on");
					else gotoAndStop("_up_off");
				}catch(e:Error){}
			}
		}
	
		private function _onPress(me:MouseEvent):void{
			if( _root.soundOn ){
				gotoAndStop("_down_on");
			}else{
				gotoAndStop("_down_off");
			}
		}
		private function _onRollOver(me:MouseEvent):void{
			if( _root.soundOn ){
				gotoAndStop("_over_on");
			}else{
				gotoAndStop("_over_off");
			}
		}
		private function _onRollOut(me:MouseEvent):void{
			if( _root.soundOn ){
				gotoAndStop("_up_on");
			}else{
				gotoAndStop("_up_off");
			}
		}
		private function _onUp(me:MouseEvent):void{
			var flg = _root.SoundSwitch();
			if( flg ){
				gotoAndStop("_up_on");
			}else{
				gotoAndStop("_up_off");
			}
		}
		public function setSoundToggle():void{
			var sw = _root.SoundSwitch();
			if( sw ) gotoAndStop("_up_on");
			else gotoAndStop("_up_off");
		}
	}
}