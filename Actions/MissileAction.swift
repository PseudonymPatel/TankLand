/*
*	MissileAction
*
*/

struct MissileAction:PostAction {
	let action:Actions
	let target:Position
	var description:String {
		return "\(action) \(target)"
	}

	init(target:Position) {
		self.target = target
		self.action = .MissileAction
	}
}
