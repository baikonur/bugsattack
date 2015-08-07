package {
	import fl.motion.Motion;
	import flash.display.*;
	import flash.events.*;
	//ラスボス専用のクラス
	public class bossUnitGama extends bossUnit {
		public var phase:Number = 0;
		public var interPhase:Number = 0;
		public var tn:Number = 0;
		private var timerID:Number;
		private var _parent:MovieClip;
		
		public var mcArm:MovieClip;
		public var mcHead:MovieClip;
		public var mcHead1:MovieClip;
		public var mcHead2:MovieClip;
		public var mcH1:MovieClip;
		public var mcH2:MovieClip;
		public var mcLeg1:MovieClip;
		public var mcLeg2:MovieClip;
		public var mcBody1:MovieClip;
		public var mcBody2:MovieClip;
		public var mcRra:MovieClip;
		public var mcLra:MovieClip;		
		
		/*
		 * イミフ
		function initTimer(){
			timerID = setInterval(cbTimer, 1000, this);
		}
		private function cbTimer(pThis){
			if( phase != interPhase ){
				//
			}
		}
		*/
		
		public override function hit1(damage:Number):Number{
			if ( muteki ) return;
			_root = root as MovieClip;
			_parent = parent as MovieClip;
			//hColor.setTransform(heatList);
			mcHilite.visible = true;
			
			hp -= damage;
			if( hansha && (acnt-lastShot) > 50 ) {
				shotX();
				lastShot = acnt;
			}
			if( hp <= 0 ) {
				_parent.stop();
				phase++;
				switch(phase){
				case 3://死
					//var d = _root.FindDepth(_root.DEPTH_FX2);
					//var pEx = _root.attachMovie("ID_EXPL", "mcBsExp" + d, d);
					var pEx = AttachMc.core.add(_root.layer_base,"ID_EXPL", "mcBsExp" + _root.serial, null);
					//var pEx = _root.attachMovie("ID_EXPL", "mcExp"+serial, _root.DEPTH_FX2+serial);
					pEx.x = x;
					pEx.y = y;
					yarare = true;
					_root.EraseEbullets();
					die();
					return 0;
				case 1:
					tn++;
		//			var myDepth = _root.serial++;
					//var haId = "ID_" + _name + "ha" + tn;
		//			theHa = _root.layerEn.attachMovie("ID_BOSS03_BODY", "mcEM"+myDepth, myDepth+_root.DEPTH_MOVEMC, {master:this, initX:x, initY:y});
					_parent.gotoAndPlay("LOOP2");
					hp = 200;//500;
					//hansha = true;
					//atkType = _root.ATKTYPE_NORMAL;
					gotoAndPlay("PHASE2");
					break;
				case 2:
					_parent.gotoAndPlay("LOOP3");
					hp = 200;// 400;
					gotoAndPlay("PHASE3");
					break;
				}
			}
			stat = 4;
			//acnt++;
			return hp;
		}
		public override function shotX():void {//散弾
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEb" + IDn, {initX:x + 8, initY:y - 41, type:0, speed:12});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEba" + IDn, {initX:x+8, initY:y-41, type:3, speed:12, dx:vx1, dy:vy1});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbb" + IDn, {initX:x+8, initY:y-41, type:3, speed:12, dx:-vx1, dy:vy1});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbc" + IDn, {initX:x+8, initY:y-41, type:3, speed:12, dx:vx2, dy:vy2});
			AttachMc.core.add(_root.layerEb, "EBULLET", "mcEbd" + IDn, {initX:x+8, initY:y-41, type:3, speed:12, dx:-vx2, dy:vy2});
		}
		public override function neraiShotPos(x:Number, y:Number):void{//狙い弾 始点x:y
			counter = 0;
			AttachMc.core.add(_root.layerEb, "BULLETRED", "mcEb"+IDn, {initX:x, initY:y, type:-1, speed:14, master:this});
		}
		public function shot3WayPos(x:Number, y:Number):void{
			counter = 0;
			var vx:Number = 0.5 * 8;
			var vy:Number = 0.866 * 8;
			AttachMc.core.add(_root.layerEb, "BULLETLONG", "mcEb", {initX:x, initY:y, type:0, speed:8});
			var p:MovieClip;
			p = AttachMc.core.add(_root.layerEb, "BULLETLONG", "mcEba", {initX:x, initY:y, type:3, speed:8, dx:vx, dy:vy});
			p.rotation = -30;
			p = AttachMc.core.add(_root.layerEb, "BULLETLONG", "mcEbb", {initX:x, initY:y, type:3, speed:8, dx:-vx, dy:vy});
			p.rotation = 30;
		}
	}
}