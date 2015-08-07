//Soundのラッパ
package 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName; 
	
	/**
	 * ...
	 * @author MH
	 */
	public class SoundFx 
	{
		private var sndID:String = "";
		private var snd:Sound = null;
		private var ch:SoundChannel = null;
		public var level:Number = 100;
		
		public function getSndCh():SoundChannel { return ch; }
		function SoundFx(id:String){
			sndID = id;
			try{
				var mcClass:Class = Class(getDefinitionByName(sndID));
				snd = new mcClass();
			}catch (e:Error) { snd = null; trace("音データなし " + id ); }
		}
		
		public function start(s:int = 0, c:int = 1):void {
			if( snd != null ){
				ch = snd.play(s, c);
				setVolume(level);
			}
		}
		
		public function play():void {
			start();
		}
		
		public function stop():void {
			if ( ch != null ) ch.stop();
		}
		
		public function setVolume(vol:Number):void {
			level = vol;
			if ( ch != null ){
				var trans:SoundTransform = ch.soundTransform;
				trans.volume = level / 100;	// ボリューム
				ch.soundTransform = trans;
			}
		}
	}
}