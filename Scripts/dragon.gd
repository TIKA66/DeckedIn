'''
Filename: dragon.gd
Version: 2.0
Purpose: To handle the dragon's interactions:
		attacking player and gaining attack.
Date: 8/9/2026
Author: Aikantika Banerjee & Elliot Slota
'''
# NODE: A basic building block of a Godot game. Nodes provide different types of functionality and can be organised together within a scene tree.
extends Node2D

# VARIABLE: Stores a value in memory under a named identifier. The value can be accessed & changed throughout the program.
var dragon_attack:int = 1

# FUNCTION: A reusable block of code that performs a specific task when it is called. Functions can accept parameters and return a value.
# ATTACK - attack the player with incremantally more damage each attacj
func attack():
	$".".player_health = $".".player_health - dragon_attack
	dragon_attack += 1
	#DEBUGGING print("dragon attack: ", dragon_attack)

#roll cards to tick dragon
