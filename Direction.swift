/*
*	This will be just for Direction.
*	Used in the movement function, where the direction is specified and the function returns the Position
*/

enum Direction:Int { //we make int, so we can get a random via rawvalue later on.
	case North = 1, South, East, West, NorthEast, NorthWest, SouthEast, SouthWest //we only have to explicitly do first, rest are implicit.
}
