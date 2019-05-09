// For all the support functions to make life easier.

extension TankWorld {

	//is the tank dead?
	func isDead(_ gameObject:GameObject) -> Bool {
		if gameObject.energy <= 0 {
			return true
		}
		return false
	}

	//checks to see if a GO has enough energy
	func isEnergyAvailable(_ gameObject:GameObject, amount:Int) -> Bool {
		return (gameObject.energy >= amount) ? true : false
	}

}
