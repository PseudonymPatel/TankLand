//rover action

struct RoverAction:PostAction {
	let action:Actions
	let direction:Direction
	let energy:Int
	let movementMode:Direction? //if null, use random
	var description:String {
		return "\(action) \(direction) \(energy) \(String(describing:movementMode))"
	}

	init(direction:Direction, energy:Int, movementMode:Direction) {
		self.action = .RoverAction
		self.direction = direction
		self.energy = energy
		self.movementMode = movementMode
	}
}
