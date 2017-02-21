package com.giveawaytool.io.playerio {
	import com.giveawaytool.io.PlayerIOLachhhRPGController;
	import com.lachhh.io.Callback;
	/**
	 * @author LachhhSSD
	 */
	public class MetaServerProgress {
		static public var instance:MetaServerProgress = new MetaServerProgress();
		
		public var firstTimeLoggingIn:Boolean = false;
		
		public function clear():void {
			
		}
		
		public function getStreamLabsAccessToken(authCode:String, success : Callback, failure : Callback) : void {
			PlayerIOLachhhRPGController.getInstance().mySecuredConnection.connectionGameRoom.getStreamLabsAccesssToken(authCode, success, failure);
		}
		
		public function sendNewGamewispToken(accessToken:String, success : Callback, failure : Callback) : void {
			PlayerIOLachhhRPGController.getInstance().mySecuredConnection.connectionGameRoom.SendNewGameWispToken(accessToken, success, failure);
		}
		
		public function getGamewispData(success : Callback, failure : Callback) : void {
			PlayerIOLachhhRPGController.getInstance().mySecuredConnection.connectionGameRoom.GetGameWispData(success, failure);
		}
		
		public function loadGameWishSub(str:String, success : Callback, errorCall : Callback) : void {
			PlayerIOLachhhRPGController.getInstance().mySecuredConnection.LoadMySub(str, success, errorCall);
		}
		
		public function loadAllGameWishSub(m:MetaGameWispGroup, success : Callback, errorCall : Callback) : void {
			PlayerIOLachhhRPGController.getInstance().mySecuredConnection.LoadAllGameWispDub(m, success, errorCall);
		}
		
		
	}
}
