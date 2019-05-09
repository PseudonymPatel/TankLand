//RadarAction

struct RadarAction:PreAction {
	let action:Actions
	let range:Int
	var description:String {
		return "\(action) \(range)"
	}

	init(range:Int) {
		self.range = range
		self.action = .Radar
	}
}
