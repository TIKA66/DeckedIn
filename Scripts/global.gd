'''
Filename: global.gd
Version: 1.0
Purpose: To hold the map and other global variables that are used across multiple scripts
Date: 6/9/2026
Author: Elliot Slota
'''

extends Node

#MAP - creates the map as a dictionary, each number represents the room and has a dictionary of its properties inside
var map:Dictionary = {
	1: {
		"room": 1,
		"type": "starting",
		"adjacent_rooms": [2, 3],
		"movement_cost": 1,
		"monsters": [],
		"items": []
	},
	2: {
		"room": 2,
		"type": "nothing",
		"adjacent_rooms": [1, 3, 4, 5],
		"movement_cost": 3,
		"monsters": [],
		"items": []
	},
	3: {
		"room": 3,
		"type": "monster",
		"adjacent_rooms": [1, 2, 5, 6],
		"movement_cost": 1,
		"monsters": [],
		"items": []
		},
	4: {
		"room": 4,
		"type": "ending",
		"adjacent_rooms": [2, 5],
		"movement_cost": 2,
		"monsters": [],
		"items": []
		},
	5: {
		"room": 5,
		"type": "monster",
		"adjacent_rooms": [2, 3, 4, 6],
		"movement_cost": 1,
		"monsters": [],
		"items": []
		},
	6: {
		"room": 6,
		"type": "market",
		"adjacent_rooms": [3, 5],
		"movement_cost": 1,
		"monsters": [],
		"items": []
		}
}

#CONSIDER CHANGING THE FORMAT TO THIS???
#6: [6, "market", [3, 5], 1, [], []]
