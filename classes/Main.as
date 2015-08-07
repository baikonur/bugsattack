package 
{
	import fl.motion.Motion;
	import flash.display.*;
	import flash.events.*;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.utils.getTimer;
	import flash.desktop.NativeApplication;
	import flash.net.SharedObject;
	import com.flashdynamix.utils.*;
	
	public class Main extends MovieClip 
	{
		public var _root:MovieClip;
		public const DEPTH_PANEL:int = 40000;
		public const DEPTH_MSG:int = 30000;
		public const DEPTH_ITEM:int = 11000;
		public const DEPTH_SNDFX:int = 79268;
		public const DEPTH_PLAYER:int = 4900;
		public const DEPTH_MOVEMC:int = 5000;
		public const DEPTH_FX1:int = 6000;
		public const DEPTH_FX2:int = 9000;
		public const DEPTH_FX3:int = 10000;
		public const DEPTH_SMOKE:int = 15000;
		public const DEPTH_TOPWIPE:int = 99999;
		public const DEPTH_AD:int = 240000;
		public const STAGE_MIN_X:int = 0;
		public const STAGE_MIN_Y:int = 0;
		public const STAGE_HEIGHT:int = 600;
		public const STAGE_WIDTH:int = 480;
		public const ATKTYPE_NORMAL:int = 1;//狙い弾
		public const ATKTYPE_LASER:int = 2;
		public const ATKTYPE_MISSILE:int = 3;
		public const ATKTYPE_8WAY:int = 8;
		public const ATKTYPE_HOMING:int = 4;
		public const ATKTYPE_CHIBI:int = 6;
		public const ATKTYPE_3WAY:int = 9;
		public const ATKTYPE_VLASER:int = 10; //垂直レーザー
		public const NEW_SIZE_RATIO:Number = 1.0;
				
		public var masterVol:Number = 100;
		public var sfx_pup:SoundFx = null;
		public var sfx_52:SoundFx = null;
		public var sfx_miss:SoundFx = null;
		public var sfx_missile:SoundFx = null;
		public var bgm_01:SoundFx = null;
		public var bgm_02:SoundFx = null; 
		public var bgm_B01:SoundFx = null; 
		public var sfx_beam:SoundFx = null; 
		public var sfx_pom:SoundFx = null;
		public var sfx_swing:SoundFx = null;
		public var sfx_rocket:SoundFx = null;
		public var sfx_warn:SoundFx = null;
		public var sfx_bang:SoundFx = null;
		public var sfx_keen:SoundFx = null;
		public var sfxGun:SoundFx = null;
		private var lastSoundOn:Boolean = true;
		
		public var HENTAI_LIM:int = 0;
		public var LIM:int = 0;
		public var mcShip:MovieClip;
		public var mcMyship:MovieClip;
		public var serialNo:int = 0;
		public var missileNo:int = 0;
		public var enemyManager:eManager = new eManager();
		public var serial:int = 0;
		public var ebFxSerial:Number = 0; //ケムリなどのエフェクト番号
		public var doHitChk:Boolean = false; //敵弾の当たり弾確定チェック発動フラグ
		public var startTime:Number;
		public var getEnm:int = 0;
		public var hentai:int = 0;
		public var doScroll:Boolean = false;
		public var laserSoundOn:Boolean = false;//レーザー音エイリアス対策
		public var specialLeft:int = 3;
		public var bonusStar:int = 0;
		public var stageNo:int = 0;//0=準備中
		public var theScore:int = 0;
		public var highScore:int;
		public var totalTimeResult:Number  = 0;//総プレイタイム（秒）
		public var initialLife:int = 5;
		public var finalResult_life:int = 5;
		public var finalResult_beam:int = 3;
		public var fpsRate:Number = 1.0;
		public var kdLast:Number = getTimer();
		public var rapidFireFlag:int = -1;
		public var bgmHandle:SoundFx = null;
		
		public var layer_base:MovieClip = null;
		public var layerEn:MovieClip = null;
		public var layerB:MovieClip = null;
		public var layerEb:MovieClip = null;
		public var mcLoader:MovieClip;
		public var mcLayer1:MovieClip;
		public var mcPanel:MovieClip;
		public var mcPanelR:MovieClip;
		public var mcPanelL:MovieClip;
		public var mcClearStage:MovieClip = null;
		public var mcStartCaption:MovieClip;
		public var mcGameOver:MovieClip;
		public var mcWipe:MovieClip;
		public var mcWarndlg:MovieClip;
		public var pw:MovieClip;
		public var mcIntroBoss:MovieClip;
		
		public var playStatus:int = 0;// 0:通常 1:停止
		public var soundOn:Boolean = true;
		public var todayHighscore:int = 0;
		public var todayName:String = "";
		public var param_BGscroll:Boolean = true;
		public var todayScore:int = 0;
		public var startStage:int = 1;
		//Stage
		public var mcBg1:MovieClip;
		public var mcBgp1:MovieClip;
		/*
		public var mcBg2:MovieClip;
		public var mcBgp2:MovieClip;
		public var mcBg3:MovieClip;
		public var mcBgp3:MovieClip;
		public var mcBg4:MovieClip;
		public var mcBgp4:MovieClip;
		*/
		/*
		var todayName = "";
		var todayScore = 0;
		*/
		
		function Main() {
			addEventListener(Event.ADDED_TO_STAGE, _onLoad);
			addEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
			AttachMc.create();
		}
		
		private function _onLoad(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onLoad);
			_root = this;
			stage.addEventListener( Event.ACTIVATE , _onActivateHandler );
			stage.addEventListener( Event.DEACTIVATE , _onDeactivateHandler );
			//SWFProfiler.init(stage, this);
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
				
		private function _onActivateHandler( e:Event ):void {
			if ( lastSoundOn ) {
				SoundSwitch();
			}
		}
		private function _onDeactivateHandler( e:Event ):void {
			lastSoundOn = soundOn;
			//if ( lastSoundOn ) {
				soundOn = true;
				SoundSwitch();
			//}
		}
		
		private function _onUnload(e:Event):void {
		//	removeEventListener(Event.REMOVED_FROM_STAGE, _onUnload);
		//	removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		public function exitApp():void {
			try{
				NativeApplication.nativeApplication.exit();//アプリの終了
			}catch(e:Error){}
		}
		
		public var lastClcTm:Number = 0;
		private function _onMouseDown(me:MouseEvent):void {
			var nt:Number = getTimer();
			if(nt-lastClcTm < 200){//ダブルクリック
				if ( stageNo > 0 ) mcShip.doubleClick();
			}
			lastClcTm = nt;
		}
		//スコアに加算し表示
		public function AddScore(aval:Number):void{
			theScore += aval;
			var val:Number = theScore;
			var i:int = Math.floor( val / 1000000 );
			val -= i * 1000000;
			var h:int = Math.floor( val / 100000 );
			val -= h * 100000;
			var g:int = Math.floor( val / 10000 );
			val -= g * 10000;
			var f:int = Math.floor( val / 1000 );
			val -= f * 1000;
			var e:int = Math.floor( val / 100 );
			val -= e * 100;
			mcPanel.nume.gotoAndStop(e+1);
			mcPanel.numf.gotoAndStop(f+1);
			mcPanel.numg.gotoAndStop(g+1);
			mcPanel.numh.gotoAndStop(h+1);
		}
		
		/*キーイベント++++
		if( keyObj == undefined ){
		var keyObj = new Object();
		keyObj.onKeyDown = function(){
			var kc = Key.getCode();
			if( kc == Key.SPACE ) {
				_root.mcShip.specialArm();
			}else if( kc == Key.SHIFT ) {	
				var nd = getTimer();
				if( nd - kdLast < 500 ) {
					_root.mcShip.fireFlg = 0;
					return;
				}
				kdLast  = nd;
				_root.mcShip.setFire();
			}else if( kc == 83 ){
				mcPanel.btnSound.setSoundToggle();
			}else if( kc == 82 ){
				if( _root.mcShip._visible ){
					if( _root["mcGameOver"] != undefined ){
						if( _root["mcGameOver"]._visible ) return;
					}
					_root.enemyManager.cleanup();
					_root.attachMovie("ID_WIPEM","mcWipe", 99999);
					//タイトル画面に戻ったときの処理をさせるためのダミーMC
					_root["mcGameOver"] = _root.attachMovie("NOFXMC", "mcGameOver", _root.FindDepth(DEPTH_MSG), {_x:-100});
				}
			}
		}
		Key.addListener(keyObj);
		*/
		
		public function Initialize():void {
			stageNo = 1;
			layer_base = mcLayer1;
			layerEn = new MovieClip();//敵キャラレイヤー
			layerB = new MovieClip();//自弾レイヤー
			layerEb = new MovieClip();//敵弾レイヤー
			layer_base.addChild(layerEn);
			layer_base.addChild(layerB);
			layer_base.addChild(layerEb);
			mcShip = mcMyship = AttachMc.core.add(layer_base, "myShip", "mcMyship");
			specialLeft = 3;
			theScore = 0;
			MenStart();
			bgmHandle = bgm_01;
			if(bgmHandle != null) bgmHandle.stop();
			totalTimeResult = 0;
		//	if( !soundOn ) mcPanel.btnSound.visible = false;
			
		}
		
		public function LoadSoundData():void {
			sfx_pup = new SoundFx("SFX_POWER");
			sfx_pup.setVolume(60);
			sfx_52 = new SoundFx("SFX_52");
			sfx_miss = new SoundFx("SFX_MISS");
			sfx_missile = new SoundFx("SFX_MISSILE");
			sfx_beam = new SoundFx("SFX_BEAMLOOP");
			sfx_pom = new SoundFx("SFX_POM");
			sfx_bang = new SoundFx("SFX_BANG");
			sfx_swing = new SoundFx("SFX_SWING");
			sfx_rocket = new SoundFx("SFX_ROCKET");		
			sfx_warn = new SoundFx("SFX_WARN");
			sfx_keen = new SoundFx("SFX_KEEN");
			sfxGun = new SoundFx("SFX_VALCAN");
			
			bgm_01 = new SoundFx("IDBGM_01");
			bgm_02 = new SoundFx("IDBGM_02");
			bgm_B01 = new SoundFx("IDBGM_B01");
			//マスターボリューム
			var mtrans:SoundTransform = new SoundTransform();
			mtrans.volume = 1.0;	// ボリューム
			SoundMixer.soundTransform = mtrans;
			trace("Sound Load OK");
		}
		

		public function setMasterVol(vol:Number/*0-100*/){
			if( vol == 100 ) {
				if( !soundOn ) return;
			}
			masterVol = vol;
			var mtrans:SoundTransform = new SoundTransform();
			mtrans.volume = masterVol / 100.0;	// ボリューム
			SoundMixer.soundTransform = mtrans;
		}

		public function SoundFadeIn(){
			if( !soundOn ) return;
			setMasterVol(0);
			//_root.attachMovie("IDSFX_FADEIN", "fxFadeIn", FindDepth(DEPTH_SNDFX) );
			AttachMc.core.add(this, "IDSFX_FADEIN", "fxFadeIn");
		}

		public function SoundFadeOut(){
			if( !soundOn ) return;
			//_root.attachMovie("IDSFX_FADEOUT", "fxFadeOut", FindDepth(DEPTH_SNDFX+1) );
			AttachMc.core.add(this, "IDSFX_FADEOUT", "fxFadeOut");
		}

		//ONN/OFF
		public function SoundSwitch() {
			if ( bgm_01 == null ) return;
			soundOn = !soundOn;
			if( soundOn ){
				setMasterVol(100);
				//if( bgmHandle.getSndCh().position == 0 ) bgmHandle.start(0, 999);
			}else{
				setMasterVol(0);
				//if( soundOn ) bgmHandle.stop();
			}
			return soundOn;
		}
		
		public function btnsEnable(fw:Boolean):void{
			btnStart.mouseEnabled = false;
			btnInst.mouseEnabled = false;
			btnExit.mouseEnabled = false;
		}
		
		public function putBonus(ptr:MovieClip):void{
			var pBn:MovieClip = AttachMc.core.add(this, "ID_BONUS1000", "mcBonus");
			pBn.x = ptr.x;
			pBn.y = ptr.y;
		}
		
		public function MenStart():void{
//			mcPanel.swapDepths(DEPTH_PANEL);
//			mcPanelL.swapDepths(DEPTH_PANEL+8);
//			mcPanelR.swapDepths(DEPTH_PANEL+10);
			enemyManager.cleanup();
			serialNo = 0;
			missileNo = 0;
			serial = 0;
			doHitChk = false;
			doScroll = true;// _root.param_BGscroll;
			ebFxSerial = 0;
			getEnm = 0;
			LIM = 0;
			hentai = 0;
			bonusStar = 0;
			mcShip.setStage(stageNo);//タイマースタート
			mcPanel.mcStock.gotoAndStop(specialLeft+1);
			//mcPanel.mcStageNum.gotoAndStop(stageNo);
			mcPanel.hp4.visible = false;
			
			var id:String = "IDSTART_" + stageNo;
			var psc:MovieClip = AttachMc.core.add(layer_base, id, "mcStartCaption");
			psc.x = 155-35;
			psc.y = 193;
			mcStartCaption = psc;

			musicStop();
			if( soundOn && bgmHandle != null ) bgmHandle.start(0, 999);
			stop();
			mcShip.Speed = 16;//プレイヤーの速度
			laserSoundOn = false;
			if( !soundOn ) mcPanel.btnSound.visible = false;
/*			
			for( var i:int = 0; i < 5; i++ ){
				if( i+1 <= mcShip.shield ){
					mcPanel["hp"+i].visible = true;
				}else{
					mcPanel["hp"+i].visible = false;
				}
			}
*/		
			if( rapidFireFlag != -1 ){
				mcShip.fireFlg = rapidFireFlag;
			}
		}
		
		public function musicStop():void {
			bgm_01.stop();
			bgm_02.stop();
			bgm_B01.stop();			
		}

		public function GameStart():void{
			startTime = getTimer();
		}
		public function GameEnd():Number{
			return(getTimer() - startTime);
		}

		//仰角
		public function GetRadian(x1:Number, y1:Number, x2:Number, y2:Number) : Number{
			var rad:Number;
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			if ( dx > 0 ) {
				if ( dy < 0 ) {
					rad = Math.atan(dx/-dy) + Math.PI;
				} else if ( dy > 0 ) {
					rad = -Math.atan(dx/dy) + (Math.PI*2);
				} else if ( dy == 0 ) {
					rad = (Math.PI*2) - (Math.PI/2);
				}
			} else if ( dx < 0 ) {
				if ( dy > 0 ) {
					rad = Math.atan(dx/-dy);
				} else if ( dy < 0 ) {
					rad = -Math.atan(dx/dy) + Math.PI;
				} else if ( dy == 0 ) {
					rad = Math.PI/2;
				}
			} else if ( dx == 0 ) {
				if ( dy > 0 ) {
					rad = Math.PI*2;
				} else {
					rad = Math.PI;
				}
			}
			return (rad);
		}

		//パワーアップアイテム出現
		public function makeItem(xPos:Number, yPos:Number, iType:int):void{
			var mci:MovieClip = AttachMc.core.add(layerEb, "ITEM_PUP", "mcItem" + 0, { initX:xPos, initY:yPos, type:iType } );
			if ( mci == null ) {
				trace("アイテム失敗 タイプ" + iType);
			}
		}

		//特殊攻撃
		public function InvokeSpecialArm():MovieClip{
			if( specialLeft <= 0 ) return null;
			//_root["mcStock"+specialLeft]._visible = false;
			specialLeft--;
			mcPanel.mcStock.gotoAndStop(specialLeft+1);
			var ptrW:MovieClip;
			switch(specialArmType){
			case 1:
				//ptrW = mcShip.attachMovie("ID_LASERBEAM", "mcMyLaser", 2999);
				ptrW = AttachMc.core.add(mcShip, "LASERBM", "mcMyLaser");
				//_root.sfx_beam.start(0, 2000);
				break;
			case 2:
				//_root.attachMovie("ID_FLASH", "mcFlash", 2999);
				AttachMc.core.add(this, "ID_FLASH", "mcFlash");
				//mcLayerEnemyBullets.removeMovieClip();
				layer_base.removeChild(layerEb);
				//layerEb = createEmptyMovieClip("mcLayerEnemyBullets", 3000);//敵弾レイヤー
				layerEb = new MovieClip();
				layer_base.addChild(layerEb);
				enemyManager.flash(10);//敵にダメージ
				missileNo = 0;
				ptrW = null;
				break;
			}
			return ptrW;
		}

		//アイテムゲット　サブウエポン
		public function GetSpecial():void{
			if( specialLeft < 4 ){
				specialLeft++;
				//_root["mcStock"+specialLeft]._visible = true;
				mcPanel.mcStock.gotoAndStop(specialLeft+1);
			}else{
				AddScore(5000);
			}
		}
		//アイテムゲット　星
		public function GetStar():void{
			bonusStar++;
		}

		public function FindDepth(ofs:int):Number {
			/*
			var x = ofs;
			for( ;;x++){
				if( _root.getInstanceAtDepth(x) == undefined ){
					return x;
				}
			}
			return -1;
			*/
			return 1;
		}

		//敵キャラ撃墜時に呼ばれる
		public function ren1(ptr:MovieClip, yarareta:Boolean=true):void{//編隊系
			if( yarareta ) hentai++;
			getEnm++;
			if( getEnm == LIM ){
				if( hentai == HENTAI_LIM ){    
					//_root.putBonus(ptr);
					makeItem(ptr.x, ptr.y, 3);//星
				}
				hentai = 0;
				play();
			}else if( hentai == HENTAI_LIM ){
				makeItem(ptr.x, ptr.y, 3);//星
			}
		}
		public function myCb0(ptr:MovieClip, yarareta:Boolean=true):void{//単体系
			getEnm++;
			if( getEnm == LIM ){
				play();
				//nextFrame();
			}
		}
		public function myCbNofx(ptr:MovieClip, yarareta:Boolean=true):void{}

		public function GameOver():void{
			getEnm = 9999999;
			//attachMovie("ID_GAMEOVER", "mcGameOver", FindDepth(DEPTH_MSG));
			mcGameOver = AttachMc.core.add(layer_base, "ID_GAMEOVER", "mcGameOver");
		}


		//敵弾消滅
		public function EraseEbullets():void{
			if( layerEb !=null ) layer_base.removeChild(layerEb);
			layerEb = new MovieClip();// createEmptyMovieClip("mcLayerEnemyBullets", DEPTH_PLAYER + 10);//敵弾レイヤー
			layer_base.addChild(layerEb);
		}

		//MochiAd --------------------------------------------------------------------
		function MochiInterAd():void{
			//var pClip = _root.createEmptyMovieClip("mcAdPt", DEPTH_AD);
			//mochi.as2.MochiAd.showInterLevelAd({id:"9ead60f8fe311fcd", res:"550x600", clip:pClip, ad_finished:MochiAdFinish});
		}
		function MochiAdFinish() {
			/*
			_root["mcAdPt"].removeMovieClip();
			_root.mcShip.clearHeal();
			_root.mcShip.freeze(false);
			_root.mcShip.swapDepths(_root.DEPTH_PLAYER);
			_root.mcShip.mcCore.play(1);
			_root.play();
			*/
		}

		function MochiSendScore(myName:String, myPts:Number, pClip:MovieClip, cbOk:Object){
			/*
			mochi.as2.MochiScores.showLeaderboard(
			{boardID:"35b0f89a160c6479", score:myPts, name:myName, 
			onClose:cbOk,
			clip:pClip,width:500,height:380 }
			);
			*/
		}
		function MochiShowScore(pClip:MovieClip, cbOk:Object){
			/*
			mochi.as2.MochiScores.showLeaderboard(
			{boardID:"35b0f89a160c6479",
			onClose:cbOk,
			clip:pClip,width:500,height:380,hideDoneButton:false }
			);
			*/
		}
		
		public function gamePause(sw:Boolean):Boolean {
			enemyManager.pause(sw);
			if ( sw ) playStatus = 1;
			else playStatus = 0;
			return sw;
		}
		
		public function localScore_save():Boolean {
			var so:SharedObject = SharedObject.getLocal("bugsattack");
			var hs:int;
			var sw:Boolean = false;;
			if ( isNaN(so.data.hiscore) ) {
				hs  = 0;
			}else{
				hs = so.data.hiscore;
			}
			if ( theScore >= hs ) {
				so.data.hiscore = highScore = theScore;
				sw = true;
			}
			if ( sw ) so.flush();
			return sw;
		}
		
		public function localScore_load():int {
			var so:SharedObject = SharedObject.getLocal("bugsattack");
			if ( !isNaN(so.data.hiscore) ) {
				return so.data.hiscore;
			}
			return 0;
		}
	}
}
