// For all the support functions to make life easier.
import Foundation
extension TankWorld {

	//given position, direction, mag, return new position -> vector math :(
	func newPosition(position:Position, direction:Direction, magnitude:Int) -> Position {
		let originRow = position.row
		let originCol = position.col

		let componentRow:Int!
		let componentCol:Int!
		//get the components of the vector
		//MAKE MORE EFFECIENT/LESS CODE
		switch direction { //depending on direction, do different math.
			case .North:
				componentRow = 0
				componentCol = magnitude
			case .South:
				componentRow = 0
				componentCol = -magnitude
			case .East:
				componentRow = magnitude
				componentCol = 0
			case .West:
				componentRow = -magnitude
				componentCol = 0
			case .NorthWest:
				componentRow = Int(sqrt(2)*Double(-magnitude))
				componentCol = Int(sqrt(2)*Double(magnitude))
			case .NorthEast:
				componentRow = Int(sqrt(2)*Double(magnitude))
				componentCol = Int(sqrt(2)*Double(magnitude))
			case .SouthEast:
				componentRow = Int(sqrt(2)*Double(magnitude))
				componentCol = Int(sqrt(2)*Double(-magnitude))
			case .SouthWest:
				componentRow = Int(sqrt(2)*Double(-magnitude))
				componentCol = Int(sqrt(2)*Double(-magnitude))
		}

		return [componentRow + originRow, originCol + componentCol]
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
		let allObj = findAllGameObjects() as! [T]

		var newObj = [T]()

		for _ in 0..<allObj.count {
			let rand = Int.random(in: 0..<allObj.count - newObj.count)
			newObj.append(allObj[rand])
		}

		return newObj
	}

	//finds GO's within radius
	func findGameObjectsWithinRange(_ position:Position, range:Int) -> [Position] {
		return findAllGameObjects().filter { distance($0.position, position) <= range }.map { $0.position }
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
		var surroundingPos = getLegalSurroundingPositions(position)
		surroundingPos = surroundingPos.filter {isPositionEmpty($0)}

		if surroundingPos.count <= 0 {
			return nil
		}

		let rand = Int.random(in: 0..<surroundingPos.count)
		return surroundingPos[rand]
	}

	//return pos offset from x
	func makeOffsetPosition(position:Position, offsetRow:Int, offsetCol:Int) -> Position? {
		return Position(row:offsetRow - position.row, col: offsetCol - position.col)
	}

	//return all positions ajacent, within grid
	func getLegalSurroundingPositions(_ position:Position) -> [Position] {
		let row = position.row
		let col = position.col
		let left = position.col - 1
		let right = position.col + 1
		let up = position.row - 1
		let down = position.row + 1
		var positions = [Position]()

		positions += [[up,left], [up, col], [up, right], [row,left], [row, right], [down, left], [down, col], [down, right]]
		return positions.filter{isValidPosition($0)}

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
		return Int(Double(deltarow * deltarow + deltacol * deltacol).squareRoot())
	}

	//assumes that you've done error checking
	func applyCost(_ tank:GameObject, amount:Int) {
		tank.useEnergy(amount:amount)
	}
}
