/*
*	This file will house the GameObject class and :
*	GameObjectType
*	
*
*/

//this is a list of all the types of GameObject
enum GameObjectType {
	case Tank
	case Mine //we will do Mine and Rover separately
	case Rover
}

//The class GameObject should be a superclass to all the possible objects on the TankLand grid
//Will house basic funcion declarations for polymorphism.
class GameObject:CustomStringConvertible {

	// ---------------------------------------------------------
	// Properties
	// ---------------------------------------------------------

	//what type is this class?
	let objectType:GameObjectType
	//Health/Energy of the GameObject
	private (set) var energy:Int
	//name that will be shown on grid
	let name:String
	//required - so tanks do not interfere
	let id:String
	//the GO needs to know it's pos so it can do logic
	private (set) var position:Position

	var description:String {
		return "\(self.objectType) \(self.name) \(self.energy) \(self.id) \(self.position)"
	}

	// ---------------------------------------------------------
	// Initalizers
	// ---------------------------------------------------------
	init(row:Int, col:Int, objectType:GameObjectType, name:String, energy:Int, id:String) {
		self.energy = energy
		self.name = name
		self.position = [row, col]
		self.id = id
		self.objectType = objectType
	}

	// ---------------------------------------------------------
	// Methods
	// ---------------------------------------------------------
	//uses final for the functions that cannot be changed later

	final func addEnergy(amount:Int) {
		energy += amount
	}

	final func useEnergy(amount:Int) {
		energy = (amount > energy) ? 0 : energy-amount
	}

	final func setPosition(newPosition:Position) {
		position = newPosition
	}

}
