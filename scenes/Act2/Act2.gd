extends Node2D

export(NodePath) var wizard_dialog_path : NodePath
onready var wizard_dialog : PassiveDialog = get_node(wizard_dialog_path)

export(NodePath) var player_dialog_path : NodePath
onready var player_dialog : PassiveDialog = get_node(wizard_dialog_path)

var encounter_1 : bool = true
var encounter_2 : bool = false
var cursed : bool = false

func _ready():
	MusicPlayerManager.start("CurseBuildup")


func _drop_curse():
	MusicPlayerManager.start_no_blend("CurseOfColors")


func _on_Ground_body_entered(body):
	if body.is_in_group("player"):
		SignalBus.emit_signal("ground_type_changed", FootstepManager.GroundType.wood)


func _on_StartEncounter_start_encounter():
	if encounter_1:
		encounter_1 = false
		encounter_1()
	elif encounter_2:
		encounter_2 = false
		encounter_2()

func encounter_1():
	wizard_dialog.run_dialog_custom("I know what you seek.")
	yield(wizard_dialog, "dialog_completed")
	wizard_dialog.run_dialog_custom("You cannot have it.")
	yield(wizard_dialog, "dialog_completed")
	wizard_dialog.run_dialog_custom("Leave. Now.")
	yield(wizard_dialog, "dialog_completed")
	encounter_2 = true


func encounter_2():
	wizard_dialog.run_dialog_custom("I asked you to leave.")
	yield(wizard_dialog, "dialog_completed")
	wizard_dialog.run_dialog_custom("Your arrogance will be punished")
	yield(wizard_dialog, "dialog_completed")
	_drop_curse()
	wizard_dialog.run_dialog_custom("For this I grant you...")
	yield(wizard_dialog, "dialog_completed")
	wizard_dialog.run_dialog_custom("THE CURSE OF COLORS")
	yield(get_tree().create_timer(1), "timeout")
	_change_appearance()
	yield(wizard_dialog, "dialog_completed")
	wizard_dialog.run_dialog_custom("Hopefully this will teach you...")
	yield(wizard_dialog, "dialog_completed")
	wizard_dialog.run_dialog_custom("GO NOW")
	cursed = true
	yield(wizard_dialog, "dialog_completed")
	wizard_dialog.run_dialog_custom("I'm busy doing my taxes.")
	yield(wizard_dialog, "dialog_completed")



func _change_appearance():
	$Player/Sprite.visible = false
	$Player/cursed.visible = true


func _on_ToAct3_body_entered(body):
	if cursed and body.is_in_group("player"):
		Game.change_scene("res://scenes/Act3/Act3.tscn")
