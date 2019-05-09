//RadarAction

struct RadarAction:PreAction {
	let action:Actions
	let radius:Int
	var description:String {
		return "\(action) \(radius)"
	}

	init(radius:Int) {
		self.radius = radius
		self.action = .RadarAction
	}
}
