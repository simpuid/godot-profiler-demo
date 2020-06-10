extends Node

onready var expression = Expression.new()
var mouse_position:Vector2
var mouse_position_modified:bool

func _enter_tree():
	var self_var = self
	EngineDebugger.register_message_capture("test_profiler", Callable(self_var, "capture"))
	EngineDebugger.register_profiler("test_profiler", Callable(self_var, "toggle"), Callable(self_var, "add"), Callable(self_var, "tick"))

func _exit_tree():
	EngineDebugger.unregister_message_capture("test_profiler")
	EngineDebugger.unregister_profiler("test_profiler")

func _ready():
	EngineDebugger.profiler_enable("test_profiler", true, [])

func capture(msg:String, args:Array) -> bool:
	if (msg != "execute"):
		return false
	var error = expression.parse(args[0] as String, [])
	if error != OK:
		print(expression.get_error_text())
		return true
	var result = expression.execute([], self, true)
	if expression.has_execute_failed():
		print("remote expression execution failed")
	return true

func test():
	print("testing")

func toggle(enable:bool, _args:Array):
	print("starting profiler" if enable else "stopping profiler")

func tick(_frame_time:float, _idle_time:float, _physics_time:float, _physics_frame_time:float):
	if (mouse_position_modified):
		EngineDebugger.send_message("test_profiler:mouse_position", [mouse_position])
		mouse_position_modified = false

func add(data:Array):
	if ((data.size() == 0) or !(data[0] is Vector2)):
		return
	mouse_position = Vector2(clamp(data[0].x, 0, 1), clamp(data[0].y, 0, 1))

func _input(event):
	if event is InputEventMouseMotion:
		EngineDebugger.profiler_add_frame_data("test_profiler", [event.position / get_viewport().get_visible_rect().size])
		mouse_position_modified = true
