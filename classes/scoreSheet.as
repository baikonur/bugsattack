//AS2.0 Flash Remoting + ColdFusion 用
import mx.remoting.*;
import mx.rpc.*;
import mx.styles.CSSStyleDeclaration;
import mx.controls.*;
 
class scoreSheet extends MovieClip {
	 
	var MSG_DEPTH = 10008;
	var GATEWAYURL = "http://www.fargenius.com/flashservices/gateway/";
	var SERVICENAME = "ba";

	var myGrid:DataGrid;
	var myDataSet:Object;
	var nn = 0;//初回フラグ
	var numRanker = 0;
	var myUID = "", myIndexNo = -1;
	var nowKey = 2;//ソートキー
	var myResponder = null;
	var remotingService:Service = null;
	var listenerObject:Object;
	var cmbListener:Object;
	var newData:Object;
	var err:Boolean = false;
	var prepare:Boolean = false;

	function onLoad(){
		//System.useCodepage = true;//SWFの先頭に
		//NetDebug.initialize();
		myResponder = null;
		remotingService = null;

		//スタイル定義
		if( nn == 0 ){
			var headerStyles = new CSSStyleDeclaration();
			headerStyles.setStyle("fontWeight", "bold"); 
			headerStyles.setStyle("textAlign", "center"); 
			headerStyles.setStyle("color", 0x0066cc);//ヘッダーテキスト色
			myGrid.setStyle("headerColor", 0xffffcc);//ヘッダー色
			myGrid.setStyle("backgroundColor", 0xffffff);//ベース色
			myGrid.setStyle("headerStyle", headerStyles);
			myGrid.setStyle("fontSize", 14);
			myGrid.setStyle("fontWeight", "bold");
			myGrid.setStyle("color", 0x077BF8);//テキストカラー
			myGrid.setStyle("vGridLineColor", 0x666666);//バーティカルライン
			myGrid.setStyle("hGridLineColor", 0xaaaaaa);//ホリゾンタルライン
		}
		//myGrid._alpha = 75;
		myGrid.selectable = false;
		/*
		var lcMain:LocalConnection = new LocalConnection();
		var baseDomain = lcMain.domain();
		if( baseDomain.indexOf("fargenius") == -1 ){
			err = true;
			var msgError = attachMovie("ID_REMOTING_ERROR","mcError", MSG_DEPTH);
			msgError.tbReason.text = "Fatal Error";
		}else{
			err = false;
		}
		*/
		/*
			//ヘッダーをクリックしたときの処理
			listenerObject = new Object();
			listenerObject.owner = this;
			listenerObject.headerRelease = function(eventObject){
				var no = eventObject.columnIndex;
				if( no != this.owner.nowKey ){
					this.owner.nowKey =  no;
					this.owner.ScoreSortOn(no);
					//this.owner.cmbSortKey.selectedIndex = no - 2;
				}
			}
			myGrid.addEventListener("headerRelease", listenerObject);
			*/
			/*
			cmbListener = new Object();
			cmbListener.owner = this;
			cmbListener.change = function(evt){
				var no = evt.target.value;
				if( no != this.owner.nowKey ){
					this.owner.nowKey = no;
					this.owner.ScoreSortOn(no);
				}
			}
			//cmbSortKey.addEventListener("change", cmbListener); //コンボボックス
			*/

		prepare = true;
	}
	function unload(){
		if( remotingService != null ){
			delete remotingService;
			delete myResponder;
		}
	}
	//スタイル設定
	function ccsStyling(){
		if( nn == 0 ){
			myGrid.removeColumnAt(1); //UIDは非表示データ
			nn = 1;
			var pClm = myGrid.getColumnAt(0);
			//trace(pClm.headerText);
			pClm.sortable = false;
			myGrid.resizableColumns = false;
			//pClm.width = 48;
			pClm.headerText = "Rank";
			
			var pClm1 = myGrid.getColumnAt(1);
			pClm1.headerText = "Name";
			pClm1.width = 148;
			pClm1.sortable = false;
			
			var pClm2 = myGrid.getColumnAt(2);
			pClm2.headerText = "Score";
			pClm2.width = 84;
			//pClm2.sortable = true;
			pClm2.sortOnHeaderRelease = false;
			
			var pClm3 = myGrid.getColumnAt(3);
			pClm3.headerText = "Time";
			pClm3.width = 78;
			//pClm3.sortable = true;
			pClm3.sortOnHeaderRelease = false;
			/*
			var pClm4 = myGrid.getColumnAt(4);
			pClm4.headerText = "Data3*";
			pClm4.sortOnHeaderRelease = false;
			*/
			pClm.setStyle("textAlign", "center");
			pClm.setStyle("fontWeight", "bold");
			pClm2.setStyle("textAlign", "center");
			pClm3.setStyle("textAlign", "center");
			//pClm4.setStyle("textAlign", "center");
			
		}
	}

//u = CreateUID();  Score_Submit( "予定", 86, 80.9, 389, u );
//gotoAndPlay("SAVESCORE");
//LoadScoreData("");

//公開メソッド-------------------------------------------------------------------------
//スコア送信
	public function Score_Submit( aName:String, aScore:Number, aTime:Number/*秒*/ ){
		myUID = CreateUID();
		trace("SAVE SCORE -------\n" + 
				 aName + "\n" +
				 aScore + "\n" +
				 myUID );
		if( remotingService == null ) {
			Remoting_Connect(myUID);
		}
		if( remotingService != null ) {
			remotingService.SetResult( escape(aName), aScore, aTime, myUID);
			/* 引数 SetResult($name,$score,$rate,$playtime,$uid) */
		} 
	}
//スコアロード
	public function Score_Display(){
		if( !prepare ){
			err = true;
			var msgError = attachMovie("ID_REMOTING_ERROR","mcError", MSG_DEPTH);
			msgError.tbReason.text = "初期化以前にメソッドが呼ばれました";
			return;
		}
		gotoAndPlay("LOADSCORE");
	}
//UID生成
	function CreateUID():String{
		var scl = System.capabilities.language;
		if( scl == "" || scl == undefined ) scl = "-";
		var iTime = new Date();
		var uidHead:String = "u"+ "_"+ scl;
		var aUID:String = uidHead + String(iTime.getTime() - 1100000000000);//UID
		delete iTime;
		return aUID;
	}

//-----------------------------------------------------------------------------
	//スコアロード   2フレーム以降で呼ぶ
	function Score_Load( uid:String ){
		trace("Load "+uid);
		if( uid != "" ) myUID = uid;
		if( remotingService == null ) {
			Remoting_Connect(uid);
		}
		if( remotingService != null ) {
			remotingService.GetResults();
		}
	}
	//初期化
	function Remoting_Connect(uid:String){
		//SERVICENAME = _root.cfcHandle;
		if( myResponder == null && !err ){
			myResponder = new mx.rpc.RelayResponder(this,
																"GetResults_Result","GetResults_Fault");
			remotingService = new mx.remoting.Service(GATEWAYURL, 
												  null,// new mx.services.Log(), //ログ出力あり
												   SERVICENAME,
												   null, myResponder);
			trace("remotingService:"+remotingService);
		}
		
		/*
		URLエンコード文字列　= escape(日本語文字列);
		日本語文字列 = unescape(URLエンコード文字列);
		*/
		//
		nn = 0;
		numRanker = 0;
		myIndexNo = -1;
		
		//cmbSortKey.setStyle("fontSize", 16);
		//cmbSortKey.setStyle("fontWeight", "bold");
	}
	//並び替え
	function ScoreSortOn(no:Number){
		var strkey = [ "", "",  "score" , "time" ];// 2, 3, 4,
		myIndexNo = SortAndNumbering( newData, strkey[no], numRanker);
		trace("Sort On "+ strkey[no]);
		if( myIndexNo >= 0 ) {
			//myGrid.setSelectedIndex(myIndexNo);
			myGrid.selectedIndex = myIndexNo;
			myGrid.vPosition =  myIndexNo;
		}
	}
	
