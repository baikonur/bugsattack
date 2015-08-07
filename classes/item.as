package {
	import flash.display.*;
	import flash.events.*;
	
	public class item extends MovieClip {
		public var initX:Number;
		public var initY:Number;
		public var type:int= 0;
		public var dx:Number;
		public var dy:Number;
		public var no:int;
		public var lifeTime:Number=1;

		function item(){
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
			if( _root.stageNo > 0 ){
				addEventListener(Event.ENTER_FRAME, _onEnterFrame);
				lifeTime = 29 * 60;
				if( !isNaN(initX) ) x = initX;
				if( !isNaN(initY) ) y = initY;
				if( y < -16 ) y = -16;
				dx = 4*_root.NEW_SIZE_RATIO;
				if( Math.floor(Math.random()*2) == 0 ) dx = -dx;
				dy = 6*_root.NEW_SIZE_RATIO;
				gotoAndStop(type + 1);
			}
		}
		
		private function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			lifeTime--;
			if( lifeTime <= 0 || _root.mcShip.shield <= 0 ) parent.removeChild(this);
			x += dx;
			y += dy;
			if( x < -16*_root.NEW_SIZE_RATIO || x > _root.STAGE_WIDTH+16*_root.NEW_SIZE_RATIO ) dx = -dx;
			if( y < -16*_root.NEW_SIZE_RATIO || y > _root.STAGE_HEIGHT+16*_root.NEW_SIZE_RATIO ) dy = -dy;
			if( hitTestObject(_root.mcShip) ){
				if( _root.mcShip.suppeArm != null ){
					if( hitTestObject(_root.mcShip.ha) ){
						getItem();
					}
				}else{
					getItem();
				}
			}
		}
		
		public function getItem():void{
			switch(type){
			case 0: //回復
						if( _root.masterVol > 0 ) _root.sfx_pup.start();
						_root.mcShip.heal();
						trace("回復ー");
						break;
			case 1://PowerUp
						if( _root.masterVol > 0 ) _root.sfx_pup.start();
						_root.mcShip.powerUp();
						trace("パワーアップー");
						break;
			case 2://Weapon
						if( _root.masterVol > 0 ) _root.sfx_pup.start();
						_root.GetSpecial();
						trace("レーザー");
						break;
			case 3://Star
						if( _root.masterVol > 0 ) _root.sfx_52.start();
						_root.GetStar();
						trace("星ー");
						break;
			}
			parent.removeChild(this);
		}
	}
}