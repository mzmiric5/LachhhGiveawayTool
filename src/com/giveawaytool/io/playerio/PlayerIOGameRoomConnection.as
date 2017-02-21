package com.giveawaytool.io.playerio {
	import playerio.Client;
	import playerio.Connection;

	import com.lachhh.io.Callback;

	/**
	 * @author LachhhSSD
	 */
	public class PlayerIOGameRoomConnection extends PlayerIORoomConnection {
		
		public var getStreamLabsAccessTokenSuccess : PlayerIORoomCommand;
		public var getStreamLabsAccessTokenFailure : PlayerIORoomCommand;
			
		public var sendNewGamewispTokenSuccess : PlayerIORoomCommand;
		public var sendNewGamewispTokenFailure : PlayerIORoomCommand;
		
		public var getGamewispDataSuccess : PlayerIORoomCommand;
		public var getGamewispDataFailure : PlayerIORoomCommand;

		public function PlayerIOGameRoomConnection(pClient : Client, pDebug : Boolean) {
			super(pClient, pDebug);
		}

		override protected function onRoomGameConnected(con : Connection) : void {
			super.onRoomGameConnected(con);
			
			
			sendNewGamewispTokenSuccess = new PlayerIORoomCommand(this, "sendNewGamewispTokenSuccess");
			sendNewGamewispTokenFailure = new PlayerIORoomCommand(this, "sendNewGamewispTokenFailure");
			
			getGamewispDataSuccess = new PlayerIORoomCommand(this, "getGamewispDataSuccess");
			getGamewispDataFailure = new PlayerIORoomCommand(this, "getGamewispDataFailure");
			
			getStreamLabsAccessTokenSuccess = new PlayerIORoomCommand(this, "getStreamLabsAccessTokenSuccess");
			getStreamLabsAccessTokenFailure = new PlayerIORoomCommand(this, "getStreamLabsAccessTokenFailure");
			
		}
		
		public function getStreamLabsAccesssToken(authCode: String, success : Callback, failure : Callback) : void {
			getStreamLabsAccessTokenSuccess.onMsg = success;
			getStreamLabsAccessTokenFailure.onMsg = failure;
			connection.send("getStreamLabsAccessToken", authCode);
		}


		public function SendNewGameWispToken(accessToken : String, success : Callback, failure : Callback) : void {
			sendNewGamewispTokenSuccess.onMsg = success;
			sendNewGamewispTokenFailure.onMsg = failure;
			connection.send("sendNewGamewispToken", accessToken);
		}
		
		public function GetGameWispData(success : Callback, failure : Callback) : void {
			getGamewispDataSuccess.onMsg = success;
			getGamewispDataFailure.onMsg = failure;
			connection.send("getGamewispData");
		}
	}
}

