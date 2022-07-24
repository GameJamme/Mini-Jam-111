extends Node2D


export(NodePath) var emitting_node_path
export(NodePath) var listening_node_path
onready var emitting_node = get_node(emitting_node_path)
onready var listening_node = get_node(listening_node_path)

export(String) var signal_name
export(String) var function_name

# Called when the node enters the scene tree for the first time.
func _ready():
	emitting_node.connect(signal_name, listening_node, function_name)

