'''
Filename: map.gd
Version: 1.0
Purpose: To hold the map and room details.
Date: 6/9/2026
Author: Aikantika Banerjee & Elliot Slota
'''
# NODE: A basic building block of a Godot game. Nodes provide different types of functionality and can be organised together within a scene tree.
extends Node

# DICTIONARY: A collection of key-value pairs used to store related information. Each value is accessed using its corresponding key.
#MAP - creates the map as a dictionary and holds its contents.
var map:Dictionary = {
	1: {
		"room": 1,
		"type": "starting",
		"floor": 1,
		"adjacent_rooms": [2, 3],
		"movement_cost": 1,
		"monsters": null,
		"items": null
	},
	2: {
		"room": 2,
		"type": "nothing",
		"floor": 2,
		"adjacent_rooms": [1, 3, 4, 5],
		"movement_cost": 3,
		"monsters": null,
		"items": null
	},
	3: {
		"room": 3,
		"type": "monster",
		"floor": 2,
		"adjacent_rooms": [1, 2, 5, 6],
		"movement_cost": 1,
		"monsters": null,
		"items": null
		},
	4: {
		"room": 4,
		"type": "ending",
		"floor": 3,
		"adjacent_rooms": [2, 5],
		"movement_cost": 2,
		"monsters": null,
		"items": null
		},
	5: {
		"room": 5,
		"type": "monster",
		"floor": 3,
		"adjacent_rooms": [2, 3, 4, 6],
		"movement_cost": 1,
		"monsters": null,
		"items": null
		},
	6: {
		"room": 6,
		"type": "market",
		"floor": 3,
		"adjacent_rooms": [3, 5],
		"movement_cost": 1,
		"monsters": null,
		"items": null,
		"items_to_sell": null
		}
}
