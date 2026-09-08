'''
Filename: monster.gd
Version: 2.0
Purpose: To create and process monster interactions and spawning.
Date: 4/9/2026
Author: Aikantika Banerjee & Elliot Slota
'''

extends Node2D

var available_monsters: Array = [] # a list of monsters that can be spawned
var card_sprites: Array[TextureRect] = [] # sprites for monsters

func _ready() -> void:
	create_monster_stack() # create the available monsters
	
	print("VBoxContainer exists: ", has_node("VBoxContainer"))
	print("HBoxContainer exists: ", has_node("VBoxContainer/HBoxContainer"))
	
	card_sprites = [
		$VBoxContainer/HBoxContainer/Spider,
		$VBoxContainer/HBoxContainer/Goblin,
		$VBoxContainer/HBoxContainer/Mimic
	]
	
	for i in range(card_sprites.size()):
		print("Sprite ", i, ": ", card_sprites[i])
	#from init to go do whatever monster needs to go do
	print("Monsters ready.") # DEBUDDING STATEMENT FOR INTERNAL SYSTEM
	print("Created ", available_monsters.size(), " monsters.") # DEBUGGING STATEMENT FOR INTERNAL SYSTEM

# CREATE MONSTER - create the monster cards
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

#ADD MONSTER - add a given amount of monster cards to collection of monsters
func add_monster(monster_name: String, type: String, attack: int, health: int, gold: int, dragon: bool, chance: float, amount: int, sprite) -> void:
	for i in range(amount): # FOR LOOP: Repeats a block of code for each value in a collection or range.
		var monster := create_monster(monster_name, type, attack, health, gold, dragon, chance, sprite) # Uses the create_card function to initialise the card design to then add to the deck
		available_monsters.append(monster) # Adds the card to the available monsters pile

#CREATE MONSTER STACK - add multiple monsters to available_monsters
func create_monster_stack():
	add_monster("Spider", "monster", 1, 1, 2, false, 0.1, 3, $VBoxContainer/HBoxContainer/Spider/Spider)
	add_monster("Goblin", "monster", 1, 2, 3, false, 0.1, 2, $VBoxContainer/HBoxContainer/Goblin/Goblin)
	add_monster("Mimic", "monster", 2, 3, 5, false, 0.1, 3, $VBoxContainer/HBoxContainer/Mimic/Mimic)
	print("Available monsters created.") #DEBUGGING STATEMENT FOR INTERNAL

#DIUES THIS NEED MORE???? JUST CHECK IF THERES SOMETHING IN THERE, AND IF IT EXISTS
#maybe need to check first instance because other room smight return true??? testing thing
func select_monster():
	if Map.map[$"..".player_position]["monsters"] == true:
		fight_monster()

#WRITE FIGHTING
func fight_monster():
	pass
	# TIKA PLS ADD INPUT HERE FOR SELECTED MONSTER THANKS!!!
#	AND FOR ATTACK CONFIRMATOIN
#	variables here arent permanent just placeholders if u wanna change them
	#if selected_monster["health"] >0:
		#if attack_confirmation == true and $"../Card_System".player_attack > 0 and $"../Card_System".player_attack > selected_monster["health"]:
			#selected_monster["health"] -= $"../Card_System".player_attack
			#$"../Card_System".player_attack -= selected_monster["health"]
			#print("You attacked.")
		#elif $"../Card_System".player_attack < selected_monster["health"]:
			#print("You do not have enough attack.")
	#else:
		#selected_monster.queue_free()

#ON END TURN PRESSED - have a monster attack player back if they end turn in a room with a live monster
func _on_end_turn_pressed() -> void:
	$"../Card_System".player_turn = false #end the turn
	if Map.map[$"../Movement".player_position]["monsters"]: #check if monster exist in room with player
		var monster = Map.map[$"../Movement".player_position]["monsters"]
		if monster["health"] > 0: # if monster is alive then attack player
			$"../Card_System".player_health -= Map.map[$"../Movement".player_position]["monsters"]["attack"]
			print("You have been attacked.")
	$"../Card_System".start_turn() #start turn again once monster has been checked
