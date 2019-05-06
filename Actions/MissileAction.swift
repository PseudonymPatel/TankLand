/*
*	MissileAction
*
*/

struct MissileAction:PostAction {
	let action:Actios
	let target:Position
	let description:String {
		return "\(action) \(target)"
	}

	init(target:Position) {
		self.target = target
	}
}
