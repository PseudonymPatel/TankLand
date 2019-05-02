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
	var log:String

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
	mutating func addlog(gameObject: GameObject, restOfLog: String) {
		self.log += gameObject.id + " " + restOfLog + "\n"
	}


	//Difference between addLog and addMajorLog not known yet

	mutating func addMajorLog(gameObject: GameObject, restOfLog: String) {
		self.log += gameObject.id + " " + restOfLog + "\n"
	}
}
