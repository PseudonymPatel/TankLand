/*
*	This file is for everything having to do with the organization of messages.
*	Included here is the code for message storage and all classes and helper functions related.
*
*	** MessageCenter Struct **
*
*/
struct MessageCenter {

	// ---------------------------------------------------------
	// Properties
	// ---------------------------------------------------------

	//contains all the messages
	private var messages:[String:String]


	// ---------------------------------------------------------
	// Initializers
	// ---------------------------------------------------------

	init() {
		messages = [String:String]()
	}

	// ---------------------------------------------------------
	// Methods
	// ---------------------------------------------------------

	//Helper function to add a message
	//@param id the identification of the message to store
	//@param message the message
	mutating func addMessage( id: String, message: String) {
		messages[id] = message
	}

	//Helper function to retrieve message
	//@param id the identification of the message to retrieve
	//@return message if exists or a default message
	func retrieveMessage( id: String) -> String{
		if let message = messages[id] {
			return message
		} else {
			return "The message with id \(id) doesn't exist."
		}
	}
}
