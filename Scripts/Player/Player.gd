extends CharacterBody3D
class_name Player

@onready var camera_rig = $CameraRig
@onready var anim_tree = $Model/AnimationTree
@onready var model = $Model

@export var blend_speed = 30

var run_val = 0.0

enum {DEMON, HUNTER, SWORD}
var currSoul = HUNTER

var soul_data = {
	DEMON: {
		"anim": "Demon",
		"blend": "parameters/Demon_Blend/blend_amount",
		"speed": 14.0
	},
	HUNTER: {
		"anim": "Hunter",
		"blend": "parameters/Hunter_Blend/blend_amount",
		"speed": 10.0
	},
	SWORD: {
		"anim": "Sword",
		"blend": "parameters/Sword_Blend/blend_amount",
		"speed": 6.0
	}
}

func update_anim_tree():
	var current_blend = soul_data[currSoul]["blend"]
	anim_tree[current_blend] = run_val
