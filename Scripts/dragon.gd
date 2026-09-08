'''
Filename: dragon.gd
Version: 2.0
Purpose: To handle the dragon attacking the player.
Date: 8/9/2026
Author: Aikantika Banerjee & Elliot Slota
'''

extends Node2D

var dragon_attack:int = 1

# ATTACK - attack the player with incremantally more damage each attacj
func attack():
	$".".player_health = $".".player_health - dragon_attack
	dragon_attack += 1
	#DEBUGGING print("dragon attack: ", dragon_attack)

#roll cards to tick dragon
