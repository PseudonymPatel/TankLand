//SendMessageAction Class

//using id

struct SendMessageAction: PostAction {
	let action: Actions
	let id: String
	let message: String
	var description:String {
		return "\(action) \(id) \(message)"
	}

	init(id: String, message: String) {
		self.action = .SendMessage
		self.id = id
		self.message = message
	}
}
