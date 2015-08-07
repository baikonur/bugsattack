//自弾
package {
	import flash.display.*;
	import flash.events.*;
	
	public class bullet extends MovieClip {
		public var dx:Number = 0;
		public var dy:Number = 0;// = 12;
		public var initX:Number;
		public var initY:Number;
		public var power:Number = 1;
		public var kantsuu:Boolean  = false;
		
		function bullet(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 		
		public var _root:MovieClip;
		
		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			if ( _root.stageNo == 0 ) {
				stop();
				return;
			}			
			x = initX;
			y = initY;
			kantsuu = false;
			//onEnterFrame = onEnterNormal;
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);		//dy = 12;
		}
		public function setAttr(vX:Number, vY:Number, pow:Number, kan:Boolean):void{
			dx = vX*_root.NEW_SIZE_RATIO;
			dy = vY*_root.NEW_SIZE_RATIO;
			power = pow;
			kantsuu = kan;
		}
		
		public function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			var rr:Number = _root.NEW_SIZE_RATIO;
			x += dx;
			var ax:Number = x + 5*rr;
			y -= dy;
			var ay:Number = y + 6*rr;
			if( _root.layerEn.hitTestPoint(ax, ay, true) ){
				var pEnm = _root.enemyManager.searchHit(ax, ay);
				if( pEnm != null ){
					//trace("hit");
					pEnm.hit(power);
					//if( !kantsuu ) {
						die();
						return;
					//}
				}
			}
			if( y <= 6 ) die();
		}
		
		public function die():void{
			_root.mcShip.bulletOff();
			parent.removeChild(this);
		}
		
	}
}