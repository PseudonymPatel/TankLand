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
		guard let moveAction = tank.postActions[.Move] else {
			return
		}

		actionMove(tank:tank, moveAction:moveAction as! MoveAction)
	}

	func handleShields(tank:Tank) {
		guard let shieldAction = tank.preActions[.Shields] else {
			return
		}

		actionShields(tank:tank, shieldAction:shieldAction as! ShieldAction)

	}

	func handleMissile(tank:Tank) {
		guard let missileAction = tank.postActions[.Missile] else {
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

		actionReceiveMessage(tank:tank, receiveMessageAction:receiveMessageAction as! ReceiveMessageAction)

	}

	//for both mine and rover.
	func handleDropMine(tank:Tank) {
		guard let dropMineAction = tank.postActions[.DropMine] else {
			return
		}

		actionDropMine(tank:tank, dropMineAction:dropMineAction as! DropMineAction)
	}


	// -------------------------------
	// actual action code
	// -------------------------------

	func actionMove(tank:Tank, moveAction:MoveAction) {
		if isDead(tank) {
			return
		}

		logger.addLog(tank, "Moving tank \(moveAction)")

		//if in distance
		guard moveAction.distance <= 3, moveAction.distance > 0 else {
			logger.addLog(tank, "Tank cannot move so far.")
			return
		}

		//if energy available
		guard !isEnergyAvailable(tank, amount: Constants.costOfMovingTankPerUnitDistance[moveAction.distance-1]) else {
			logger.addLog(tank, "Insufficent nrg to move.")
			return
		}
		//get a position to move to
		let position = newPosition(position:tank.position, direction:moveAction.direction, magnitude:moveAction.distance)

		guard isValidPosition(position) else {
			logger.addLog(tank, "tried to move to an invalid position.")
			return
		}

		//see if there is a mine or a rover or tank at newPos:
		if let obj = grid[position.row][position.col] {
			if obj.objectType == .Tank {
				logger.addLog(tank, "tried to move to a already taken spot!")
				return
			}
		}

		applyCost(tank, amount: Constants.costOfMovingTankPerUnitDistance[moveAction.distance-1])

		//if there is a mine/rover there:
		if let mine = grid[position.row][position.col] {
			logger.addLog(tank, "about to hit mine or rover")
			tank.energy -= mine.energy * Constants.mineStrikeMultiple
			if isDead(tank) {
				doDeathStuff(tank)
			} else {
				//put the tank there
				moveObject(tank, toRow:position.row, toCol:position.col)
			}
		} else { //just move the thing
			moveObject(tank, toRow:position.row, toCol:position.col)
		}
	}

	func actionShields(tank:Tank, shieldAction:ShieldAction) {
		if isDead(tank) {
			return
		}

		logger.addLog(tank, "adding shield \(shieldAction)")

		if !isEnergyAvailable(tank, amount:shieldAction.power) {
			logger.addLog(tank, "Insufficient Energy to apply shield.")
			return
		}

		applyCost(tank, amount:shieldAction.power)

		tank.shields = shieldAction.power * Constants.shieldPowerMultiple
	}

	func actionMissile(tank:Tank, missileAction:MissileAction) {
		if isDead(tank) {
			return
		}

		logger.addLog(tank, "Sending Missile \(missileAction)")

		if !isEnergyAvailable(tank, amount:missileAction.power) {
			logger.addLog(tank, "insuff. energy to send missile")
			return
		}

		//make sure sending to real location:
		guard isValidPosition(missileAction.target) else {
			logger.addLog(tank, "Cannot send missile out of bounds.")
			return
		}

		applyCost(tank, amount:missileAction.power)

		//do missile stuff
		//first find target location:
		let target = missileAction.target

		//find all the surrounding tiles: (array)
		let surrounding = getLegalSurroundingPositions(target)
		//drain energy.
		if !isPositionEmpty(target) {
			grid[target.row][target.col]!.energy -= missileAction.power * Constants.missileStrikeMultiple
			doDeathStuff(grid[target.row][target.col]!)
		}

		for location in surrounding {
			if !isPositionEmpty(location) {
				grid[location.row][location.col]!.energy -= missileAction.power * Constants.missileStrikeMultipleCollateral
				doDeathStuff(grid[location.row][location.col]!)
			}
		}
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
		let results = findGameObjectsWithinRange(tank.position, range:radarAction.range)
		var convert = [RadarResult]()

		for i in results {
			convert.append(RadarResult(position:i, id:grid[i.row][i.col]!.id, energy:grid[i.row][i.col]!.energy))
		}

		//set the tank's property to this.
		tank.radarResults = convert
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

		tank.receivedMessage = messageCenter.receive(id:receiveMessageAction.id)
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

		applyCost(tank, amount:dropMineAction.energy)

		//create the thing....

		//find the position to drop it:
		var dropSpot = findFreeAjacent(tank.position)
		if dropMineAction.dropDirection != nil {
			dropSpot = newPosition(position: tank.position, direction:dropMineAction.dropDirection!, magnitude:1)
			if !isValidPosition(dropSpot!) {
				dropSpot = [-1,-1]
			}
		}

		//is it rover or mine -> create object to place
		let rover:Mine!
		guard dropSpot!.row != -1, dropSpot!.col != -1 else {
			return
		}

		if dropMineAction.isRover {
			//its a rover
			//create the rover as an object:
			rover = Mine(row:dropSpot!.row, col:dropSpot!.col, objectType:.Rover, energy:dropMineAction.energy, id:"@=@}", isRover:true, roverMovementType: (dropMineAction.moveDirection == nil) ? "random" : "direction", roverMovementDirection:dropMineAction.moveDirection)
		} else {
			//its a mine
			rover = Mine(row:dropSpot!.row, col:dropSpot!.col, objectType:.Mine, energy:dropMineAction.energy, id:"_/\\_", isRover:false)
		}

		//put rover on the board.
		grid[dropSpot!.row][dropSpot!.col] = rover
	}

	//typing all this shit on the chromebook gave me arthritis and I had to redo it because it was lost somehow (i'm fucking retarded)
	//i need to buy a good frikin keyboard.
}
