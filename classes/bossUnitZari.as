package {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;	
	
	//ザリガニ専用のクラス
	public class bossUnitZari extends bossUnit {
		public var phase:Number = 0;
		public var interPhase:Number = 0;
		public var tn:Number = 0;
		public var theHaR:MovieClip;
		public var theHaL:MovieClip;
		public var mcClaw:MovieClip;
		private var _parent:MovieClip;
		
		function bossUnitZari() {
		}
		
		public override function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = root as MovieClip;
			if ( _root.stageNo == 0 ) {
				stop();
				return;
			}
			_parent = parent as MovieClip;
			//ヒットエリアの生成
			var myDepth:int = _root.serial++;
			var haId:String = "BOSS03_ARM_R";
			//theHaR = _root.layerEn.attachMovie(haId, "mcEMR" + myDepth, myDepth + _root.DEPTH_MOVEMC, { master:this, initX:x, initY:y } );
			theHaR = AttachMc.core.add(_root.layerEn, haId, "mcEMR" + myDepth, { master:this, initX:x, initY:y });
			myDepth = _root.serial++;
			haId = "BOSS03_ARM_L";
			//theHaL = _root.layerEn.attachMovie(haId, "mcEML" + myDepth, myDepth + _root.DEPTH_MOVEMC, { master:this, initX:x, initY:y } );
			theHaL = AttachMc.core.add(_root.layerEn, haId, "mcEML" + myDepth, { master:this, initX:x, initY:y });
			//super.onLoad();
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
			//
			hp = 400;
			spd = 12;
			vx1 = Math.sin(15*Math.PI/180.0) * spd;
			vy1 = Math.cos(15*Math.PI/180.0) * spd;
			vx2 = Math.sin(30*Math.PI/180.0) * spd;
			vy2 = Math.cos(30*Math.PI/180.0) * spd;
			lastShot = 0;
			acnt = 0;
			muteki = true;
			moveObj = dummyFunc;
			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}

		public override function hit1(damage:Number):Number{
			if( muteki ) return;
			//transform.colorTransform = hColor;
			mcHilite.visible = true;
			
			hp -= damage;
			if( hansha && (acnt-lastShot) > 40-(phase*20) ) {//拡散弾intergap
				shotX();
				lastShot = acnt;
			}
			if( hp <= 0 ) {
				phase++;
				switch(phase){
				case 2://死
					var d:int = _root.serial;// _root.FindDepth(_root.DEPTH_FX2);
					//var pEx = _root.attachMovie("ID_EXPL", "mcBsExp"+d, d);
					//var pEx = _root.attachMovie("ID_EXPL", "mcExp"+serial, _root.DEPTH_FX2+serial);
					var pEx:MovieClip = AttachMc.core.add(_root.layer_base, "ID_EXPL", "mcBsExp"+d);
					pEx.x = x;
					pEx.y = y;
					yarare = true;
					_root.EraseEbullets();
					die();
					return 0;
				default://第2形態
					tn++;
					theHaL.die();
					theHaR.die();
					var pbm:MovieClip = AttachMc.core.add(_parent, "ID_BOMMID", "mcBsExpM1");//_parent.attachMovie("ID_BOMMID", "mcBsExpM1", 1020);
					pbm.x = 180; pbm.y = 255;
					pbm = AttachMc.core.add(_parent, "ID_BOMMID", "mcBsExpM2");//_parent.attachMovie("ID_BOMMID", "mcBsExpM2", 1021);
					pbm.x = 372; pbm.y = 257;
					var myDepth:int = _root.serial++;
					//var haId = "ID_" + _name + "ha" + tn;
					theHa = AttachMc.core.add(_root.layerEn, "BOSS_HITAREA_BODY", "mcEM"+myDepth, {master:this, initX:x, initY:y});//_root.layerEn.attachMovie("ID_BOSS03_BODY", "mcEM"+myDepth, myDepth+_root.DEPTH_MOVEMC, {master:this, initX:x, initY:y});
					_parent.gotoAndPlay("PHASE2");
					hp = 150;// 300;
					hansha = true;
					atkType = _root.ATKTYPE_NORMAL;
					nextFrame();
				}
			}
			stat = 4;
			//acnt++;
			return hp;
		}
	}
}