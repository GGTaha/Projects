extends Control


var grid_pos : Vector2
var grid_coords : Vector2
var circle_node: Node2D
var cross_node: Node2D
var Winner : int
var player : int
var width : int
var cell_width : int
var offset : Vector2
var anywhere : bool
var next : int
var big : int
var small : int
var all : bool
var BoardWins : Array
var BoardPlacements : Array
var placed : Array
var dynamic_nodes : Array
var oldnext : String

func _ready():

	circle_node = get_node("Circle")
	cross_node = get_node("Cross")
	width = $MainBoard.texture.get_width()
	cell_width = width / 9
	offset = Vector2(cell_width / 2, cell_width / 2)
	new_game()

func UpdateWin():

	for i in range(9):
		BoardWins[i] = checkWin(BoardPlacements[i])
	if checkWin(BoardWins) != 0:
		Winner = checkWin(BoardWins)
		print("Winner : ", Winner)
		if Winner == 1:
			$GameEnd/AnimatedSprite.play("Circle")
		else:
			$GameEnd/AnimatedSprite.play("Cross")
		$GameEnd.show()

func _input(event):

	if event is InputEventMouseButton:
		
		if Winner == 0:
			if event.pressed and event.button_index == BUTTON_LEFT:  # Check for left mouse click
				grid_pos = event.position
				print(grid_pos)
				# Turn Pixels into Coordinates of Grid
				grid_pos.y = grid_pos.y - 100
				grid_pos = (grid_pos / cell_width)
				
				grid_coords.x = ceil(grid_pos.x)
				grid_coords.y = ceil(grid_pos.y)
				
				big = Big(grid_coords)
				small = small(grid_coords)
				
				if ValidMove():
					placement(big, small)
					highlightNext()
					
			UpdateWin()

func boards():
	BoardWins = [0,0,0,
				 0,0,0,
				 0,0,0]
	BoardPlacements = [
	[0,0,0,
	0,0,0,
	0,0,0],
	
	[0,0,0,
	0,0,0,
	0,0,0],
	
	[0,0,0,
	0,0,0,
	0,0,0],
	
	[0,0,0,
	0,0,0,
	0,0,0],
	
	[0,0,0,
	0,0,0,
	0,0,0],
	
	[0,0,0,
	0,0,0,
	0,0,0],
	
	[0,0,0,
	0,0,0,
	0,0,0],
	
	[0,0,0,
	0,0,0,
	0,0,0],
	
	[0,0,0,
	0,0,0,
	0,0,0]
	
	]
	placed = [0,0,0,0,0,0,0,0,0]

func Big(coord : Vector2):
	var Big : int
	if coord.y <= 3 and coord.x <= 3:  # Grid 1-3
		Big = 0
	elif coord.y <= 3 and coord.x <= 6:
		Big = 1
	elif coord.y <= 3 and coord.x <= 9:
		Big = 2
	
	if (coord.y <=6 and coord.y > 3) and coord.x <=3:
		Big = 3
	elif (coord.y <=6 and coord.y > 3) and coord.x <=6:
		Big = 4
	elif (coord.y <=6 and coord.y > 3) and coord.x <=9: 
		Big = 5
	
	if (coord.y <=9 and coord.y > 6) and coord.x <=3:
		Big = 6
	elif (coord.y <=9 and coord.y > 6) and coord.x <=6:
		Big = 7
	elif (coord.y <=9 and coord.y > 6) and coord.x <=9:
		Big = 8
	
	
	return Big

func small(vector: Vector2) -> int:
	match int(vector.x):
		1, 4, 7:
			match int(vector.y):
				1, 4, 7:
					return 0
				2, 5, 8:
					return 3
				3, 6, 9:
					return 6
		2, 5, 8:
			match int(vector.y):
				1, 4, 7:
					return 1
				2, 5, 8:
					return 4
				3, 6, 9:
					return 7
		3, 6, 9:
			match int(vector.y):
				1, 4, 7:
					return 2
				2, 5, 8:
					return 5
				3, 6, 9:
					return 8
	return 0 # Default case if none of the conditions are met

