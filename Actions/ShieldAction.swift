//SheildAction

struct ShieldAction:PreAction {
	let action:Actions
	let power:Int
	var description:String {
		return "\(action) \(power)"
	}
	init(power:Int) {
		self.action = .Shields
		self.power = power
	}
}
