@tool
extends EditorDebuggerPlugin

func _enter_tree():
	# Captures all messages starting with "test_plugin:"
	register_message_capture("test_plugin", Callable(self, &"capture"))
	add_child(preload("res://addons/debugger_plugin_gui.tscn").instance())
	get_node("./module/send_button").connect("button_down", Callable(self, &"send_expression"))
	connect("breaked", Callable(self, &"breaked"))
	connect("stopped", Callable(self, &"stopped"))
	connect("started", Callable(self, &"started"))
	connect("continued", Callable(self, &"continued"))

# Removes the capture
func _exit_tree():
	unregister_message_capture("test_plugin")

# Sends the code for execution
func send_expression():
	send_message("test_plugin:execute", [get_node("./module/expression_input").text])

# Position the cursor sprite according to received data
func capture(msg:String, args:Array) -> bool:
	if (msg != "mouse_position"):
		return false
	var cursor = get_node("./module/mouse_screen/cursor") as TextureRect
	var mouse_position = args[0] as Vector2
	cursor.anchor_left = mouse_position.x
	cursor.anchor_right = mouse_position.x
	cursor.anchor_top = mouse_position.y
	cursor.anchor_bottom = mouse_position.y
	return true

# Debugging started
func started():
	print("started")

# Debugging stopped
func stopped():
	print("stopped")

# Debugging breaked
func breaked(can_debug):
	print("breaked")
	print(can_debug)

# Debugging continued after a break
func continued():
	print("continued")
