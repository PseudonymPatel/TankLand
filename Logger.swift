/*
*	Logger struct
*
*	Keeps track of game actions
*/

struct Logger {

	// ------------------------
	//	Properties
	// ------------------------

	//keeps track of all actions and
	//the index of the log represents what turn number
	var log = [String]()

	//keeps track of which turn is happening
	var turn: Int

	// ------------------------
	// Initializer
	// ------------------------

	init() {
		//starts the log with Turn 0
		self.log = ["*****Turn 0*****\n"]
		self.turn = 0
	}

	// ------------------------
	//	Methods
	// ------------------------


	func getTurnLog() -> String {
		return self.log[self.turn]
	}

	//moves turn forward and starts a new turn
	mutating func nextTurn() {
		self.turn += 1
		self.log.append("*****Turn \(turn) *****\n")
	}

	//adds a line to the log for a turn
	//the game object is the subject
	//@param gameobject the game object subject
	//@param restOfLog the String after the subject
	mutating func addLog(_ gameobject: GameObject,_  restOfLog: String) {
		self.log[self.turn] += ("    " + gameobject.id + " " + restOfLog + "\n")
	}

	mutating func addLog(_ log:String) {
		self.log[self.turn] += (log + "\n")
	}
	//same as addLog except the message is marked with ** to represent imporant
	mutating func addMajorLog(_ gameobject: GameObject, _ restOfLog: String) {
		self.log[self.turn] += "****" + gameobject.id + " " + restOfLog + "\n"
	}
}
