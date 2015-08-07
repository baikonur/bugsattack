//AS1.0/2.0のattachMovie風にムービークリップをaddChildする
//シングルトンクラス
//まず起動時に1回AttachMc.create()してAttachMc.core.add(..)で実行
package 
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;  
	
	public class AttachMc 
	{
		public static var core:AttachMc = null;
		public function get core():AttachMc { return getInstance(); }
		public static function create():void { getInstance(); }
		
		public static function getInstance():AttachMc {
			if(core == null) {
				core = new AttachMc(arguments.callee);
			}
			return core;
		}
		
		public function AttachMc(caller:Function = null) {
			if(caller != AttachMc.getInstance) {
				throw new Error("AttachMc は Singletonクラスです。.coreでアクセスしてください。");
			}
			if(AttachMc.core != null) {
				throw new Error("AttachMcインスタンスはひとつしか生成できません。");
			}
		}
		
		public function add(pParent:MovieClip, //親MC
		                    strId:String, 	//リンケージ名
							n:String/*ダミー*/, obj:Object=null):MovieClip {
			var mcInstence:MovieClip = null;
			try{
				var mcClass:Class = Class(getDefinitionByName(strId));
				mcInstence = new mcClass();
			}catch (e:Error) { return null; }
			//if( n.length > 0 ) pParent[n] = mcInstence;
			if ( obj != null ) {
				for ( var key:String in obj ) {
					mcInstence[key] = obj[key];
				}
			}
			pParent.addChild(mcInstence);
			return mcInstence;
		}
	}
	
}