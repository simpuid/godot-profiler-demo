tool
extends Control

onready var cursor = get_node("./mouse_screen/cursor") as TextureRect

func get_debugger()->ScriptEditorDebugger:
	return EditorPlugin.new().get_editor_interface().get_debugger_node().get_profiler_scene_debugger(self)

func _enter_tree():
	var self_var = self	
	get_node("send_button").connect("button_down", Callable(self_var, "send_expression"))
	var debugger = get_debugger()
	if (debugger != null):
		if (debugger.has_capture("test_profiler")):
			debugger.unregister_message_capture("test_profiler")
		debugger.register_message_capture("test_profiler", Callable(self_var, "capture"))
		debugger.connect("session_toggle", Callable(self_var, "session_toggle"))

func _ready():
	session_toggle(false)
	pass

func _exit_tree():
	var debugger = get_debugger()
	if (debugger != null):
		if (debugger.has_capture("test_profiler")):
			debugger.unregister_message_capture("test_profiler")

func send_expression():
	var debugger = get_debugger()
	if (debugger != null):
		var text_edit: TextEdit = get_node("expression_input")
		debugger.send_message("test_profiler:execute", [text_edit.text])

func capture(msg:String, args:Array) -> bool:
	if (msg != "mouse_position"):
		return false
	var mouse_position = args[0] as Vector2
	cursor.anchor_left = mouse_position.x
	cursor.anchor_right = mouse_position.x
	cursor.anchor_top = mouse_position.y
	cursor.anchor_bottom = mouse_position.y
	return true

func session_toggle(value:bool):
	if (value):
		get_node("./mouse_screen").show()
		get_node("./mouse_screen/cursor").show()
		get_node("./send_button").show()
		get_node("./expression_input").show()
	else:
		get_node("./mouse_screen").hide()
		get_node("./mouse_screen/cursor").hide()
		get_node("./send_button").hide()
		get_node("./expression_input").hide()
		
