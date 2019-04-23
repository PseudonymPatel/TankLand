/*
*	This file will house all the GameObjects:
*	Tanks
*	Mines
*	Rovers
*	*Position Struct*
*
*/

//The class GameObject should be a superclass to all the possible objects on the TankLand grid
//Will house basic funcion declarations for polymorphism.
class GameObject:CustomStringConvertible {
	
	// ---------------------------------------------------------
	// Properties
	// ---------------------------------------------------------

	//Health/Energy of the GameObject
	var energy:Int
	//name that will be shown on grid
	let name:String
	//to keep track of the position of the GameObject
	var position:Position

	var description:String {
		return "\(self.name) at position \(position)"
	}

	// ---------------------------------------------------------
	// Initalizers
	// ---------------------------------------------------------
	init(name:String, energy:Int, position:Position) {
		self.energy = energy
		self.name = name
		self.position = position
	}

	init(name:String, position:Position) {
		self.energy = 10000
		self.name = name
		self.position = position
	}

	// ---------------------------------------------------------
	// Methods
	// ---------------------------------------------------------
	func hurt(_ energy:Int) {
		self.energy -= energy
	}
}

struct Position:ExpressibleByArrayLiteral, CustomStringConvertible {

	//Properties
	var row:Int
	var col:Int

	var description:String {
		return "(\(self.row), \(self.col))"
	}

	//Initalizers
	init(row:Int, col:Int) {
		self.row = row
		self.col = col
	}

	init(arrayLiteral: Int...) { //convinient init so i can do: Position(1, 3) or let pos:Position = [1, 3]
		assert(arrayLiteral.count == 2, "Must initialize Position with 2 values only!")
		self.row = arrayLiteral[0]
		self.col = arrayLiteral[1]
  	}
}
