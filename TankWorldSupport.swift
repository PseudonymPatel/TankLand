// For all the support functions to make life easier.

extension TankWorld {

	//given position, direction, mag, return new position -> vector math :(
	func newPosition(position:Position, direction:Direction, magnitude:Int) -> Position {
		return [0,0]
	}

	//are row, col in the grid??
	func isGoodIndex(row:Int, col:Int) -> Bool {
		guard row < 15, row >= 0 else {
			return false
		}

		guard col < 15, row >= 0 else {
			return false
		}

		return true
	}

	//is a given pos in grid - similar to above one
	func isValidPosition(_ position:Position) -> Bool {
		guard position.row < 15, position.row > -1 else {
			return false
		}

		guard position.col < 15, position.col > -1 else {
			return false
		}

		return true
	}

	//is the pos empty?
	func isPositionEmpty(_ position:Position) -> Bool {
		return (grid[position.row][position.col] == nil)
	}

	//is the tank dead?
	func isDead(_ gameObject:GameObject) -> Bool {
		if gameObject.energy <= 0 {
			return true
		}
		return false
	}

	//given array of GO, return array w/ same objects but randomized.
	func randomizeGameObjects<T:GameObject>(gameObjects: [T]) -> [T] {
		return []
	}

	//finds GO's within radius
	func findGameObjectsWithinRange(_ position:Position, range:Int) -> [Position] {
		return []
	}

	//return an array of all GO's
	func findAllGameObjects() -> [GameObject] {
		return grid.joined().compactMap {$0}
	}

	//find all tanks
	func findAllTanks() -> [Tank] {
		let GOs = findAllGameObjects()
		let tanks = GOs.filter{$0.objectType == .Tank}
		return tanks as! [Tank]
	}

	//find all ROVERS
	func findAllRovers() -> [Mine] {
		let GOs = findAllGameObjects()
		let rovers = GOs.filter{$0.objectType == .Rover}
		return rovers as! [Mine]
	}

	//return grid loc. ajacent which is empty
	func findFreeAjacent(_ position:Position) -> Position? {
		return nil
	}

	//return pos offset from x
	func makeOffsetPosition(position:Position, offsetRow:Int, offsetCol:Int) -> Position? {
		return Position(row:offsetRow - position.row, col: offsetCol - position.col)
	}

	//return all positions ajacent, within grid
	func getLegalSurroundingPositions(_ position:Position) -> [Position] {
		let row = position.row
		let col = position.col
		var cellsToCheck = [(row-1,col-1), (row-1, col), (row-1, col+1), (row, col-1), (row, col+1), (row+1,col-1), (row+1, col), (row+1, col+1)]

		/*

		0 1 2 + + r
		3 x 4 + +
		5 6 7 + +
		+ + + + +
		+ + + + +
		c
		*/

		//for edge cases (puns reeeeee)
		if row == 0 { //for top row
			cellsToCheck.remove(at: 0)
			cellsToCheck.remove(at: 0) //the index change when remove
			cellsToCheck.remove(at: 0)

			if col == 0 { //top left corner
				cellsToCheck.remove(at: 0)
				cellsToCheck.remove(at: 1)
			} else if col == 14 { //top right corner
				cellsToCheck.remove(at: 1)
				cellsToCheck.remove(at: 3)
			}
		} else if row == 14 { //bottom row
			cellsToCheck.remove(at: 5)
			cellsToCheck.remove(at: 5)
			cellsToCheck.remove(at: 5)

			if col == 0 { //bottom left corner
				cellsToCheck.remove(at: 0)
				cellsToCheck.remove(at: 2)
			} else if col == 14 { //bottom right corner
				cellsToCheck.remove(at: 2)
				cellsToCheck.remove(at: 3)
			}
		} else if col == 0 { //left col
			cellsToCheck.remove(at: 0)
			cellsToCheck.remove(at: 2)
			cellsToCheck.remove(at: 3)
		} else if col == 14 { //right col
			cellsToCheck.remove(at: 2)
			cellsToCheck.remove(at: 3)
			cellsToCheck.remove(at: 5)
		}

		//take the array of cells and convert to positions
		var converted = [Position]()
		for i in cellsToCheck {
			converted.append([i.0, i.1])
		}
		return converted
	}

	//return rand direction
	func getRandomDirection() -> Direction {
		let random = Int.random(in: 0..<8)//get a random int between [0,8)
		return Direction(rawValue: random)! //creates a random direction using the rawValue, called via auto-generated constructor (just ask sheen why)
	}

	//checks to see if a GO has enough energy
	func isEnergyAvailable(_ gameObject:GameObject, amount:Int) -> Bool {
		return (gameObject.energy >= amount) ? true : false
	}

	//finds if winner
	func findWinner() -> Tank? {
		let GOs = findAllTanks()
		if GOs.count == 1 {
			return GOs[1]
		} else {
			return nil
		}
	}

	//calc the distance between locations
	func distance(_ p1:Position, _ p2:Position) -> Int {
		let deltarow = p2.row - p1.row
		let deltacol = p2.col - p1.col
<<<<<<< HEAD
		return Int(sqrt( Double(deltarow * deltarow + deltacol * deltacol)))
=======
		return Int(Double(deltarow * deltarow + deltacol * deltacol).squareRoot())
>>>>>>> 77951d95e6d94664537c3f3dbf1c3976f0587849
	}
}
