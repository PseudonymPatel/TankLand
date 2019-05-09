// For all the support functions to make life easier.

extension TankWorld {

	//given position, direction, mag, return new position -> vector math :(
	func newPosition(position:Position, direction:Direction, magnitude:Int) -> Position {

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

	}

	//finds GO's within radius
	func findGameObjectsWithinRange(_ position:Position, range:Int) -> [Position] {

	}

	//return an array of all GO's
	func findAllGameObjects() -> [GameObject] {
		return grid.joined().compactMap {$0}
	}

	//find all tanks
	func findAllTanks() -> [Tank] {
		let GOs = grid.joined().compactMap {$0}
		let tanks = [Tank]()
		for i in GOs {
			if i.objectType == .Tank {
				tanks.append(i)
			}
		}
		return tanks
	}

	//find all ROVERS
	func findAllRovers() -> [Mine] {

	}

	//return grid loc. ajacent which is empty
	func findFreeAjacent(_ position:Position) -> Position? {

	}

	//return pos offset from x
	func makeOffsetPosition(position:Position, offsetRow:Int, offsetCol:Int) -> Position? {

	}

	//return all positions ajacent, within grid
	func getLegalSurroundingPositions(_ position:Position) -> [Position] {

	}

	//return rand direction
	func getRandomDirection() -> Direction {

	}

	//checks to see if a GO has enough energy
	func isEnergyAvailable(_ gameObject:GameObject, amount:Int) -> Bool {
		return (gameObject.energy >= amount) ? true : false
	}

	//finds if winner
	func findWinner() -> Tank? {

	}

	//calc the distance between locations
	func distance(_ p1:Position, _ p2:Position) -> Int {

	}
}
