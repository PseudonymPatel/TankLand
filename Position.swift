/*
*	Position struct
*
*
*/

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
