/*
*	SHEEN AND DION
*
*	We will just have two of OurTank.
*	These are the tank to submit.
*
*/

//so basically:
//runs a shield and radar every turn
//sends a missile to the closest tank (but not too close so we don't take damage)
//sends a rover north every 3rd turn.
//moves south, southEast, or SouthWest every turn.
class OurTank:Tank {

	var turnNum = 0

	func getRandomDirection(_ directions:[Direction]) -> Direction { //return random direction from list of directions.
		let randInt = Int.random(in: 0..<directions.count)
		return directions[randInt]
	}

	func distance(_ lhs:Position, _ rhs:Position) -> Int { //finds distance between two points.
		let deltarow = rhs.row - lhs.row
		let deltacol = rhs.col - lhs.col
		return Int(Double(deltarow * deltarow + deltacol * deltacol).squareRoot())
	}

	func sorter(_ lhs:RadarResult, _ rhs:RadarResult) -> Bool { //finds the object closer to this tank.
		return (distance(lhs.position, self.position) < distance(rhs.position, self.position))
	}

	override init(row:Int, col:Int, energy:Int, id:String, instructions:String) {
		super.init(row:row, col:col, energy:energy, id:id, instructions:instructions)
	}

	override func computePreActions() {
		addPreAction(preAction: ShieldAction(power:200)) //create a shield with 1600 health
		addPreAction(preAction: RadarAction(range: 5)) //run a radar with range 5
	}

	override func computePostActions() {
		addPostAction(postAction: MoveAction(distance:1, direction:getRandomDirection([.South, .SouthWest, .SouthEast])))

		//choose a location: find the closest tank far enough so we won't take damage.
		let result:RadarResult?

		if let radarResults = radarResults {
			let results = radarResults.sorted(by: { sorter($0, $1) })
			for pos in results {
				if distance(self.position, pos.position) >= 2 { //so we don't take damage
					result = pos
					break
				}
			}

			if let theresult = result { //if we found a good location...
				addPostAction(postAction: MissileAction(power:200, target:theresult.position))
			}
		}

		if turnNum % 3 == 0 { //every three turns, send a rover north.
			addPostAction(postAction:DropMineAction(power:200, isRover:true, dropDirection:.North, moveDirection:getRandomDirection([.North, .NorthEast, .NorthWest])))
		}
	}
}
