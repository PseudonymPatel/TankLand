import Glibc //wow also just for credits
import Foundation //just for the credits lol
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
	var lastLivingTank:GameObject?//change to Tank type once implemented!
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
	func setWinner(lastTankStanding:GameObject) {//change to Tank type once implemented
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

		//delete the current space
		grid[object.position.row][object.position.col] = nil

		//add the object to the new space.
		grid[toRow][toCol] = object
		object.position = [toRow, toCol] //give the info back to the GO
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
			if tank.objectType == .Tank {
				livingTanks -= 1
			}
		}

		if findAllTanks().count == 1 {
			setWinner(lastTankStanding: findAllTanks()[0])
		}
	}

	//Computes a single turn of the game,
	//DOES NOT print the grid.
	func doTurn() {
		livingTanks = findAllTanks().count
		var allObjects = findAllGameObjects() //get all the objects
		allObjects = randomizeGameObjects(gameObjects: allObjects) //randomize, this will be order of execution

		var n = 0 //iterator for while loop
		//does life support
		while n < allObjects.count {
			let go = allObjects[n]

			logger.addLog(go, "is being charged life support")
			switch go.objectType {
				case .Tank: applyCost(go, amount:Constants.costLifeSupportTank)
				case .Mine: applyCost(go, amount:Constants.costLifeSupportMine)
				case .Rover: applyCost(go,amount:Constants.costLifeSupportRover)
			}

			if isDead(go) || go.energy < 1 {
				doDeathStuff(go)
				allObjects.remove(at: n)
				continue //go to the start without iterating n
			}

			if findAllTanks().count == 1 {
				setWinner(lastTankStanding: go)
				print(logger.getTurnLog())
				return //end the turn early
			}

			n += 1
		}

		var tanks = randomizeGameObjects(gameObjects: findAllGameObjects())//.map {$0 as! Tank}
		n = 0
		while n < tanks.count {
			if(tanks[n].objectType == .Mine || tanks[n].objectType == .Rover) {
				tanks.remove(at: n)
				continue
			}
			n += 1
		}

		var rovers = randomizeGameObjects(gameObjects: findAllGameObjects())
		n = 0
		while n < rovers.count {
			if (rovers[n].objectType == .Tank || rovers[n].objectType == .Mine) {
				rovers.remove(at: n)
				continue
			}
			n += 1
		}

		for tank in tanks {
			let t = tank as! Tank
			t.computePreActions()
			t.computePostActions()
		}

		//rovers move
		for rover in rovers {
			guard let rover = rover as? Mine else {
				print("not a mine")
				break
			}
			//find a position to move rover
			var position:Position = getLegalSurroundingPositions(rover.position)[Int.random(in: 0..<getLegalSurroundingPositions(rover.position).count)]
			if rover.roverMovementType == "direction" {
				let temp = newPosition(position: rover.position, direction: rover.roverMovementDirection!, magnitude:1)
				if isValidPosition(temp) {
					position = temp
				} else {
					position = [-1,-1] //out of bounds
				}
			}

			//if there is a position to move to...
			if isValidPosition(position) && rover.energy >= Constants.costOfMovingRover {
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
				print(logger.getTurnLog())
				return
			}
		}

		for tank in tanks {
			handleRadar(tank:tank as! Tank)
		}

		for tank in tanks {
			handleSendMessage(tank:tank as! Tank)
		}

		for tank in tanks {
			handleReceiveMessage(tank:tank as! Tank)
		}

		for tank in tanks {
			handleShields(tank:tank as! Tank)
		}

		for tank in tanks {
			handleDropMine(tank:tank as! Tank)
			handleMissile(tank:tank as! Tank)
			handleMove(tank:tank as! Tank)
			if gameOver {
				print(logger.getTurnLog())
				return
			}
		}

		for tank in tanks {
			let t = tank as! Tank
			t.preActions = [:]
			t.postActions = [:]
		}

		print(logger.getTurnLog())

		if gameOver {
			return
		}

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

					guard findAllTanks().count == 1 else {
						fatalError("no or too many living tanks at the end: \(findAllTanks().count)")
					}

					lastLivingTank = findAllTanks()[0] as GameObject

					gameOver = true

				case "quit":
					print("exiting interactive")
					return
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

			// :) a treat if you run the executable
		let commands = CommandLine.arguments
		guard commands.count > 1 else {
			print(":)")
			return
		}

		func swish() {
			print("\u{001B}[1;35;104m#####################\u{001B}[25D",terminator:"")
			fflush(stdout)
			sleep(1)
			print("\u{001B}[1;35;104m-########---########-\u{001B}[25D",terminator:"")
			fflush(stdout)
			sleep(1)
			print("\u{001B}[1;35;104m--######-----######--\u{001B}[25D",terminator:"")
			fflush(stdout)
			sleep(1)
			print("\u{001B}[1;35;104m---####-------####---\u{001B}[25D",terminator:"")
			fflush(stdout)
			sleep(1)
			print("\u{001B}[1;35;104m----##---------##----\u{001B}[25D",terminator:"")
			fflush(stdout)
			sleep(1)
			print("\u{001B}[1;35;104m---------------------\u{001B}[25D",terminator:"")
			fflush(stdout)
			sleep(1)
		}

		if commands[1] == "exec" {
			//do the cool stuff
			print("\n\n\u{001B}[2A",terminator:"")
			print("\u{001B}[1;93;104m       CREDITS       \u{001B}[0m")
			print("\u{001B}[1;93;104m                     \u{001B}[0m")
			print("\u{001B}[1;93;104m                     \u{001B}[0m",terminator:"")
			print("\u{001B}[1A\u{001B}[25D",terminator:"")
			swish()
			for _ in 0..<1 {
				print("\u{001B}[1;35;104m     Sheen Patel     \u{001B}[0m",terminator:"")
				print("\u{001B}[25D",terminator:"")
				fflush(stdout)
				sleep(3)
				swish()
				print("\u{001B}[1;35;104m      Deon Chan      \u{001B}[0m",terminator:"")
				print("\u{001B}[25D",terminator:"")
				fflush(stdout)
				sleep(3)
				swish()
				print("\u{001B}[1;35;104m Mr. Pali - debugger \u{001B}[0m",terminator:"")
				print("\u{001B}[25D",terminator:"")
				fflush(stdout)
				sleep(3)
				swish()
			}
		}
		print("\u{001B}[1A",terminator:"")
		print("\u{001B}[1;37;3m HAVE A GREAT SUMMER!\u{001B}[0m")
		print("\u{001B}[1;30;104m         :)          \u{001B}[0m\u{001B}[1B\u{001B}[21C")
	}
}
