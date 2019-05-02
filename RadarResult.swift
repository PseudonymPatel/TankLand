/*
*	This file is solely for RadarResult struct
*	Basically a mini-GO
*
*/

struct RadarResult {
	//properties
	let position:Position
	let id:String
	let energy:Int

	//Initializer
	init(position:Position, id:String, energy:Int) {
		self.position = position
		self.id = id
		self.energy = energy
	}
}
