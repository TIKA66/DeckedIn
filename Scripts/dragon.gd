'''
Filename: dragon.gd
Version: 1.0
Purpose: To handle the dragons interactions with the player
Date: 4/9/2026
Author: Elliot Slota
'''

extends Node2D

@onready var dragon_attack:int = 1

func _ready() -> void:
	attack() # change to playerattack

# Attack's player
func attack():
	$".".player_health = $".".player_health - dragon_attack
	dragon_attack += 1
	#DEBUGGING print("dragon attack: ", dragon_attack)
