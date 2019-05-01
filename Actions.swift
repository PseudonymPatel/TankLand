/*
*	This file houses basic Action-related things.
*	Contains the enum of all Actions
*	Contains the PreAction and PostAction protocols
*
*/

enum Actions {
	case MoveAction //the GO moves
	case RadarAction //Tank sends out radar
	case ShieldAction //Tank creates shield
	case SendMessageAction //Tank sends message
	case ReceiveMessageAction //Tank receives action
	case MineAction //Tank creates mine
	case RoverAction //Tank creates Rover
	case MissleAction //Tank sends a missile

}

protocol Action:CustomStringConvertible {
	var action:Actions {get}
	var description:String {get}
}

protocol PreAction:Action {

}

protocol PostAction:Action {

}
