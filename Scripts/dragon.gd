'''
Filename: dragon.gd
Version: 1.0
Date: 4/9/2026
Author: Elliot Slota
'''

extends Node2D

@onready var attack:int = 1

func _ready() -> void:
	Attack(5, attack)

# Attack's player
func Attack(playerHealth, dragonAttack):
	playerHealth -= dragonAttack
	dragonAttack += 1
	#DEBUGGING print("dragon.attack: ", dragonAttack)
	
