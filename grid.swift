/*
*	This file is for everything having to do with the presentation of the game board.
*	Included here is the code for drawing the grid, and all classes and helper functions related.
*
*	** Grid Class **
*	*Also a override for the * operator
*/
class Grid {

	// ---------------------------------------------------------
	//Properties
	// ---------------------------------------------------------
	
	//you may set this to true if you would like all the boxes to have a coordinate in it. 
	private let coordsInEveryBox:Bool = false
	//Height and width of the grid - amount of elements per row/col
	private let GRID_HEIGHT:Int = 15
	private let GRID_WIDTH:Int = 15

	//sets the spacing required inside each box.
	private let HORIZONTAL_SPACING:Int = 8 //this must be greater than 5
	private let VERTICAL_SPACING:Int = 4 //this must be greater than 0, if less than 2, some info will be removed to fit.

	//all characters required to create the grid
	//for a list of characters go to: https://jrgraphix.net/r/Unicode/2500-257F
	private let TOP_LEFT_CORNER:String = "\u{2554}"
	private let TOP_RIGHT_CORNER:String = "\u{2557}"
	private let BOTTOM_LEFT_CORNER:String = "\u{255A}"
	private let BOTTOM_RIGHT_CORNER:String = "\u{255D}"

	private let TOP_EDGE:String = "\u{2550}"
	private let TOP_EDGE_INTERSECTION:String = "\u{2566}"
	private let BOTTOM_EDGE:String = "\u{2550}"
	private let BOTTOM_EDGE_INTERSECTION:String = "\u{2569}"
	private let LEFT_EDGE:String = "\u{2551}"
	private let LEFT_EDGE_INTERSECTION:String = "\u{2560}"
	private let RIGHT_EDGE:String = "\u{2551}"
	private let RIGHT_EDGE_INTERSECTION:String = "\u{2563}"

	private let HORIZONTAL_POLE:String = "\u{2550}"
	private let VERTICAL_POLE:String = "\u{2551}"
	private let CENTER_INTERSECTION:String = "\u{256C}"

	//The grid, which can contain either nil or a GameObject
	private var grid:[[GameObject?]] = []

	// ---------------------------------------------------------
	// Initializers
	// ---------------------------------------------------------

	//Initializes the grid array with an empty array of predefined length and width.
	init() {
		grid = Array(repeating: Array(repeating: nil, count: GRID_WIDTH), count: GRID_HEIGHT)
	}

	// ---------------------------------------------------------
	// Accessor methods
	// ---------------------------------------------------------

	//@return height of grid
	func getGridHeight() -> Int {
		return GRID_HEIGHT
	}

	//@return width of grid
	func getGridWidth() -> Int {
		return GRID_WIDTH
	}

	//@return the grid, as an array.
	func getGrid() -> [[GameObject?]] {
		return grid
	}

	// ---------------------------------------------------------
	// Methods
	// ---------------------------------------------------------

	//Helper function to draw a single line
	//@param firstCharacter the character to display at the start of the line
	//@param line the character to use as the line itself, not any special intersection or whatnot
	//@param intersection the character to use at each place where grid lines intersect
	//@param lastCharacter the character to end the string with
	func drawLine(firstCharacter:String, line:String, intersection:String, lastCharacter:String) {
		//print the firstCharacter
		print(firstCharacter, terminator:"")
		
		//print the middle section, consisting of:
		//SPACING amount of characters, then a intersection
		for _ in 0..<GRID_WIDTH - 1 {
			print(line*HORIZONTAL_SPACING + intersection, terminator:"")
		}
		
		//for the last one, add a lastCharacter onto the end
		print(line*HORIZONTAL_SPACING + lastCharacter)
	}

