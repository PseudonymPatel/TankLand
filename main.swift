let testingObject = GameObject(name:"HI")
let tankLand = Grid()
tankLand.addObject(testingObject, row:2, col:3)
testingObject.hurt(9433)
tankLand.displayGrid()

print("\n\n\n\n")
