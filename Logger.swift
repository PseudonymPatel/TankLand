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
	var log: String

	init() {
		self.log = ""
	}

	// ------------------------
	//	Methods
	// ------------------------

	//adds a line to the log
	//the game object is the subject
	//@param gameobject the game object subject
	//@param restOfLog the String after the subject
	mutating func addlog( gameobject: GameObjects, restOfLog: String) {
		self.log += gameobject.id + " " + restOfLog + "\n"
	}


	//Difference between addLog and addMajorLog not known yet

	mutating func addMajorLog(gameobject: GameObjects, restOfLog: String) {
		self.log += gameobject.id + " " + restOfLog + "\n" 
	}
}
