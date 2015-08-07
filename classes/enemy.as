package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;	
	
	//敵キャラ基本クラス
	public class enemy extends MovieClip {
		public var dx:Number;
		public var dy:Number;
		public var initX:Number = -1;
		public var initY:Number = -1;
		public var ha:MovieClip;
		public var hp:Number;
		public var stat:Number = 0;
		public var wait:Number = 0;
		public var atkType:int = 0;
		public var aTicker:Number = 58;
		public var mcSubWapon:MovieClip = null;
		public var counter:Number = 0;
		public var IDn:Number;
		public var hColor:ColorTransform;
		public var normalList:ColorTransform;
		public var callback:Function;
		public var atkCount:int;//攻撃回数のカウント
		public var atkLim:Number;
		public var pMv:MovieClip = null;
		public var temp:Number;
		public var rotateCoeff:Number = 1.0;
		public var bulletSpeed:Number;
		public var moveObj:Object;
		public var serial:Number;
		public var yarare:Boolean; //CallBackに渡すフラグ   trueのとき打ち落とされた
		public var bomScale:Number = 70;//爆発の大きさ (%)
		public var points:Number;//得点
		public var myDepth:Number;
		public var noRotate:Boolean = false;
		public var prepareDie:Function = null;
		public var moveGuide:stand = null;
		
		function enemy(){
			dx = 0;
			dy = 8;
			hp = 1;
			temp = atkType = 2;
			counter = 0;
			wait = 0;
			mcSubWapon = null;
			aTicker = 58;
			callback = null;
			rotVal = 0;
			atkLim = 0;
			atkCount = 0;
			bulletSpeed = 8;
			moveObj = moveObjN;
			//onMouseMove = null;
			yarare = false;
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		} 
		
		public var _root:MovieClip;
		public function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			if ( _root.stageNo == 0 ) {
				stop();
				return;
			}			
			//ha.visible = false;
			if( initX != -1 ){
				x = initX;
				y = initY;
			}
			hColor = new ColorTransform();
			hColor.redMultiplier = 1;
			hColor.blueMultiplier = 1;
			hColor.greenMultiplier = 1;
			hColor.alphaMultiplier = 1;
			hColor.redOffset = 164;
			hColor.greenOffset = 164;
			hColor.blueOffset = 164;
			hColor.alphaOffset = 0;
			normalList = new ColorTransform(1,1,1,1,0,0,0,0);
			IDn = parent.getChildIndex(this);
			stat = 1;
			rotateCoeff = 1.0;
			if( pMv != null ){
				if( pMv.scaleX == -1.0 ){
					moveObj = moveObjF;
					initX = _root.STAGE_WIDTH - initX;
				}
			}
			if( wait == 0 ) visible = true;
			else visible = false;
			myDepth = parent.getChildIndex(this);
		}
		public function _onUnload(e:Event):void {
			stop();
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		//耐久力　攻撃タイプ　攻撃間隔　攻撃回数　初期ディレイ 初期攻撃count
		public function setAttr(hitpts:Number, attackPtrn:Number, attackInt:Number, attackLim:Number, waitTick:Number, firstCnt:Number):void {
			hp = hitpts;
			temp = atkType = attackPtrn;
			aTicker = attackInt;
			wait = waitTick;
			atkLim = int(attackLim * 1.5);
			if( !isNaN(firstCnt) ) counter = firstCnt;
			if( wait == 0 || isNaN(wait) ) visible = true;
			else visible = false;
			//else visible = false;
			//trace("SETATTR "+wait);
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}

		private var maeTg:int = 0;
		private var rotVal:Number;
		private var tgDeg:Number;
		private var sign:int;
		public function _onEnterFrame(e:Event):void {
			if ( _root.playStatus == 1 ) return;
			if( wait > 0 ) {
				if( pMv != null ) pMv.stop();
				wait--;
				if ( wait == 0 ) { 
					visible = true;
					if( pMv != null ) pMv.play();
				}
				return;
			}
			moveObj.call(this);
			switch( stat ){
			case 2: 
				transform.colorTransform = normalList;
				stat = 1;
				//break;
			default://ハイライト中
				if( stat > 2 ) stat--;
			// case 1:
				if ( !noRotate ) {
					if( counter % 29 == 0 ){
						var rad:Number = _root.GetRadian( x, y, _root.mcShip.x, _root.mcShip.y );
						var deg:Number = (rad * 180.0 / Math.PI);
						if( deg > 180 ) deg = -(360-deg);
						tgDeg = deg;
						var def:Number = deg - rotation;
						if( def > 180 ) def = 360 - def;
						if( def < -180 ) def = -360 - def;
						sign = 1;
						var absdef:Number = def;
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
						var lim:Number = 5 * rotateCoeff;
						if( absdef > lim ){
							rotVal = lim * sign;
						}else{
							rotVal = absdef * sign;
						}
					}
					rotate();
				}
				
			}
			counter++;
			attack();
		}
		
		public function moveObjN():void {//通常
			if ( pMv != null ) {
				try{
					x = pMv.mcCore.x + initX;
					y = pMv.mcCore.y + initY;
				}catch (e:Error) {
					trace("例外 " + pMv.adapter.name);
				}
			}else{
				if( y < 64 ) y += 8;
				if( x < 32 ) x += 6;
				else if( x > _root.STAGE_WIDTH-32 ) x -= 6;
			}
		}
		
		public function moveObjF():void {//鏡面動作
			if( pMv != null ){
				x = _root.STAGE_WIDTH-(pMv.mcCore.x) - initX;
				y = pMv.mcCore.y + initY;
			}else{
				if( y < 64 ) y += 8;
				if( x < 32 ){
					x += 6;
				}else if( x > _root.STAGE_WIDTH-32 ) {
					x -= 6;
				}
			}
		}
		
		public function bind(sw:Boolean):void {
			if( sw ) pMv.stop();
			else pMv.play();
		}
		
		//プレイヤーの方に向きを変える
		public function rotate():void {
			if ( noRotate ) return;
			if( rotVal != 0  /*&& mcSubWapon == null */){
				var lr:Number = rotation;
				rotation += (rotVal * rotateCoeff);
				if( Math.abs(tgDeg - rotation) < 5*rotateCoeff ) {
					rotation = tgDeg;
					rotVal = 0;
				}
				if( mcSubWapon != null ) mcSubWapon.rotation = rotation;
				//if( (lr < 0 && rotation > 0 )||(lr > 0 && rotation < 0 ) ) rotVal *= -1;
			}
		}

		public function neraiShot1():void {//狙い弾１
			if( y < 500 ){
				counter = 0;
				var peb:MovieClip = AttachMc.core.add(_root.layerEb, "EBULLET", "mcEb" + IDn, { initX:x, initY:y, type: -1, speed:12, master:this });
				atkCount++;
			}
		}
		public function neraiShot2():void {//狙い弾2
			counter = 0;
			var peb:MovieClip = AttachMc.core.add(_root.layerEb, "EBULLET", "mcEb" + IDn, { initX:x, initY:y, type: -1, speed:8, master:this });
			atkCount++;
		}
		public function neraiShotPos(x:Number, y:Number):void {//狙い弾 始点x:y
			counter = 0;
			var peb:MovieClip = AttachMc.core.add(_root.layerEb, "EBULLET", "mcEb" + IDn, { initX:x, initY:y, type: -1, speed:12, master:this });
		}
		public function twoWayShot():void {//２WAYななめ
			var vx:Number = Math.sin(15.0*Math.PI/180.0) * 8;
			var vy:Number = Math.cos(15.0*Math.PI/180.0) * 8;
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEba" + IDn, { initX:x, initY:y, type:3, speed:8, dx:vx, dy:vy } );
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbb" + IDn, { initX:x, initY:y, type:3, speed:8, dx: -vx, dy:vy } );
		}
		public function shot3Way():void {
			counter = 0;
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEb"+IDn, {initX:x, initY:y, type:0, speed:8});
			twoWayShot();
			atkCount++;
		}
		public function shot8Way():void {
			var bs:Number = bulletSpeed;
			counter = 0;
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEb"+IDn, {initX:x, initY:y, type:0, speed:bs});
			var vx:Number = /*Math.sin(45*Math.PI/180)*/0.71 * bs;
			var vy:Number = /*Math.cos(45*Math.PI/180)*/0.71 * bs;
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEba"+IDn, {initX:x, initY:y, type:3, speed:bs, dx:vx, dy:vy});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbb"+IDn, {initX:x, initY:y, type:3, speed:bs, dx:-vx, dy:vy});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbc"+IDn, {initX:x, initY:y, type:3, speed:bs, dx:-vx, dy:-vy});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbd"+IDn, {initX:x, initY:y, type:3, speed:bs, dx:vx, dy:-vy});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbe"+IDn, {initX:x, initY:y, type:3, speed:bs, dx:0, dy:-bs});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbf"+IDn, {initX:x, initY:y, type:3, speed:bs, dx:-bs, dy:0});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbg"+IDn, {initX:x, initY:y, type:3, speed:bs, dx:bs, dy:0 } );
			atkCount++;
		}
		public function shot8WayHi():void {
			var bk:Number = bulletSpeed;
			bulletSpeed = 10;
			shot8Way();
			bulletSpeed = bk;
		}
		public function shotVxVy(vx:Number, vy:Number, rot:Number = 0):void {//指定
			var pMc:MovieClip = AttachMc.core.add(_root.layerEb, "BULLETLONG", "mcEba" + IDn, { initX:x, initY:y, type:3, dx:vx, dy:vy });
			if( !isNaN(rot) ) pMc.rotation = rot;
		}
		public function homingM(id:String, x:Number, y:Number):void {
			counter = 0;
			var peb:MovieClip = AttachMc.core.add(_root.layerEb, id, "mcEb" + IDn, { initX:x, initY:y, type:1, speed:8 });
			var vx:Number = Math.sin(rotation*Math.PI/180.0) * 8;
			var vy:Number = Math.cos(rotation*Math.PI/180.0) * 8;
			peb.x += vx;
			peb.y += vy;
			peb.rotation = rotation;
			atkCount++;
		}
		public function shotHanyo(id:String, x:Number, y:Number):void {
		//	var d:Number = DEPTH_ITEM + missileNo;
		//	while( getInstanceAtDepth() != undefined ) d++;
			var peb:MovieClip = AttachMc.core.add(_root.layerEb, id, "mchb" + _root.missileNo++, { initX:x, initY:y });
		}

		public function attack():void {
			var aLife:int;
			switch(atkType){
			case 1://狙い弾
				if( counter == aTicker ){
					neraiShot1();
				}
				break;
			case 2://レーザー
				aLife = 38;
				if( counter >= aLife+aTicker ) {
					if( mcSubWapon == null ){
						counter = 0;
						mcSubWapon = AttachMc.core.add(_root.layerEn, "laser", "mcLaser" + IDn, { initX:x, initY:y, life:aLife, master:this } );
						mcSubWapon.rotation = rotation;
						//wait = aLife;
						atkCount++;
						rotateCoeff = 0.3;
					}
				}
				break;
			case 10://V Laser
				aLife = 60;
				if( counter >= aLife + aTicker ) {
					if( mcSubWapon == null ){
						counter = 0;
						mcSubWapon = AttachMc.core.add(this, "laser", "mcLaser" + IDn, { initX:0, initY:0, life:aLife, master:this });
						mcSubWapon.rotation = rotation;
						atkCount++;
					}
				}
				break;
			case 3:
				if( counter == aTicker ){
					counter = 0;
					var peb:MovieClip = AttachMc.core.add(_root.layerEb, "rocket", "mcEb" + IDn, { initX:x, initY:y, type:1, speed:3, coeff:1.07 });
					atkCount++;
				}
				break;
			case 9: //
				if( counter == aTicker ){
					shot3Way();
				}
				break;
			case 4://ホーミング弾
				if( counter == aTicker ){
					homingM("HOMINGU",x, y);
				}
				break;
			case 6: //チビ敵
				if( counter == aTicker ){
					counter = 0;
					AttachMc.core.add(_root.layerEb, "tornado", "mcEb" + IDn, { initX:x, initY:y, master:this });
					atkCount++;
				}
				break;
			case 8: //８方向弾
				if( counter == aTicker ){
					shot8Way();
				}
				break;
			case 0:return; break;
			}
			if( atkCount == atkLim ){
				atkType = 0;
			}
		}
		
		public function hit(damage:Number):Number {
			if ( stat > 0 && hp > 0 ) {
				transform.colorTransform = hColor;
				hp -= damage;
				if( hp <= 0 ) {
					var pEx:MovieClip = AttachMc.core.add(_root.layerEn, "ID_EXPL", "mcExp" + myDepth);
					pEx.scaleX = bomScale / 100;
					pEx.scaleY = bomScale / 100;
					pEx.x = x;
					pEx.y = y;
					yarare = true;
					_root.AddScore(points);
					die();
				}
				stat = 4;
			}
			return hp;
		}
		
		public function die():void {
			stop();
			if( prepareDie != null ) prepareDie(yarare);
			stat = 0;
			if( callback != null ) callback.call(_root, this, yarare);
			if( mcSubWapon != null ) mcSubWapon.die();
			_root.enemyManager.remove(this);
			if ( moveGuide != null ) moveGuide.stop();//ガイド停止
			if ( pMv != null ) { pMv.parent.removeChild(pMv); }
			parent.removeChild(this);
			//_root.dispatchEvent(new Event(_root.EVENT_KILLME));
		}
		//public function prepareDie():void {} //オーバーライド推奨
		
		public function attackEnable(sw:Boolean):void {
			if( sw ){
				atkType = temp;
				counter = 0;
			}else{
				atkType = 0;
			}
		}
		
		public function subWaponNotify( evt:Number, param:Number ):void {
			if( evt == 0 ){
				mcSubWapon = null;
				rotateCoeff = 1.0;
			}
		}
		
		public function pause(sw:Boolean):void {
			if ( sw ) {
				if ( moveGuide != null ) moveGuide.stop();
			}else {
				if ( moveGuide != null ) moveGuide.play();
			}
		}
		
		public function stopEnterFrame():void {
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
	}
}