/*
*	This file contains only the TankWorld class.
*
*
*/

class TankWorld {

	// -------------------------------------
	// Properties
	// -------------------------------------

	//these govern the dimensions of the grid. Must be the same as the ones in grid.swift!
	private let GRID_WIDTH = 15
	private let GRID_HEIGHT = 15

	//an instance of Grid.
	var grid:[[GameObject?]]

	//governs what turn the game is currently on
	var turn:Int = 0

	//is the game over? Also, should this var be here? It is not in the specs.
	var gameOver:Bool = false

	//another one of those vars IDK if I should make. It is referenced in the code, but I see no declaration.
	var lastLivingTank:Tank?//change to Tank type once implemented!
	var livingTanks:Int = 0
	//the logger and the messageCenter specific to this running of TankWorld
	var logger = Logger()
	var messageCenter = MessageCenter()

	// -------------------------------------
	// Initializer
	// -------------------------------------
	init() {
		self.grid = Array(repeating: Array(repeating: nil, count: GRID_WIDTH), count: GRID_HEIGHT) //create a grid
		self.turn = 0
		populateTankWorld()
	}


	// -------------------------------------
	// Methods
	// -------------------------------------

	//sets the winner of the game
	func setWinner(lastTankStanding:Tank) {//change to Tank type once implemented
		gameOver = true
		lastLivingTank = lastTankStanding
	}

	func populateTankWorld() {

		//our tanks
		var randEmpty = getRandomEmptyPosition()
		addGameObject(OurTank(row:randEmpty.row, col:randEmpty.col, energy:100000, id:"SHEE", instructions:"THIS TANK SUCKS"))

		randEmpty = getRandomEmptyPosition()
		addGameObject(OurTank(row:randEmpty.row, col:randEmpty.col, energy:100000, id:"DION", instructions:"THIS TANK SUCKS"))

		randEmpty = getRandomEmptyPosition()
		addGameObject(OurTank(row:randEmpty.row, col:randEmpty.col, energy:100000, id:"OTHE", instructions:"THIS TANK SUCKS"))

		//jtanks
		randEmpty = getRandomEmptyPosition()
		addGameObject(JTank(row:randEmpty.row, col:randEmpty.col, energy:100000, id:"PALT", instructions:"THIS TANK SUCKS"))

		randEmpty = getRandomEmptyPosition()
		addGameObject(JTank(row:randEmpty.row, col:randEmpty.col, energy:100000, id:"TLAP", instructions:"THIS TANK SUCKS"))

		randEmpty = getRandomEmptyPosition()
		addGameObject(JTank(row:randEmpty.row, col:randEmpty.col, energy:100000, id:"LAPT", instructions:"THIS TANK SUCKS"))

		livingTanks = findAllTanks().count
	}

	//adds an object to the grid.
	//uses the position stored in the object as the inital position.
	//assumes that all positions are valid
	func addGameObject(_ object:GameObject) {
		assert(object.position.row < GRID_HEIGHT, "Row is out of bounds for placing of GameObject: \(object)")
		assert(object.position.col < GRID_WIDTH, "Column is out of bounds for placing of GameObject: \(object)")
		assert(grid[object.position.row][object.position.col] == nil, "There is already an object: \(String(describing:grid[object.position.row][object.position.col]))")
		grid[object.position.row][object.position.col] = object
	}

	//moves object to a Position
	func moveObject(_ object:GameObject, toRow:Int, toCol:Int) {
		//find the object that needs to be moved.
		var foundObject:GameObject! //will be inited once object found.

		//search sequentially for object
		objectFinder: for row in 0..<GRID_HEIGHT {
			for col in 0..<GRID_WIDTH {
				if let maybeObject = grid[row][col] { //if object at the grid point
					if maybeObject.id == object.id { //if they are same object
						foundObject = maybeObject //classes passed by reference, so they are the same item.
						grid[row][col] = nil //remove the object here, because it is moving!
						break objectFinder // breaks the full loop if object is found
					}
				}
			}
		}

		//make sure that there is an object found!
		assert(foundObject != nil, "The object to move (\(object)) was not found.")

		//add the object to the new space.
		grid[toRow][toCol] = foundObject
		foundObject.position = [toRow, toCol] //give the info back to the GO
	}


	//exactly what it sounds like
	//prints the grid. Does not return values.
	func displayGrid() {
		Grid(grid:grid).displayGrid()
	}

	//sees if thank dea,d the n do the ded messgae
	func doDeathStuff(_ tank:GameObject) {
		if isDead(tank) {
			logger.addLog(tank, "\u{001B}[7;33m   THE GameObject HAS DIED REEEEEEEEEEEEEEEEEEEEEEEEE   \u{001B}[0;00m")
			grid[tank.position.row][tank.position.col] = nil
		}

		if findAllTanks().count == 1 {
			setWinner(lastTankStanding: findAllTanks()[0])
		}
	}