	function GetResults_Result(re:ResultEvent){ //読み込み成功
		if( re.result == "true" ){
			trace("LOAD re.result ???");
			gotoAndPlay("LOADSCORE");
		}else{
			trace("Score LOAD OK");
			numRanker = re.result.mRecordsAvailable;
			//newData = re.result.items;
			newData = myFormatter(re.result.items, numRanker);
			myIndexNo = SortAndNumbering( newData, "score", numRanker);
			if( myIndexNo >= 0 ){
				//myGrid.setSelectedIndex(myIndexNo);//自分のデータをハイライト
				myGrid.selectedIndex = myIndexNo;
				myGrid.vPosition =  myIndexNo;

			}
			trace("num="+ numRanker);
			gotoAndStop("EVERYTHINGOK");
		}
	}
	function GetResults_Fault(fe:FaultEvent){//読み込みエラー
		PutErrorString(fe);
	}
	function SetResult_Result(re:ResultEvent){//書き込み成功
		gotoAndPlay("LOADSCORE");
	}
	function SetResulta_Fault(fe:FaultEvent){//書き込みエラー
		PutErrorString(fe);
	}
	function PutErrorString(fe:FaultEvent){
		var msgError = attachMovie("ID_REMOTING_ERROR","mcError", MSG_DEPTH);
		msgError.tbReason.text = fe.fault.faultstring;
		trace( fe.fault.faultstring );
		gotoAndStop(1);
	}
	
	//適切な型に変換する
	function myFormatter(records:Object, num:Number):Object{
		var info = new Array(num);
		for( var i = 0; i < num; i++){
			var pRecdata:Object = records[i];
			var aResult = new Object();// struct_Result();
			var m = Math.floor( pRecdata.time / 60 ); //Sec -> m:s 表記へ
			var s = pRecdata.time - (m * 60);
			if( s < 10 ) {
				aResult.time = m+":0"+s;
			}else{
				aResult.time = m+":"+s;
			}
			aResult.score =  pRecdata.score;
			aResult.name = unescape(pRecdata.name);
			aResult.uid = pRecdata.uid;
			info[i] = aResult;
			//myGrid.addItem(aResult);
		}
		return info;
	}
	
	//並び替えと順位付け
	//keyには "time" / "score"　のどれかを渡す
	function SortAndNumbering(resultsData:Object, key:String, num:Number):Number{
		var indexId = -1;
		var flg = Array.NUMERIC;
		if( key == "score" ) flg |= Array.DESCENDING; // 大きい順 
		if( resultsData[0][key] == undefined ) return -1;
		resultsData.sortOn(key, flg);
		myGrid.dataProvider.removeAll();
		var no = 0, lastnum = -1, ranking = 0;
		for( var i = 0; i < num; i++ ){
			var pRankInfo:Object = resultsData[i];
			if( pRankInfo[key] == lastnum ){
				ranking = no;
			}else{
				no++;
				ranking = no;
			}
			pRankInfo.rank = ranking;
			lastnum = pRankInfo[key];
			//trace(resultsData[i].name);
			//trace( ranking +":"+resultsData[i].playtime + " " + resultsData[i].score + " " + resultsData[i].rate);
			if( pRankInfo.uid == myUID ){//自分のデータ
				indexId = i;
			}
			//myGrid.replaceItemAt(i, pRankInfo);
			myGrid.addItem(pRankInfo);
		}
		//
		ccsStyling();
		return indexId;
	}
	
 }