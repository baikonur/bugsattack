//配置用MC
package {
	import flash.display.*;
	import flash.events.*;
	
	public class enemyAdapter extends MovieClip {
		public var myDepth:Number;
		public var myName:String;
		public var movPatt:Number;
		public var instance:MovieClip;
		public var theID:String;
		public var callback:Function = null;
		public var param1:Number;
		public var param2:Number;
		public var param3:Number;
		public var param4:Number;
		public var param5:Number;
		public var param6:Number;
		public var param7:Number;
		public var mcMov:MovieClip = null;
		public var _root:MovieClip;
		
		function enemyAdapter() {
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
		}
		private function _onLoad(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			var flip = false;
			var nnname:String = name.substr(1);//名前は　"v000_00"
			var nochr:Object = nnname.split("_");// nochr[0]=動き
			//myName = nochr[0];
			_root = root as MovieClip;
			
			if ( nochr[0].charAt(1) == "m" ) {
				nochr[0] = "-" + nochr[0].substr(1);
			}
			movPatt = parseInt(nochr[0]);
			if( movPatt > 100 ) {
				movPatt -= 100;
				flip = true;
			}
			myDepth = _root.serial;//getDepth();
			_root.serial++;
				var mvv:MovieClip = null;
				if( !isNaN(movPatt) && movPatt != -1 ){
					var mvID = "MOVEMENT" + movPatt;
					try{
						mvv = AttachMc.core.add(_root.layerEn, mvID, "mcEM" + myDepth, { adapter:this } );
					}catch (e:Error) { trace("#動きID不正#"); return; }
					mvv.x = x;
					mvv.y = y;
					if( flip ){
						mvv.scaleX = -1.0;
					}
					mcMov = mvv;//動きMCインスタンス
				}			
		}
		public function setCallback(pCb:Function){//撃墜CallBack
			callback = pCb;
		}
		public function setAttr(symID:String, pCb:Function, p1:Number, p2:Number, p3:Number, p4:Number, p5:Number, p6:Number=NaN):void{//パラメータ設定
			theID = symID;
			callback = pCb;
			param1 = p1;
			param2 = p2;
			param3 = p3;
			param4 = p4;
			param5 = p5;
			param6 = p6;
			try {
				var p:MovieClip = AttachMc.core.add(_root.layerEn, theID, "mcE" + myDepth, { initX:x, initY:y, pMv:mcMov } );
			} catch (e:Error) { trace("#敵生成時例外発生# "+theID); return; }
			
			if( p != null ){//成功
				p.rotation = rotation;
				//p._xscale = _xscale;
				//p._yscale = _yscale;
				visible = false;
				instance = p;
				//p.visible = false;
				if( !isNaN(param1) ) p.setAttr(param1, param2, param3, param4, param5, param6);
				if ( callback != null ) p.callback = callback;
				p.adapter = this;
				_root.enemyManager.push(p);
				if (mcMov == null) {
					trace("#初期化されてないガイド# " + name + " frame#" + _root.currentFrame );
					stop();
				}else{
					mcMov.setAdapter(this);
				}
			}else {
				trace("#敵キャラ生成失敗# " + theID);
			}
		}
	}
}