package {
	import flash.display.*;
	import flash.events.*;
	
	public class rocket extends MovieClip {
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

		function rocket(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 		
		public var _root:MovieClip;

		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
	// {initX:*, initY:*, type:*, speed:*}
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			if( _root.stageNo > 0 ){
				x = initX;
				y = initY;
				myNo = _root.ebFxSerial++;//ケムリDepth用
				if ( _root.ebFxSerial > 1000 ) _root.ebFxSerial = 0;
				if( _root.mcShip != null ){
					var ddx:Number = _root.mcShip.x - x;
					var ddy:Number = _root.mcShip.y - y;
					var r:Number = Math.sqrt( ddx*ddx + ddy*ddy );
					var t:Number = r / speed;
					dx = ddx / t;
					dy = ddy / t;
					x += (dx*8*_root.NEW_SIZE_RATIO);
					y += (dy*8*_root.NEW_SIZE_RATIO);
					turnFace();
					stat = 1;
					count = 0;
					if ( _root.missileNo > 10000 ) _root.missileNo = 0;
					addEventListener(Event.ENTER_FRAME, _onEnterFrame);
					//_root.sfx_rocket.start();
				}
			}
		}
		public function turnFace(){
			var radx:Number = _root.GetRadian( x, y, _root.mcShip.x, _root.mcShip.y );
			rotation = radx * 180.0 / Math.PI;
		}
		private function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			if( stat ){
				x += dx;
				y += dy;
				dx *= coeff;
				dy *= coeff;
			}
			var ax:Number = x;
			var ay:Number = y;
			if( ay > _root.STAGE_HEIGHT || ax > _root.STAGE_WIDTH || ay < 0 || ax < 0 ) {
				die();
				return;
			}
			//if( hitTest(_root.mcShip.ha) ) {
			if( _root.mcShip.shield > 0 && _root.mcShip.currentFrame <= 3 && _root.mcShip.ha.hitTestPoint(ax, ay, false) ) {
			//if( _root.mcShip.hitTest(x, y, false) ) {
				die();
				_root.mcShip.hit();
				return;
			}
			count++;
			if( count < 27 ) {
				if( count == 1 && _root.soundOn ){
					_root.sfx_missile.start(0, 1);
				}
				var ofs:Number = myNo*100 + count;
				//trace("missile "+myNo +  "  " + ofs);
				var psmk:MovieClip = //_root.attachMovie("ID_SMOKE", "mcSmoke" + ofs, _root.DEPTH_SMOKE + ofs);
				AttachMc.core.add(_root.layer_base, "ID_SMOKE", "mcSmoke" + ofs);
				psmk.x = ax;
				psmk.y = ay;
			}
		}
		public function die():void{
			stat = 0;
			parent.removeChild(this);
		}
	}
}