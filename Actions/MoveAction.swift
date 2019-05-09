/*
*
*	Only for the movement action
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
		self.action = .Move
		self.distance = distance
		self.direction = direction
	}
}
