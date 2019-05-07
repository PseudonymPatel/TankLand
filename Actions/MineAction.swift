//mineAction

struct MineAction:PostAction {
	let action:Actions
	let direction:Direction
	let energy:Int
	var description:String {
		return "\(action) \(direction) \(energy)"
	}

	init(direction:Direction, energy:Int) {
		self.direction = direction
		self.energy = energy
	}
}
