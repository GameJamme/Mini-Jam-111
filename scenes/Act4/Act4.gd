extends Node2D

export(NodePath) var dialog_path : NodePath
onready var dialog : PassiveDialog = get_node(dialog_path)


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(3), "timeout")
	dialog.run_dialog_custom("So this is it then")
	yield(dialog, "dialog_completed")
	dialog.run_dialog_custom("In my pursuit of power over the arts...")
	yield(dialog, "dialog_completed")
	dialog.run_dialog_custom("I lost everything...")
	yield(dialog, "dialog_completed")
	dialog.run_dialog_custom("I took everything...")
	yield(dialog, "dialog_completed")
	dialog.run_dialog_custom("I took... everything...")
	yield(dialog, "dialog_completed")
	dialog.run_dialog_custom("I still hunger")
	yield(dialog, "dialog_completed")
	dialog.run_dialog_custom("I became.. the enemy...")
	yield(dialog, "dialog_completed")
	Game.change_scene("res://scenes/menu/menu.tscn")
