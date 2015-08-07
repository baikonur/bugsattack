package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	
	public class bossUnit extends enemy {
		public var vx1:Number;
		public var vy1:Number;
		public var vx2:Number;
		public var vy2:Number;
		public var spd:Number;
		public var lastShot:Number;
		public var acnt:Number;
		public var muteki:Boolean;
		public var theHa:MovieClip;
		public var mcHilite:MovieClip;
		public var hansha:Boolean = false;
		public function dummyFunc(){}
		//public override function rotate(){}
		
		function bossUnit() {
			noRotate = true;
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);			
		}
		
		public override function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			if ( _root.stageNo == 0 ) {
				stop();
				return;
			}			
			//ヒットエリアの生成
			var myDepth:int = _root.serial++;
			var haId:String = name + "_ha";
			//theHa = _root.layerEn.attachMovie(haId, "mcEM"+myDepth, myDepth+_root.DEPTH_MOVEMC, {master:this, initX:x, initY:y});
			theHa = AttachMc.core.add(_root.layerEn, haId,  "mcEM" + myDepth, { master:this, initX:x, initY:y } );
			if ( theHa == null ) {
				trace("まさかの失敗 " + haId);
			}
			//
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
				}
			}
			//
			hp = 1;
			spd = 12;
			vx1 = Math.sin(15.0*Math.PI/180.0) * spd;
			vy1 = Math.cos(15.0*Math.PI/180.0) * spd;
			vx2 = Math.sin(30.0*Math.PI/180.0) * spd;
			vy2 = Math.cos(30.0*Math.PI/180.0) * spd;
			lastShot = 0;
			acnt = 0;
			muteki = true;
			moveObj = dummyFunc;
			/*
			heatList.rb = 64;
			heatList.gb = 64;
			heatList.bb = 64;
			*/
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		public override function _onUnload(e:Event):void {
			parent.stop();
			removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}		
		public override function _onEnterFrame(e:Event):void{
			//enemyからコピペ---------------------------------------------------
			if( wait > 0 ) {
				if( pMv != null ) pMv.stop();
				wait--;
				if( wait == 0 ) pMv.play();
				return;
			}
			//moveObj.call(this);
			switch( stat ) {
			case 0: return; break;
			case 2: 
				//transform.colorTransform = normalList;
				mcHilite.visible = false;
				stat = 1;
				//break;
			default://ハイライト中
				if( stat > 2 ) stat--;
			case 1: 
				break;
			}
			counter++;
			acnt++;
			attack();
			//---------------------------------------------------------------------
		}
		
		public function hit1(damage:Number):Number{
			if ( muteki ) return;
			if ( stat == 0 ) return hp;
			//transform.colorTransform = hColor;
			mcHilite.visible = true;
			
			if ( hp <= 0 ) return 0;
			hp -= damage;
			if( hansha && (acnt-lastShot) > 30 ) {
				shotX();
				lastShot = acnt;
			}
			if( hp <= 0 ) {
				//var d:int = _root.FindDepth(_root.DEPTH_FX2);
				//var pEx = _root.attachMovie("ID_EXPL", "mcBsExp"+d, d);
				//var pEx = _root.attachMovie("ID_EXPL", "mcExp"+serial, _root.DEPTH_FX2+serial);
				var pEx:MovieClip = AttachMc.core.add(_root.layer_base, "ID_EXPL", "mcExp" + serial);
				pEx.x = x;
				pEx.y = y;
				yarare = true;
				_root.EraseEbullets();
				die();
				return 0;
			}
			stat = 4;
			//acnt++;
			return hp;
		}
		//破壊された
		public override function die():void {
			stop();
			_root.mcShip.setStat(0);//Myシップ無敵
			theHa.die();
			//onEnterFrame = null;
			//transform.colorTransform = normalList;
			mcHilite.visible = true;
			if ( _root.mcShip.shield > 0 ) gotoAndPlay("BOSS_DEAD");
			stat = 0;
		}
		
		public function shotX():void {//散弾
			/*
			_root.layerEb.attachMovie("ID_EBULLET1", "mcEb"+IDn, _root.missileNo++, {initX:x, initY:y+32, type:0, speed:spd});
			_root.layerEb.attachMovie("ID_EBULLET1", "mcEba"+IDn, _root.missileNo++, {initX:x, initY:y+32, type:3, speed:12, dx:vx1, dy:vy1});
			_root.layerEb.attachMovie("ID_EBULLET1", "mcEbb"+IDn, _root.missileNo++, {initX:x, initY:y+32, type:3, speed:12, dx:-vx1, dy:vy1});
			_root.layerEb.attachMovie("ID_EBULLET1", "mcEbc"+IDn, _root.missileNo++, {initX:x, initY:y+32, type:3, speed:12, dx:vx2, dy:vy2});
			_root.layerEb.attachMovie("ID_EBULLET1", "mcEbd" + IDn, _root.missileNo++, { initX:x, initY:y + 32, type:3, speed:12, dx: -vx2, dy:vy2 } );
			*/
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEb"  + IDn,{initX:x, initY:y+32, type:0, speed:spd});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEba" + IDn,{initX:x, initY:y+32, type:3, speed:12, dx:vx1, dy:vy1});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbb" + IDn,{initX:x, initY:y+32, type:3, speed:12, dx:-vx1, dy:vy1});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbc" + IDn,{initX:x, initY:y+32, type:3, speed:12, dx:vx2, dy:vy2});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbd" + IDn,{initX:x, initY:y+32, type:3, speed:12, dx: -vx2, dy:vy2});
		}
		
		public override function neraiShot1():void{//狙い弾１
				counter = 0;
				//_root.layerEb.attachMovie("ID_BOSSBL_RED", "mcEb"+IDn, _root.missileNo++, {initX:x, initY:y, type:-1, speed:12});
				AttachMc.core.add(_root.layerEb, "BULLETRED", "mcEb"+IDn, {initX:x, initY:y, type:-1, speed:12});
				atkCount++;
		}
	}
}
