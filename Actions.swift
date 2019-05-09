/*
*	This file houses basic Action-related things.
*	Contains the enum of all Actions
*	Contains the PreAction and PostAction protocols
*
*/

enum Actions {
	case Move //the GO moves
	case Radar //Tank sends out radar
	case Shields //Tank creates shield
	case SendMessage //Tank sends message
	case ReceiveMessage //Tank receives action
	case DropMine //Tank creates mine
	case Missile //Tank sends a missile

}

protocol Action:CustomStringConvertible {
	var action:Actions {get}
	var description:String {get}
}

protocol PreAction:Action {

}

protocol PostAction:Action {

}
