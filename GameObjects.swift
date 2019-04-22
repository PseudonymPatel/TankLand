/*
*	This file will house all the GameObjects:
*	Tanks
*	Mines
*	Rovers
*
*
*/

//The class GameObject should be a superclass to all the possible objects on the TankLand grid
//Will house basic funcion declarations for polymorphism.
class GameObject {
	
	// ---------------------------------------------------------
	// Properties
	// ---------------------------------------------------------

	//Health/Energy of the GameObject
	var energy:Int
	let name:String

	// ---------------------------------------------------------
	// Initalizers
	// ---------------------------------------------------------
	init(energy:Int, name:String) {
		self.energy = energy
		self.name = name
	}

	init(name:String) {
		self.energy = 10000
		self.name = name
	}

	// ---------------------------------------------------------
	// Methods
	// ---------------------------------------------------------
	func hurt(_ energy:Int) {
		self.energy -= energy
	}
}
