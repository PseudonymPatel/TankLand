/*
*	This file is for the Mine and Rover GameObjectTypes
*	Mine and Rover will be one class,
*	with a isRover property
*/

class Mine:GameObject {

	// ------------------------------------
	// Properties
	// ------------------------------------

	//is this a rover (can it move?)
	var isRover:Bool

	//rover movement type
	let roverMovementType:String?

	//if rover moves in fixed direction, which direction
	let roverMovementDirection:Direction?

	// ----------------------------------
	// Initializers
	// ----------------------------------

	//for both, the rover is optional param.
	init(row:Int, col:Int, objectType:GameObjectType, energy:Int, id:String, isRover:Bool, roverMovementType:String?, roverMovementDirection:Direction?) {
		self.isRover = isRover
		if isRover {
			self.roverMovementType = roverMovementType
			self.roverMovementDirection = roverMovementDirection
		} else {
			self.roverMovementType = nil
			self.roverMovementDirection = nil
		}
		super.init(row:row, col:col, objectType:objectType, energy:energy, id:id)
	}

	// -----------------------------------
	// Methods
	// -----------------------------------

	//returns the force of explosion
	func explode() -> Int {
		return Constants.mineStrikeMultiple * self.energy
	}
}
