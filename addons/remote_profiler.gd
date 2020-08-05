extends Node

@onready var expression = Expression.new()
var mouse_position:Vector2
var mouse_position_modified:bool

func _enter_tree():
	# Registers the capture function to recieve all messages starting with "test_profiler:"
	EngineDebugger.register_message_capture("test_plugin", Callable(self, &"capture"))
	# Registers the profiler with three callables toggle, add, tick
	EngineDebugger.register_profiler("test_profiler", Callable(self, &"toggle"), Callable(self, &"add"), Callable(self, &"tick"))

func _exit_tree():
	# Unregisters the capture
	EngineDebugger.unregister_message_capture("test_plugin")
	# Unregisters the profiler
	EngineDebugger.unregister_profiler("test_profiler")

func _ready():
	# Starts the profiler on game start. Tick will be called on this profiler at every profiler iteration
	EngineDebugger.profiler_enable("test_profiler", true, [])


# Received message is executed as an Expression
func capture(msg:String, args:Array) -> bool:
	if (msg != "execute"):
		return false
	var error = expression.parse(args[0] as String, [])
	if error != OK:
		print(expression.get_error_text())
		return true
	expression.execute([], self, true)
	if expression.has_execute_failed():
		print("remote execution failed")
	return true

# Called when profiler is enabled/disabled
func toggle(enable:bool, _args:Array):
	print("starting profiler" if enable else "stopping profiler")

# Called at every profiler iteration if profiler is enabled
func tick(_frame_time:float, _idle_time:float, _physics_time:float, _physics_frame_time:float):
	if (mouse_position_modified):
		# Sending mouse position
		EngineDebugger.send_message("test_plugin:mouse_position", [mouse_position])
		mouse_position_modified = false

# Called when EngineDebugger.profiler_add_frame_data is called by other function
func add(data:Array):
	if ((data.size() == 0) or !(data[0] is Vector2)):
		return
	var new_position = Vector2(clamp(data[0].x, 0, 1), clamp(data[0].y, 0, 1))
	if new_position != mouse_position:
		mouse_position_modified = true
	mouse_position = new_position

# We are passing normalized mouse position to add function
func _input(event):
	if event is InputEventMouseMotion:
		EngineDebugger.profiler_add_frame_data("test_profiler", [event.position / get_viewport().get_visible_rect().size])
