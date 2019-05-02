/*
*
*	Only for the movment action
*
*/

struct MoveAction:PostAction {
	let action:Actions
	let distance:Int
	let direction:Direction
	var description:String {
		return "\(action) \(distance) \(direction)"
	}

	init(distance:Int, direction:Direction) {
		action = .MoveAction
		self.distance = distance
		self.direction = direction
	}
}
