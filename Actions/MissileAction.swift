/*
*	MissileAction
*
*/

struct MissileAction:PostAction {
	let action:Actions
	let power:Int
	let target:Position
	var description:String {
		return "\(action) \(power) \(target)"
	}

	init(power:Int, target:Position) {
		self.power = power
		self.target = target
		self.action = .Missile
	}
}
