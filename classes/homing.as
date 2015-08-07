//ホーミング
package {
	import flash.display.*;
	import flash.events.*;
	
	public class homing extends MovieClip {
		public var dx:Number;
		public var dy:Number;
		public var initX:Number = 0;
		public var initY:Number = 0;
		public var ha:MovieClip;
		public var hp:Number;
		public var stat:Number;
		public var wait:Number = 0;
		private var counter:Number = 0;
		public var IDn:Number;
		public var atkCount:Number;//攻撃回数のカウント
		public var atkLim:Number;
		private var temp:Number;
		public var rotateCoeff:Number = 1.0;
		private var TurnAbility:Number = 2;
		public var speed:Number = 8;
		public var master:MovieClip;
		private var LifeTime:Number = 90; //追っかける時間
		
		function homing() {
			dx = 0;
			dy = 8;
			hp = 50;
			temp = 2;
			counter = 0;
			wait = 0;
			rotVal = 0;
			TurnAbility = 1;
			speed = 8;
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 		
		public var _root:MovieClip;
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			if( _root.stageNo > 0 ){
				addEventListener(Event.ENTER_FRAME, _onEnterFrame);
				if (ha != null) ha.visible = false;
				x = initX;
				y = initY;
				IDn = parent.getChildIndex(this);
				stat = 1;
				rotateCoeff = 1.0;
				wait = 2;
				LifeTime = 90;
			}
		}
		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}		
		
		private var maeTg:Number = 0;
		private var rotVal:Number;
		private var tgDeg:Number;
		private var sign:int;
		private function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			if( wait ) {
				wait--;
				return;
			}
			if( counter > LifeTime ) {
				x += dx;
				y += dy;
			}else{
				//if( counter % 2 == 0 ){
					var rad:Number = _root.GetRadian( x, y, _root.mcShip.x, _root.mcShip.y );
					var deg:Number = (rad * 180.0 / Math.PI);
					if( deg > 180 ) deg = -(360-deg);
					tgDeg = deg;
					var def:Number = deg - rotation;
					if( def > 180 ) def = 360 - def;
					if( def < -180 ) def = -360 - def;
					sign = 1;
					var absdef = def;
					if( def < 0 ) {
						sign = -1;
						absdef *= -1; // == abs(def)
					}
					//if( maeTg != tgDeg ) trace(def);
				
					if( ( def < 0 && rotation > 90 && tgDeg < -90 && sign < 0 ) ||
						( def > 0 && rotation < -90 && tgDeg > 90 && sign > 0 ) ){//０度またぎチェック
						sign *= -1;
					}
				
					maeTg = tgDeg;
					//var absdef = Math.abs(def);
					var lim = TurnAbility * rotateCoeff;
					if( absdef > lim ){
						rotVal = lim * sign;
					}else{
						rotVal = absdef * sign;
					}
				//}
				rotate();
				var nr:Number = (rotation+90) * Math.PI / 180.0;
				dx = Math.cos(nr) * speed;
				dy = Math.sin(nr) * speed;
				x += dx;
				y += dy;
				rotateCoeff *= 1.016;
				if( rotateCoeff > 4 ) rotateCoeff = 4;
				speed *= 1.04;
				if( speed >= 12 ) speed = 12;
			}
			var ax:Number = x;
			var ay:Number = y;
			if( ax < -32 || ax > _root.STAGE_WIDTH+32 ||
				ay < -32 || ay > _root.STAGE_HEIGHT ){
				die();
				return;
			}
			if( _root.doHitChk && _root.mcShip.shield > 0 ){
				if( _root.mcShip.currentFrame <=3 && _root.mcShip.ha.hitTestPoint(ax, ay, true) ) {
					die();
					_root.mcShip.hit();
				}
			}
			counter++;
		}
		
		//プレイヤーの方に向きを変える
		public function rotate():void{
			if( rotVal != 0  /*&& mcSubWapon == null */){
				//var lr:Number = rotation;
				rotation += (rotVal * rotateCoeff);
				if( Math.abs(tgDeg - rotation) < TurnAbility*rotateCoeff ) {
					rotation = tgDeg;
					rotVal = 0;
				}
				//if( (lr < 0 && rotation > 0 )||(lr > 0 && rotation < 0 ) ) rotVal *= -1;
			}
		}
		
		public function die():void{
			stat = 0;
			wait = -1;
			parent.removeChild(this);
		}
	}
}