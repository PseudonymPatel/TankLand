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
	var livingTanks:Int?
	//the logger and the messageCenter specific to this running of TankWorld
	var logger = Logger()
	var messageCenter = MessageCenter()

	// -------------------------------------
	// Initializer
	// -------------------------------------
	init() {
		self.grid = Array(repeating: Array(repeating: nil, count: GRID_WIDTH), count: GRID_HEIGHT) //create a grid
		self.turn = 0
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
		let randEmpty = getRandomEmptyPosition()
		addGameObject(OurTank(row:randEmpty.row, col:randEmpty.col, energy:100000, id:"SHEE", instructions:"THIS TANK SUCKS"))
		//jtanks

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
	}


	//exactly what it sounds like
	//prints the grid. Does not return values.
	func displayGrid() {
		Grid(grid:grid).displayGrid()
	}

	//Computes a single turn of the game,
	//DOES NOT print the grid.
	func doTurn() {
		var allObjects = findAllGameObjects() //get all the objects
		allObjects = randomizeGameObjects(gameObjects: allObjects) //randomize, this will be order of execution


		tanks = allObjects.filter{$0.objectType == .Tank}

		for go in allObjects {
			switch go.objectType {
				case .Tank: applyCost(go,costLifeSupportTank)
				case .Mine: applyCost(go,costLifeSupportMine)
				case .Rover: applyCost(go,costLifeSupportRover)
			}

			if isDead(go) {
				logger.addMajorLog(go, "has died of life support")
				allObjects.remove(at: go)
			}
		}



		//do the logic here.

		for tank in tanks {

		}
		print(logger.log[logger.turn])
		self.turn += 1 //iterates the turn counter
		logger.nextTurn();
	}

	//this is the driving method. The main method.
	//will run your commands until a single tank remains.
	func driver() {
		populateTankWorld() //creates all tanks at random locations.
		displayGrid() //display the starting grid.

		repeat { //same as a while loop, makes sure there is at least one execution of loop body.
			//get user command first:
			print(">", terminator:"")
			let input = readLine()!

			switch input { //handle user input
				case let d where Int(input):
					print("running one turn...")
					for _ in 0..<d {
						doTurn()
						displayGrid()
					}
				case "win":
					while livingTanks > 1 {
						doTurn()
						displayGrid()
					}

					guard findAllTanks().length > 0, lastLivingTank = findAllTanks()[0] else {
						fatalError("no living tanks at the end")
					}

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
					doTurn()
					displayGrid()
			} //end of input handling switch

			//the idea with gameOver is that it will be set in doTurn(), so we need the loop to check. Otherwise we could do while(true)
		} while !gameOver

		print("\n** WINNER IS \(lastLivingTank!) **")
	}
}
