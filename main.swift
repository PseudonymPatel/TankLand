print("If the last line is not: \"End of program\", something has gone wrong with repl.it, refresh page and rerun a couple times")

//following example handout!
let testingObject = GameObject(name:"J1", position:[5,6])
let obj2 = GameObject(name:"J2", energy:9000, position:[6,6])
let obj3 = GameObject(name:"J3", energy:8000, position:[7,5])
let obj4 = GameObject(name:"J4", energy:7000, position:[10,3]) //oh no wrong position. move it later!!
let tankLand = TankWorld()

tankLand.addObject(testingObject)
tankLand.addObject(obj2)
tankLand.addObject(obj3)
tankLand.addObject(obj4)
tankLand.displayGrid() //J4 is at wrong pos! 

print("Oh no, J4 is wrong, moving it!!\n")

tankLand.moveObject(obj4, toPosition:[12, 3])
tankLand.displayGrid() //now display the correct one!

print("\n")
print("End of program")
