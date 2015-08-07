//加粒子砲
package {
	import flash.display.*;
	import flash.events.*;
	
	public class laserBeam extends MovieClip {
		public var life:int;
		public var pMgr:eManager;
		public var count:int;

		function laserBeam(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 		
		public var _root:MovieClip;
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			if( _root.stageNo > 0 ){
				addEventListener(Event.ENTER_FRAME, _onEnterFrame);
				count = 0;
				pMgr = _root.enemyManager;
				life = 9 * 30;//秒*フレームレート			
			}
		}
		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}		
		

		private function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			if( _root.mcShip.shield <= 0 ) {
				parent.removeChild(this);
				return;
			}

			if( life > 0 ){
				if(count&1){
					var n:int = pMgr.cast.length;
					for( var i:int = 0; i < n; i++){
						var p:MovieClip = pMgr.cast[i];
						if ( p == null ) continue;
						if( p.wait > 0 ) continue;
						if( hitTestObject(p) ){
							p.hit(1);
						}
					}
				}
			}else{
				if( life == 0 ) {
					life = -1;
					gotoAndPlay("GOODBYE");
				}
				//removeMovieClip(this);
			}
			life--;
			count++;
		}

	}
}