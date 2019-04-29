/*
*	This file contains only the TankWorld class. 
*
*
*/

class TankWorld {
	
	// -------------------------------------
	// Properties
	// -------------------------------------
	
	//an instance of Grid.
	let grid:Grid = Grid()


	// -------------------------------------
	// Initializer
	// -------------------------------------
	init() {
		//does nothing, yet!
	}


	// -------------------------------------
	// Methods
	// -------------------------------------

	//adds an object to the grid.
	//uses the position stored in the object as the inital position.
	//assumes that all positions are valid
	func addObject(_ object:GameObject) {
		grid.addObject(object)
	}

	//moves object to a Position
	func moveObject(_ object:GameObject, toPosition:Position) {
		grid.moveObject(object, toRow:toPosition.row, toCol:toPosition.col)

		//will need to check for prexisting object and act accordingly - meppydc
	}

	//exactly what it sounds like
	func displayGrid() {
		grid.displayGrid()
	}
}
