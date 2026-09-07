extends Node2D

func create_monster(
	monster_name: String,
	type: String,
	attack: int,
	health: int,
	gold: int,
	dragon: bool,
	chance: float
) -> Dictionary:
	return {
		"name": monster_name,
		"type": type,
		"attack": attack,
		"health": health,
		"gold": gold,
		"dragon": dragon,
		"chance": chance
	}

func add_monster(monster_name: String, type: String, attack: int, health: int, gold: int, dragon: bool, chance: float, amount: int) -> void:
	for i in range(amount): # FOR LOOP: Repeats a block of code for each value in a collection or range.
		var monster := create_monster(monster_name, type, attack, health, gold, dragon, chance) # Uses the create_card function to initialise the card design to then add to the deck
		$Rooms.available_monsters.append(monster) # Adds the card to the available monsters list

#add multiple monsters to available_monsters
func create_monster_stack():
	add_monster("Spider", "monster", 1, 1, 2, false, 0.1, 3)
	add_monster("Goblin", "monster", 1, 2, 3, false, 0.1, 2)
	add_monster("Mimic", "monster", 2, 3, 5, false, 0.1, 3)
	print("available monsters: ", $Rooms.available_monsters)

func select_monster(monster_index: int) -> bool:
	# Check that selected monster exists
	if monster_index < 0 or monster_index >= $Rooms.available_monsters.size():
		print("Invalid monster selection.")
		return false
	var selected_monster: Dictionary = $Rooms.available_monsters[monster_index]
	if selected_monster["health"] == 0:
		print("This monster has been killed already.")
		return false
	return true
