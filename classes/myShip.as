//マイシップ
package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.getTimer;
	
	public class myShip extends MovieClip {
		public var mcCore:MovieClip;
		
		public var fireFlg:Number;
		private var count:int;
		public var numBullet:Number;
		public var stat:Number;
		public var oldX:Number;
		public var oldY:Number;
		public var shield:int;
		public var LimBullets:Number = 10;
		public var Speed:Number = 16;
		public var BULLET_SPEED:int = 20;
		public var fireFunc:Object;
		public var armLevel:Number; // 1 -> 2 -> 3
		public var lastClcTm:Number;
		public var suppeArm:MovieClip;
		public var ha:MovieClip;
		public var BID:String;
		public var masterClock:int;
		public var startTime:Number;
		public var fpsRate:Number;
		public var pauseFlag:Boolean = false;
		
		function myShip(){
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			fireFlg = 0;
			count = 0;
			numBullet = 0;
			stat = -1;
			fireFunc = fire1;
			armLevel = 1;
			lastClcTm = 0;
			suppeArm = null;
			BID = "";
			masterClock = 0;
		}
		
		public var _root:MovieClip;
		private function _onLoad(e:Event):void {
			_root = root as MovieClip;
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			if( _root.stageNo > 0 ){
				addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			//	addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
				addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
				ha.alpha = 0;
			}
			shield = _root.initialLife;
			x = _root.STAGE_WIDTH / 2;
			y = 500;
			oldX = x;
			oldY = y;
		}
		private function _onUnload(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		//	removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}		

			
		//ステージ開始
		public function setStage(stageNo:int):void{
			BID = "MYBULL_" + stageNo;
			masterClock = 0;
			startTime = getTimer();
			stat = 1;
		}
		//経過時間とからFPSレートを算出
		public function getTimeResult():Number{
			var tm:Number = getTimer() - startTime;
			fpsRate = masterClock * 1000/29 / tm;
			_root.fpsRate = fpsRate;
			trace(masterClock +"  " +fpsRate+"%");
			return tm;
		}
		//停止
		public function freeze(sw:Boolean):void{
			if( sw ) stat = -1;
			else stat = 1;
		}
		
		private function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			masterClock++;
			if ( stat < 0 ) return;
			var rr:Number = _root.NEW_SIZE_RATIO;
			_root.doHitChk = false;
			var ax:Number = _root.mouseX;
			var ay:Number = _root.mouseY - 88;
			if ( ax > 0 && ay > 0 && ax < _root.STAGE_WIDTH && ay < _root.STAGE_HEIGHT) {
				var defx:Number = ax - oldX;
				var defy:Number = ay - oldY;
				var sx:int = 1, sy:int = 1;
				if( defx < 0 ) sx = -1;
				if( defy < 0 ) sy = -1;
				if( defx * sx > Speed ){
					ax = oldX + (Speed * sx);
					if( stat > 0 ){
						if ( defx > 0 ) {
							gotoAndStop("R");
						}else {
							gotoAndStop("L");
						}
					}
				}else{
					if( stat > 0 ) {
						gotoAndStop("N");
					}
				}
				if( defy * sy > Speed ) ay = oldY + (Speed * sy);
				if( ax < 16*rr ){
					ax = 16*rr;
				}else if( ax > (_root.STAGE_WIDTH-16)*rr ){
					ax = (_root.STAGE_WIDTH-16)*rr;
				}
				if( ay < 16*rr ){
					ay = 16*rr;
				}else if( ay > (600-16)*rr ){
					ay = (600-16)*rr;
				}
				x = ax;
				y = ay;
			}else{
				ax = oldX;
				ay = oldY;
				if( stat > 0 ){ gotoAndStop("N"); }
			}
			oldX = ax;
			oldY = ay;
			if( fireFlg &&(count % 3)==0 ){
				if( numBullet >= LimBullets ){
					//numBullet = 0;
				}else{
					fireFunc.call(this)
				}
			}
			count++;
			if( count > 999 ) count = 0;
			if( stat > 0 ){
				var bx:Number = x;
				var by:Number = y;
				var lEb:MovieClip = _root.layerEb;
				if( lEb.hitTestPoint(bx, by-15*rr, true ) ||
					lEb.hitTestPoint(bx, by-7*rr, true ) ||
					lEb.hitTestPoint(bx, by+1*rr, true ) ||
					lEb.hitTestPoint(bx, by+13*rr, true ) ||
					
					lEb.hitTestPoint(bx+11, by-15*0.87, true ) ||
					lEb.hitTestPoint(bx+11, by-2*0.87, true ) ||
					lEb.hitTestPoint(bx+11, by+11*0.87, true ) ||
					
					lEb.hitTestPoint(bx-11, by-15*rr, true ) ||
					lEb.hitTestPoint(bx-11, by-2*0.87, true ) ||
					lEb.hitTestPoint(bx-11, by+11*rr, true ) ){
					_root.doHitChk = true;
				}
				if( /*count & 1*/count % 4 == 0 ){
					if( _root.layerEn.hitTestPoint( bx, by, true ) ){//敵に当たった
						//var dep = _root.getNextHighestDepth();
						//var pEx = _root.attachMovie("ID_EXPL", "mcMyExp", dep);
						//pEx.x = x;
						//pEx.y = y;
						hit();
					}
				}
			}
		}
		public function bulletOff():void{
			numBullet--;
		}
		public function hit():void{
			if( stat == 1 && shield > 0 ){
				_root.sfx_miss.start();
				shield--;
				_root.mcPanel["hp"+shield].visible = false;
				if( shield == 0 ){
					if( suppeArm != null ) specialArmEnd();
					stat = -1;
					fireFlg = 0;
					ha.visible = false;
					_root.GameOver();//ゲームオーバー
					gotoAndPlay("DIE");
				}
				stat = 0;
				gotoAndPlay("HIT");
			}
		}
		public function setFire():void {
			if( fireFlg == 0 ){
				if( stat == 1 ) fireFlg = 1;
			}else{
				fireFlg = 0;
			}
		}
		public function doubleClick():void{
		//	if( stat == 1 ) fireFlg = 1;
		//	var nt = getTimer();
			if(stat == 1){//ダブルクリック
				specialArm();
//pauseFlag = _root.gamePause(!pauseFlag);
			}
		}
		private function _onMouseUp(me:MouseEvent):void{
			/*
			if( stat == 1 ) {
				fireFlg ^= 1;
			}
			*/
			//fireFlg = 0;
		//	if( stat == 1 ){
		//		fireFlg ^= 1;
		//	}
		}
		public function specialArm():void{
			if( suppeArm == null && shield > 0 ){
				suppeArm = _root.InvokeSpecialArm();
				_root.sfx_beam.start(0, 255);
			}
		}
		public function specialArmEnd(pArm:MovieClip):void{
			_root.sfx_beam.stop();
			removeChild(pArm);
			suppeArm = null;
		}
		public function fire():void{
			var id:String = BID;
			var ax:Number = x;
			var ay:Number = y - 16;
	//		_root.layerB.attachMovie("ID_BULLET", "mcBl1"+count, 6000+count, {initX:x-5, initY:y-12, dy:18});
	//		numBullet++;

			//_root.layerB.attachMovie(id, "mcBl1" + count, 6000 + count, { initX:x - 10, initY:y - 6, dy:20 } );
			AttachMc.core.add(_root.layerB, id, "mcBl1" + count, { initX:ax - 10, initY:ay - 6, dy:BULLET_SPEED } );
			numBullet++;
			//_root.layerB.attachMovie(id, "mcBl2" + count, 7000 + count, { initX:x + 10, initY:y - 6, dy:20 } );
			AttachMc.core.add(_root.layerB, id, "mcBl2" + count, { initX:ax + 10, initY:ay - 6, dy:BULLET_SPEED } );
			numBullet++;
	/*
			_root.layerB.attachMovie("ID_BULLET", "mcBl1"+count, 6000+count, {initX:x-5, initY:y-12, dy:18});
			numBullet++;
			_root.layerB.attachMovie("ID_BULLET", "mcBl2"+count, 7000+count, {initX:x-5, initY:y-12, dx:4, dy:18});
			numBullet++;
			_root.layerB.attachMovie("ID_BULLET", "mcBl2"+count, 8000+count, {initX:x-5, initY:y-12, dx:-4, dy:18});
			numBullet++;
	*/
		}
		public function fire1():void{
			var id:String = BID;
			var ax:Number = x;
			var ay:Number = y - 16;
			//_root.layerB.attachMovie(id, "mcBl1" + count, 6000 + count, { initX:x - 5, initY:y - 16, dy:18 } );
			AttachMc.core.add(_root.layerB, id, "mcBl1" + count, { initX:ax - 5, initY:ay - 16, dy:18 } );
			numBullet++;
		}
		public function fire2():void{
			var id:String = BID;
			var ax:Number = x;
			var ay:Number = y - 16;
			//_root.layerB.attachMovie(id, "mcBl1" + count, 6000 + count, { initX:x - 15, initY:y - 16, dy:20 } );
			AttachMc.core.add(_root.layerB, id, "mcBl1" + count, { initX:ax - 15, initY:ay - 16, dy:20 } );
			//_root.layerB.attachMovie(id, "mcBl2" + count, 7000 + count, { initX:x + 5, initY:y - 16, dy:20 } );
			AttachMc.core.add(_root.layerB, id, "mcBl2" + count, { initX:ax + 5, initY:ay - 16, dy:20 } );
			numBullet+=2;
		}
		public function fire3():void{
			var id:String = BID;
			var ax:Number = x;
			var ay:Number = y - 16;
			//_root.layerB.attachMovie(id, "mcBl2" + count, 7000 + count, { initX:x - 5, initY:y - 16, dx:4, dy:18 } );
			AttachMc.core.add(_root.layerB, id, "mcBl2" + count, { initX:ax - 5, initY:ay - 16, dx:4, dy:18 } );
			//_root.layerB.attachMovie(id, "mcBl2" + count, 6000 + count, { initX:x - 5, initY:y - 16, dx: -4, dy:18 } );
			AttachMc.core.add(_root.layerB, id, "mcBl2" + count, { initX:ax - 5, initY:ay - 16, dx: -4, dy:18 } );
			//_root.layerB.attachMovie(id, "mcBl1" + count, 8000 + count, { initX:x - 5, initY:y - 16, dy:18/*, power:2*/} );
			AttachMc.core.add(_root.layerB, id, "mcBl1" + count, { initX:ax - 5, initY:ay - 16, dy:18} );
			numBullet+=3;
		}
		public function powerUp():void{
			armLevel++;
			if( armLevel > 3 ) armLevel = 3;
			switch(armLevel){
			case 1: fireFunc = fire1; LimBullets = 10; break;
			case 2: fireFunc = fire2; LimBullets = 20; break;
			case 3: fireFunc = fire3; LimBullets = 30; break;
			}
		}
		public function heal():void{
			if( shield < 5 ){
				shield++;
			}else{
				_root.AddScore(5000);
			}
			for( var i:int = 0; i < 5; i++ ){
				if( i+1 <= shield ){
					_root.mcPanel["hp"+i].visible = true;
				}else{
					_root.mcPanel["hp"+i].visible = false;
				}
			}

			//_root["hp"+shield].visible = true;
		}
		public function clearHeal():void{
			if( shield <= 2 ) heal();
		}
		
		public function setStat(n):void{
			stat = n;
		}
	}
}