func checkWin(board):
	var winning_combinations = [
		[0, 1, 2],  # Top row
		[3, 4, 5],  # Middle row
		[6, 7, 8],  # Bottom row
		[0, 3, 6],  # Left column
		[1, 4, 7],  # Middle column
		[2, 5, 8],  # Right column
		[0, 4, 8],  # Diagonal from top-left
		[2, 4, 6]   # Diagonal from top-right
	]
	
	for combination in winning_combinations:
		var cell1 = board[combination[0]]
		var cell2 = board[combination[1]]
		var cell3 = board[combination[2]]
		if cell1 == cell2 && cell2 == cell3:
			if cell1 != 0:  # Check if cells are not empty
				return cell1  # Return the winner (1 or -1)
	return 0  # Return 0 if there is no winner yet
	
func placement(big, small):
	
	var animation_player = get_node("TopPanel/Turner")
	grid_coords.y += 1 # Return Coords to former Glory
	next = small

	if player ==  1: # Circle
		var new_circle = circle_node.duplicate()  # Create a copy of the circle
		add_child(new_circle)  # Add the copy to the scene
		dynamic_nodes.append(new_circle)
		new_circle.position = (grid_coords * 100) - offset# Position it based on grid coordinates
		print(grid_coords)
		BoardPlacements[big][small] = 1 # Places the Circle in Array
		player *= -1
		animation_player.play("Cross")

		
	else: # Cross
		var new_cross = cross_node.duplicate()  # Create a copy of the cross
		add_child(new_cross)  # Add the copy to the scene
		dynamic_nodes.append(new_cross)
		new_cross.position = (grid_coords * 100) - offset# Position it based on grid coordinates
		print(grid_coords)
		BoardPlacements[big][small] = -1 # Places the Cross in Array
		player *= -1
		animation_player.play("Circle")
		
		
	UpdateWin()
	bigMark()


	if BoardWins[small] != 0:
		anywhere = true
	else:
		anywhere = false

func ValidMove():
	if grid_pos.y >= 0 && grid_pos.y <= 900: # Check if Click is Within Bounds
		if BoardWins[big] == 0:
			if big == next or anywhere:
				if BoardPlacements[big][small] == 0:
					return true

func new_game():
	Winner = 0
	player = 1
	anywhere = true
	boards()
	$GameEnd.hide()	
	for node in dynamic_nodes:
		node.queue_free()
		
	dynamic_nodes.clear()
	oldnext = "9"
	for i in range(9):
		$MainBoard.get_node("Board" + str(i)).play("default")	
	
	var Turner = get_node("TopPanel/Turner")
	Turner.play("Circle")

func _on_Menu_start():
	new_game()

func bigMark():
	var BlueWin = Node2D
	var RedWin = Node2D
	BlueWin = get_node("BlueWin")
	RedWin = get_node("RedWin")
	var big_circle = BlueWin.duplicate()
	var big_cross = RedWin.duplicate()
	var big_pos = [Vector2(150, 250), Vector2(450,250), Vector2(750, 250), Vector2(150, 550), Vector2(450, 550), Vector2(750, 550), Vector2(150, 850), Vector2(450, 850), Vector2(750, 850)]

	
	for i in range(9):

		if placed[i] == 0:
			if BoardWins[i] == 1:

				add_child(big_circle)
				dynamic_nodes.append(big_circle)
				
				big_circle.position = big_pos[i]
				placed[i] = 1
				
			
			if BoardWins[i] == -1:
				add_child(big_cross)
				dynamic_nodes.append(big_cross)
				
				big_cross.position = big_pos[i]
				placed[i] = -1

func _on_GameEnd_back():
	$GameEnd.hide()

func _on_GameEnd_newGame():
	new_game()

func highlightNext():
	var highlight : Node2D
	var nextstr : String

	
	nextstr = str(next)
	if all:
		for i in range(9):
			$MainBoard.get_node("Board" + str(i)).play("default")	
	
	$MainBoard.get_node("Board" + oldnext).play("default")
	if anywhere != true:
		highlight = $MainBoard.get_node("Board" + nextstr)
		highlight.play("Next")
		oldnext = nextstr
	else:
		for i in range(9):
			$MainBoard.get_node("Board" + str(i)).play("Next")
			all = true


func _on_Restart_pressed():
	new_game()


func _on_ToMenu_pressed():
	get_tree().change_scene("res://Menu.tscn")
