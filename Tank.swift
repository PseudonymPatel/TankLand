/*
*	This file is for creating the base Tank Object,
*	Inherits from GameObject
*
*/

class Tank:GameObject {

	// ------------------------------------
	// Properties
	// ------------------------------------

	//amount shields
	var shields:Int = 0

	//will store the results of a radar scan
	var radarResults:[RadarResult]?

	//a recieved message stored here
	var receivedMessage:String?

	//the preActions set by the tank that TankWorld will read.
	var preActions = [Actions:PreAction]()

	//the PostActions set by tank the TankWorld will read.
	var postActions = [Actions:PostAction]()

	//?? For giving the tank a first move
	let initialInstructions:String?


	// ------------------------------------
	// Initializer
	// ------------------------------------

	init(row:Int, col:Int, name:String, energy:Int, id:String, instructions:String) {
		self.initialInstructions = initialInstructions
		super.init(row:row, col:col, objectType:.Tank, name:name, energy, energy, id:id)
	}


	// -----------------------------------
	// final funcs
	// -----------------------------------

	//clears all the actions, only TANKWORLD calls this!!
	final func clearActions() {
		preActions = [Actions:PreAction]()
		postAction = [Actions:PostAction]()
	}

	//recieves a message from the MessageCenter
	final func receiveMessage(message:String?) {
		receivedMessage = message
	}

	//adds an action to the array of PreActions
	final func addPreActions(preAction:PreAction) {
		preActions[preAction.action] = preAction
	}

	//adds an action to the array of PostActions
	final func addPostAction(postAction:PostAction) {
		postActions[postAction.action] = postAction
	}

	final func setShields(amount:Int) {
		shields = amount
	}

	final func setRadarResult(radarResults:[RadarResult]?) {
		self.radarResults = radarResults
	}

	final func setReceivedMessage(receivedMessage:String!) {
		self.receivedMessage = receivedMessage
	}

	// ----------------------------------
	// funcs to override
	// ----------------------------------

	//override this func for the specific tank logic
	func computePreActions() {
		//this should call addPreAction
		print("This should not be created as an instance!")
	}

	//override this func for specific tank postAction logic
	func computePostActions() {
		//this should call addPostAction
		print("This should not be created as an instance!")
	}
}
