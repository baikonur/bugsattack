//ガマ爆弾
package {
	import flash.display.*;
	import flash.events.*;
	
	public class gamaBomb extends MovieClip {
		public var stat:Number;
		public var mcBomb:MovieClip;
		public var chakudan:Boolean;
		public var r:Array = [0, 15, -30, -42];
		
		function gamaBomb(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		}
		public var _root:MovieClip;
		
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			stat = 1;
			chakudan = false;
			var idx:Number = Math.floor(Math.random()*4);
			rotation = r[ idx ];
			if( idx == 1 ) {
				x -= 52*_root.NEW_SIZE_RATIO;
				y -= 8*_root.NEW_SIZE_RATIO;
			}
		}
		
		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
			
		private function _onEnterFrame(e:Event):void {
			if( stat == 1 ){
				if( hitTestPoint(_root.mcShip.x, _root.mcShip.y, true)){
					if( chakudan ){
						stat = 0;
						_root.mcShip.hit();					
					}else{
						stop();
						mcBomb.gotoAndPlay("EXPLOSION");
						stat = 0;
						_root.mcShip.hit();
					}
				}
			}
		}
		public function end():void{
			//removeMovieClip(this);
			visible = false;
		}
	}
}
