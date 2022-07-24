extends Node2D

export(NodePath) var dialog_path : NodePath
onready var dialog : PassiveDialog = get_node(dialog_path)


# Called when the node enters the scene tree for the first time.
func _ready():
	dialog.connect("letter_typed", self, "_on_letter_played")


func _on_letter_played(letter):
	$LetterSoundBox.play_any()
