//mineAction

struct DropMineAction:PostAction {
	let action:Actions
	let isRover:Bool
	let moveDirection:Direction?
	let dropDirection:Direction?
	let energy:Int
	var description:String {
		return "\(action) \(energy) \(String(describing:dropDirection)) \(isRover) \(String(describing:moveDirection))"
	}

	init(power:Int, isRover:Bool = false, dropDirection:Direction? = nil, moveDirection:Direction? = nil) {
		self.action = .DropMine
		self.isRover = isRover
		self.dropDirection = dropDirection
		self.moveDirection = moveDirection
		self.energy = power
	}
}
