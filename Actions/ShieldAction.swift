//SheildAction

struct ShieldAction:PreAction {
	let action:Action
	let energy:Int
	var description:String {
		return "\(action) \(energy)"
	}
	init(energy:Int) {
		self.action = .ShieldAction
		self.energy = energy
	}
}
