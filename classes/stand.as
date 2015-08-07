package 
{
	import flash.display.*;
	import flash.events.*;
			
	public class stand extends MovieClip {
		public var adapter:enemyAdapter=null;
		public var instance:MovieClip;
		public var mcCore:MovieClip;
		
		function stand(){
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
			if(adapter != null){
				instance = adapter.instance;
			}else {
				stop();
			}
		}
		
		public function setAttack(doatk:Boolean):void {
			if(instance != null){
				instance.attackEnable(doatk);
			}
		}
		
		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		}
		
		public function setAdapter(pAdp:enemyAdapter):void {
			if ( pAdp.instance == null ) {
				trace("無効なので動きガイドを停止");
				stop();
			}else{
				instance = pAdp.instance;
				instance.moveGuide = this;
			}
		}

		public function callMethod(strName:String):void {
			if(adapter != null){
				instance = adapter.instance;
			}
			trace(strName + " " + instance);
		}
	}
}