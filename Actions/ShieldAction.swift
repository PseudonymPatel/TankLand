//SheildAction

struct ShieldAction:PreAction {
	let action:Actions
	let energy:Int
	var description:String {
		return "\(action) \(energy)"
	}
	init(energy:Int) {
		self.action = .ShieldAction
		self.energy = energy
	}
}
