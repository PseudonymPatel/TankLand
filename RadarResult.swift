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
	let objectType:GameObjectType
	//Initializer
	init(position:Position, id:String, energy:Int, objectType:GameObjectType) {
		self.position = position
		self.id = id
		self.energy = energy
		self.objectType = objectType
	}
}
