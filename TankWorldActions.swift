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
		guard let radarAction = tank.preActions[.Radar] else {
			return
		}

		actionRadar(tank:tank, radarAction:radarAction as! RadarAction)
	}

	func handleMove(tank:Tank) {
		guard let moveAction = tank.preActions[.Move] else {
			return
		}

		actionMove(tank:tank, moveAction:moveAction as! MoveAction)
	}

	func handleShields(tank:Tank) {
		guard let shieldAction = tank.preActions[.Shield] else {
			return
		}

		actionShield(tank:tank, shieldAction:shieldAction as! ShieldAction)

	}

	func handleMissile(tank:Tank) {
		guard let missileAction = tank.preActions[.Missile] else {
			return
		}

		actionMissile(tank:tank, missileAction:missileAction as! MissileAction)

	}

	func handleSendMessage(tank:Tank) {
		guard let sendMessageAction = tank.preActions[.SendMessage] else {
			return
		}

		actionSendMessage(tank:tank, sendMessageAction:sendMessageAction as! SendMessageAction)

	}

	func handleReceiveMessage(tank:Tank) {
		guard let receiveMessageAction = tank.preActions[.ReceiveMessage] else {
			return
		}

		actionReceiveMessageAction(tank:tank, receiveMessageAction:receiveMessageAction as! ReceiveMessageAction)

	}

	//for both mine and rover.
	func handleDropMine(tank:Tank) {
		guard let dropMineAction = tank.preActions[.DropMine] else {
			return
		}

		actionDropMine(tank:tank, Action:dropMineAction as! DropMineAction)
	}


	// -------------------------------
	// actual action code
	// -------------------------------

	func actionMove(tank:Tank, moveAction:MoveAction) {
		if isDead(tank) {
			return
		}

		logger.addLog(tank, "Moving tank \(moveAction)")

		let moveLength:Int = distance(tank.position, moveAction.position)

		guard moveLength <= 3, moveLength > 0 else {
			logger.addLog(tank, "Tank cannot move so far.")
			return
		}

		guard !isEnergyAvailable(tank, amount: Constants.costOfMovingTankPerUnitDistance[moveLength-1]) else {
			logger.addLog(tank, "Insufficent nrg to move.")
			return
		}

		guard grid[moveAction.postition.row][moveAction.position.col] == nil else {
			logger.addLog(tank, "Object already at position.")
			return
		}

		applyCost(tank, amount: Constants.costOfMovingTankPerUnitDistance[moveLength-1])

		moveObject(tank, toRow:moveAction.position.row, toCol:moveAction.position.col)
	}

	func actionShields(tank:Tank, shieldAction:ShieldAction) {
		if isDead(tank) {
			return
		}

		logger.addLog(tank, "adding shield \(shieldAction)")

		if !isEnergyAvailable(tank, amount:shieldAction.energy) {
			logger.addLog(tank, "Insufficient Energy to apply shield.")
			return
		}

		applyCost(tank, amount:shieldAction.energy)

		tank.shields = shieldAction.energy * Constants.shieldPowerMultiple
	}

	func actionMissile(tank:Tank, missileAction:MissileAction) {
		if isDead(tank) {
			return
		}

		logger.addLog(tank, "Sending Missile \(missileAction)")

		if !isEnergyAvailable(tank, amount:missileAction.energy) {
			logger.addLog(tank, "insuff. energy to send missile")
			return
		}

		applyCost(tank, amount:missileAction.energy)

		//do missile stuff
	}

	func actionRadar(tank:Tank, radarAction:RadarAction) {
		if isDead(tank) {
			return
		}

		logger.addLog(tank, "Doing Radar \(radarAction)")

		if !isEnergyAvailable(tank, amount:Constants.costOfRadarByUnitsDistance[radarAction.range]) {
			logger.addLog(tank, "insuff. energy to do radar")
			return
		}

		applyCost(tank, amount:Constants.costOfRadarByUnitsDistance[radarAction.range])

		//do radar stuff
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

	func actionReceiveMessage(tank:Tank, receiveMessageAction:ReceiveMessageAction) {
		//implementation provided on sheet
		if isDead(tank) {
			return
		}

		logger.addLog(tank, "Receiving Message \(receiveMessageAction)")

		if !isEnergyAvailable(tank, amount:Constants.costOfReceivingMessage) {
			logger.addLog(tank, "Insufficient Enerfy to reciese feme emessage.")
		}

		tank.receivedMessage = messageCenter.receiveMessage(id:receiveMessageAction.id)
	}

	func actionDropMine(tank:Tank, dropMineAction:DropMineAction) {
		if isDead(tank) {
			return
		}

		logger.addLog(tank, "Dropping Mine: \(dropMineAction)")

		if !isEnergyAvailable(tank, amount:dropMineAction.energy) {
			logger.addLog(tank, "insuff. energy to dropMineActiton")
			return
		}

		applyCost(tank, amount:dropMineAction.power)

		//create the thing
	}

	//typing all this shit on the chromebook gave me arthritis and I had to redo it because it was lost somehow (i'm fucking retarded)
	//i need to buy a good frikin keyboard.
}
