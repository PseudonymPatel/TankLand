/*
*	MissileAction
*
*/

struct MissileAction:PostAction {
	let action:Actios
	let target:Position
	var description:String {
		return "\(action) \(target)"
	}

	init(target:Position) {
		self.target = target
	}
}
