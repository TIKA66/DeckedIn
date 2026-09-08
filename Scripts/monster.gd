extends Node2D

var available_monsters: Array = []

func _ready() -> void:
	create_monster_stack()
	print(available_monsters)


func create_monster(
	monster_name: String,
	type: String,
	attack: int,
	health: int,
	gold: int,
	dragon: bool,
	chance: float,
	sprite
) -> Dictionary:
	return {
		"name": monster_name,
		"type": type,
		"attack": attack,
		"health": health,
		"gold": gold,
		"dragon": dragon,
		"chance": chance,
		"sprite": sprite
	}

func add_monster(monster_name: String, type: String, attack: int, health: int, gold: int, dragon: bool, chance: float, amount: int, sprite) -> void:
	for i in range(amount): # FOR LOOP: Repeats a block of code for each value in a collection or range.
		var monster := create_monster(monster_name, type, attack, health, gold, dragon, chance, sprite) # Uses the create_card function to initialise the card design to then add to the deck
		available_monsters.append(monster) # Adds the card to the available monsters pile

#add multiple monsters to available_monsters
func create_monster_stack():
	add_monster("Spider", "monster", 1, 1, 2, false, 0.1, 3, 1)
	add_monster("Goblin", "monster", 1, 2, 3, false, 0.1, 2, 1)
	add_monster("Mimic", "monster", 2, 3, 5, false, 0.1, 3, 1)
	print("available monsters: ", available_monsters)

#DIUES THIS NEED MORE???? JUST CHECK IF THERES SOMETHING IN THERE, AND IF IT EXISTS
#maybe need to check first instance because other room smight return true??? testing thing
func select_monster():
	if Map.map[$"..".player_position]["monsters"] == true:
		fight_monster()

#WRITE FIGHTING
func fight_monster():
	pass

func _on_end_turn_pressed() -> void:
	$"../Card_System".player_turn = false
	#if player ended turn while a monster is still alive in current room
	if Map.map[$"../Movement".player_position]["monsters"]["health"] > 0:
		$"../Card_System".player_health -= Map.map[$"../Movement".player_position]["monsters"]["attack"]
		print("You have been attacked.")
