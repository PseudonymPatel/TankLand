//ReceiveMessageAction

struct ReceiveMessageAction:PreAction {
	let action:Actions
	let id:String
	var description:String {
		return "\(action) \(id)"
	}

	init(id:String) {
		self.action = .ReceiveMessage
		self.id = id
	}
}