	//Draws the grid to the terminal, with all GameObjects
	//PRECONDITION: the grid is of adequate size
	//Does not take in parameters or return anything.
	func displayGrid() {

		//iterates through each row,
		for row in 0..<GRID_HEIGHT {

			if row == 0 { //if top row, draw the top row
				drawLine(firstCharacter:TOP_LEFT_CORNER, line:TOP_EDGE, intersection:TOP_EDGE_INTERSECTION, lastCharacter:TOP_RIGHT_CORNER)
			} else { //draw the normal, center row
				drawLine(firstCharacter:LEFT_EDGE_INTERSECTION, line:HORIZONTAL_POLE, intersection:CENTER_INTERSECTION, lastCharacter:RIGHT_EDGE_INTERSECTION)
			}
			
			//this will contain each line, and will have VERTICAL_SPACING elements.
			var tempLines = [String]()
			//this is a temporary line, and will become an element in tempLines at the end of iteration
			var tempLine = ""
			
			//iterates through each of the lines in the row, storing each one in tempLines, to display after all are generated.
			for line in 0..<VERTICAL_SPACING {
				//depending on the line, we will show a different statistic:
				//0th line - health/energy
				//1st line - Name
				//2nd Line - ??
				
				//clears tempLine, to start a new line of information. At the end of this loop, it will be stored into tempLines
				tempLine = ""

				//iterates through each element in the row, creating the second line in the row
				for col in 0..<GRID_WIDTH {

					if col == 0 { //always start the line with a character, if first line, use the edge character.
						tempLine += LEFT_EDGE
					} else {
						tempLine += VERTICAL_POLE
					}
					
					//The switch statement decides which information to store on the line.
					// 0th line - shows health
					// 1st line - name
					// 2nd line - coordinates
					switch line {
						case 0: //display the health
							if let object = grid[row][col] {
								tempLine += (" "*(HORIZONTAL_SPACING - String(object.energy).count) + String(object.energy)) //the energy plus how ever many extra spaces are needed.
							} else {
								tempLine += (" "*HORIZONTAL_SPACING) //add blank space of right length
							}
						case 1://display name
							if let object = grid[row][col] {
								tempLine += (" " + object.name + " "*((HORIZONTAL_SPACING - 1) - object.name.count)) //the name plus how ever many extra spaces are needed.
							} else {
								tempLine += (" "*HORIZONTAL_SPACING)
							}
						case 2: //display the position on the grid
							if grid[row][col] != nil || coordsInEveryBox { //if there is an object, or we want coord in every box, then
								let coords = "(\(row),\(col))"
								tempLine += (" " + coords + " "*((HORIZONTAL_SPACING - 1) - coords.count))
							} else {
								tempLine += (" "*HORIZONTAL_SPACING) //just add blank spacing
							}
						default: //if it is not the first or second line, put blank spaces.
							tempLine += (" "*HORIZONTAL_SPACING)
					}
				
					if col == GRID_HEIGHT - 1 {
						tempLine += (RIGHT_EDGE) //this is the end of a line, so we need to put a final character
					}
				}

				//add the tempLine to the end of the array of tempLines.
				tempLines.append(tempLine)
			}
		
		//draw the VERTICAL_SPACING number lines that were just generated
		for i in tempLines {
			print(i) //because no line break is added to the end of the line, it is put in here using the print statement
		}
		
		}
	//finally, draw the bottom row stuff
	drawLine(firstCharacter:BOTTOM_LEFT_CORNER, line:BOTTOM_EDGE, intersection:BOTTOM_EDGE_INTERSECTION, lastCharacter:BOTTOM_RIGHT_CORNER)
	}
	//adds a new GameObject to the grid
	//PRECONDITION: the row and col are valid values.
	//@param object the object to add
	//@param row the row to add the object to
	//@param col the column to add the object to
	func addObject(_ object:GameObject, row:Int, col:Int) {
		grid[row][col] = object
	}
}

//This function makes it easier to repeat strings.
//@param left the string to repeat
//@param right the number of times to repeat the string 
func *(left:String, right:Int) -> String {
	return String(repeating:left, count:right)
}
