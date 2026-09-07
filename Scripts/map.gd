'''
Filename: map.gd
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
		"floor": 1,
		"adjacent_rooms": [2, 3],
		"movement_cost": 1,
		"monsters": [],
		"items": []
	},
	2: {
		"room": 2,
		"type": "nothing",
		"floor": 2,
		"adjacent_rooms": [1, 3, 4, 5],
		"movement_cost": 3,
		"monsters": [],
		"items": []
	},
	3: {
		"room": 3,
		"type": "monster",
		"floor": 2,
		"adjacent_rooms": [1, 2, 5, 6],
		"movement_cost": 1,
		"monsters": [],
		"items": []
		},
	4: {
		"room": 4,
		"type": "ending",
		"floor": 3,
		"adjacent_rooms": [2, 5],
		"movement_cost": 2,
		"monsters": [],
		"items": []
		},
	5: {
		"room": 5,
		"type": "monster",
		"floor": 3,
		"adjacent_rooms": [2, 3, 4, 6],
		"movement_cost": 1,
		"monsters": [],
		"items": []
		},
	6: {
		"room": 6,
		"type": "market",
		"floor": 3,
		"adjacent_rooms": [3, 5],
		"movement_cost": 1,
		"monsters": [],
		"items": [],
		"items_to_sell": ["Fountain", ""]
		}
}

#CONSIDER CHANGING THE FORMAT TO THIS???
#6: [6, "market", [3, 5], 1, [], []]
