tool
extends EditorDebuggerModule

onready var cursor = get_node("./module/mouse_screen/cursor") as TextureRect

func _ready():
	pass

func _enter_tree():
	var self_var = self
	register_message_capture("test_profiler", Callable(self_var, "capture"))
	add_child(preload("res://addons/debugger_module_gui.tscn").instance())
	get_node("./module/send_button").connect("button_down", Callable(self_var, "send_expression"))

func _exit_tree():
	unregister_message_capture("test_profiler")

func send_expression():
	# Send the message to Game
	var text_edit: TextEdit = get_node("./module/expression_input")
	send_message("test_profiler:execute", [text_edit.text])

# Position the crosshair sprite according to received data
func capture(msg:String, args:Array) -> bool:
	if (msg != "mouse_position"):
		return false
	var mouse_position = args[0] as Vector2
	cursor.anchor_left = mouse_position.x
	cursor.anchor_right = mouse_position.x
	cursor.anchor_top = mouse_position.y
	cursor.anchor_bottom = mouse_position.y
	return true
