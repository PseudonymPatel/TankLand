/*
*	handles each action.
*
*	Follows format:
*	 1. all handle helper methods
*	 2. all action code itself
*
*/

extension TankWorld {

	// -----------------------
	// helpers
	// -----------------------

	func handleRadar(tank:Tank) {

	}

	func handleMove(tank:Tank) {

	}

	func handleShields(tank:Tank) {

	}

	func handleMissile(tank:Tank) {

	}

	func handleSendMessage(tank:Tank) {

	}

	func handleReceiveMessage(tank:Tank) {

	}

	//for both mine and rover.
	func handleDropMine(tank:Tank) {

	}


	// -------------------------------
	// actual action code
	// -------------------------------

	func actionMove(tank:Tank, moveAction:MoveAction) {

	}

	func actionShields(tank:Tank, shieldAction:ShieldAction) {

	}

	func actionMissile(tank:Tank, missileAction:MissileAction) {

	}

	func actionRadar(tank:Tank, radarAction:RadarAction) {

	}

	func actionSendMessage(tank:Tank, sendMessageAction:SendMessageAction) {
		if isDead(tank) {
			return
		}

		logger.addLog(tank, "Sending Message \(sendMessageAction)")

		if !isEnergyAvailable(tank, amount:Constants.costOfSendingMessage) {
			logger.addLog(tank, "Insufficient energy to send message")
			return
		}

		applyCost(tank, amount:Constants.costOfSendingMessage)

		//the only actual code thats not just error checking and whatnot
		messageCenter.sendMessage(id:sendMessageAction.id, message:sendMessageAction.message)
	}

	func actionRecieveMessage(tank:Tank, receiveMessageAction:ReceiveMessageAction) {
		//implementation provided on sheet
	}

	func actionDropMine(tank:Tank, dropMineAction:DropMineAction) {

	}

	//typing all this shit on the chromebook gave me arthritis and I had to redo it because it was lost somehow (i'm fucking retarded)
	//i need to buy a good frikin keyboard.
}
