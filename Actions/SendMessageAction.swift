//SendMessageAction Class

class SendMessageAction: PostAction {
	let action: Actions
	let id: String
	let message: String

	init(id: String, message: String) {
		self.action = .SendMessageAction
	}

	var description: String {
		return "\(action) \(id) \(direction)"
	}
}