	//Computes a single turn of the game,
	//DOES NOT print the grid.
	func doTurn() {
		var allObjects = findAllGameObjects() //get all the objects
		allObjects = randomizeGameObjects(gameObjects: allObjects) //randomize, this will be order of execution

		var n = 0 //iterator for while loop
		//does life support
		while n < allObjects.count {
			let go = allObjects[n]

			logger.addLog(go, "Charging life support")
			switch go.objectType {
				case .Tank: applyCost(go, amount:Constants.costLifeSupportTank)
				case .Mine: applyCost(go, amount:Constants.costLifeSupportMine)
				case .Rover: applyCost(go,amount:Constants.costLifeSupportRover)
			}

			if isDead(go) {
				doDeathStuff(go)
				allObjects.remove(at: n)
				continue //go to the start without iterating n
			}

			if findAllTanks().count == 1 {
				setWinner(lastTankStanding: go as! Tank)
				return //end the turn early
			}

			n += 1
		}

		let tanks = randomizeGameObjects(gameObjects: findAllTanks())//.map {$0 as! Tank}
		let rovers = randomizeGameObjects(gameObjects: findAllRovers()) //fails on this goddamn line

		for tank in tanks {
			let t = tank
			t.computePreActions()
			t.computePostActions()
		}

		//rovers move
		for rover in rovers {

			//find a position to move rover
			var position:Position = getLegalSurroundingPositions(rover.position)[Int.random(in: 0..<getLegalSurroundingPositions(rover.position).count)]
			if rover.roverMovementType == "direction" {
				let temp = newPosition(position: rover.position, direction: rover.roverMovementDirection!, magnitude:1)
				if temp.row < 15 && temp.col < 15 && temp.row >= 0 && temp.col >= 0 {
					position = temp
				} else {
					position = [-1,-1] //out of bounds
				}
			}

			//if there is a position to move to...
			if position.row == -1 && position.col == -1 && rover.energy >= Constants.costOfMovingRover {
				//if there is an object at the position
				rover.energy -= Constants.costOfMovingRover
				if let killObj = grid[position.row][position.col] {
					grid[rover.position.row][rover.position.col] = nil //remove rover
					killObj.energy -= rover.energy //take away energy
					doDeathStuff(killObj) //see if ded. will remove if ded
				} else {
					//nothing, so move.
					grid[rover.position.row][rover.position.col] = nil
					grid[position.row][position.col] = rover
					rover.position = position
				}
			}

			//just in case??
			doDeathStuff(rover)

			//in case this mine just killed the last tank
			if gameOver {
				return
			}
		}

		for tank in tanks {
			handleRadar(tank:tank)
			doDeathStuff(tank)
		}

		for tank in tanks {
			handleSendMessage(tank:tank)
			doDeathStuff(tank)
		}

		for tank in tanks {
			handleReceiveMessage(tank:tank)
			doDeathStuff(tank)
		}

		for tank in tanks {
			handleShields(tank:tank)
			doDeathStuff(tank)
		}

		for tank in tanks {
			handleDropMine(tank:tank)
			handleMissile(tank:tank)
			handleMove(tank:tank)
			doDeathStuff(tank)
		}

		for tank in tanks {
			let t = tank
			t.preActions = [:]
			t.postActions = [:]
		}

		print(logger.getTurnLog())
		self.turn += 1 //iterates the turn counter
		logger.nextTurn() //iterates the logger turn counter
	}

	//this is the driving method. The main method.
	//will run your commands until a single tank remains.
	func driver() {
		displayGrid() //display the starting grid.

		repeat { //same as a while loop, makes sure there is at least one execution of loop body.
			//get user command first:
			print(">", terminator:"")
			let input = readLine()!

			switch input { //handle user input
				case "win":
					while livingTanks > 1 {
						doTurn()
						displayGrid()
					}

					guard findAllTanks().count > 0 else {
						fatalError("no living tanks at the end")
					}

					lastLivingTank = findAllTanks()[0]

					gameOver = true

				case "quit":
					print("exiting interactive")
					gameOver = true
				case "d":
					print("running until die")
					let alive = livingTanks
					while livingTanks >= alive {
						doTurn()
						displayGrid()
					}
				default:
					if let d = Int(input) {
						print("running one turn...")
						for _ in 0..<Int(d) {
							doTurn()
							displayGrid()
						}
					}

					doTurn()
					displayGrid()
			} //end of input handling switch

			//the idea with gameOver is that it will be set in doTurn(), so we need the loop to check. Otherwise we could do while(true)
		} while !gameOver

		print("\n\u{001B}[7;34m** WINNER IS \(lastLivingTank!) **\u{001B}[0;00m")
	}
}
