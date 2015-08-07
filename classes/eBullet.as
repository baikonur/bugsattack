package {
	import flash.display.*;
	import flash.events.*;
	
	public class eBullet extends MovieClip {
		public var dx:Number = 0;
		public var dy:Number = 0;
		public var initX:Number = 0;
		public var initY:Number = 0;
		public var speed:Number = 8;
		public var coeff:Number = 1.0;//加速係数
		public var master:MovieClip;
		public var type:Number = 0;
		public var stat:Number = 0;
		public var count:Number = 0;
		public var myNo:Number;

		function eBullet(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 		
		public var _root:MovieClip;
		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}		// {initX:*, initY:*, type:*, speed:*}
		
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
			switch(type){
				case 0: //まっすぐ
							dx = 0;
							dy = speed;
							break; 
							/*
				case 1: //狙い ケムリあり
							myNo = _root.ebFxSerial++;//ケムリDepth用
							if( _root.ebFxSerial > 1000 ) _root.ebFxSerial = 0;
							var ddx = _root.mcShip.x - x;
							var ddy = _root.mcShip.y - y;
							var r = Math.sqrt( ddx*ddx + ddy* ddy );
							var t = r / speed;
							dx = ddx / t;
							dy = ddy / t;
							x += (dx*8);
							y += (dy*8);
							turnFace();
							break;
					*/
				case 3: break;
				default: //狙い
							var ddx:Number = _root.mcShip.x - x;
							var ddy:Number = _root.mcShip.y - y;
							var r = Math.sqrt( ddx*ddx + ddy* ddy );
							var t = r / speed;
							dx = ddx / t;
							dy = ddy / t;
							break;
			}
			stat = 1;
			count = 0;
			if( _root.missileNo > 10000 ) _root.missileNo = 0;
		}
		public function turnFace():void{
			var radx:Number = _root.GetRadian( x, y, _root.mcShip.x, _root.mcShip.y );
			rotation = radx * 180 / Math.PI;
		}
		private function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			if( stat ){
				x += dx;
				y += dy;
				/*
				if( coeff != 1.0 ){
					dx *= coeff;
					dy *= coeff;
				}
				*/
				var rr:Number = _root.NEW_SIZE_RATIO;
				var ax:Number = x;
				var ay:Number = y;
				if( ay > 600*rr/*_root.STAGE_HEIGHT*/ || ax > _root.STAGE_WIDTH*rr/**/ || ay < 0 || ax < 0 ) {
					die();
					return;
				}
				if( _root.doHitChk && _root.mcShip.currentFrame <= 3 && _root.mcShip.shield > 0 ){
					if( _root.mcShip.ha.hitTestPoint(ax, ay, false) ) {
						die();
						_root.mcShip.hit();
					}
				}
			}
			count++;
			/*
			if( type == 1 && count < 27 ) {
				var ofs = myNo*100 + count;
				//trace("missile "+myNo +  "  " + ofs);
				var psmk = _root.attachMovie("ID_SMOKE","mcSmoke"+ofs, _root.DEPTH_SMOKE+ofs);
				psmk.x = x;
				psmk.y = y;
			}
			*/
		}
		public function die():void{
			stat = 0;
			parent.removeChild(this);
		}
	}
}