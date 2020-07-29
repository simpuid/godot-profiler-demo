extends Control

func _enter_tree():
	var self_var = self
	Performance.add_custom_monitor("Hello/There", Callable(self_var, "monitor_call"), [1, 2])
	Performance.add_custom_monitor("", Callable(self_var, "monitor_call"), [1, 2])
	Performance.add_custom_monitor("General/Kenobi", Callable(self_var, "monitor_call"), [2, 3])
	Performance.add_custom_monitor("Multiple/First", Callable(self_var, "monitor_call"), [3, 4])
	Performance.add_custom_monitor("Multiple/Second", Callable(self_var, "monitor_call"), [4, 5])
	Performance.add_custom_monitor("Audio/BuiltinCategory", Callable(self_var, "monitor_call"), [5, 6])
	Performance.add_custom_monitor("Too/Much/Slashes/So it's in Custom", Callable(self_var, "monitor_call"), [6, 7])
	Performance.add_custom_monitor("No slash so it's in Custom", Callable(self_var, "monitor_call"), [7, 8])

func _exit_tree():
	Performance.remove_custom_monitor("Hello/There")
	Performance.remove_custom_monitor("")
	Performance.remove_custom_monitor("General/Kenobi")
	Performance.remove_custom_monitor("Multiple/First")
	Performance.remove_custom_monitor("Multiple/Second")
	Performance.remove_custom_monitor("Audio/BuiltinCategory")
	Performance.remove_custom_monitor("Too/Much/Slashes/So it's in Custom")
	Performance.remove_custom_monitor("No slash so it's in Custom")

func monitor_call(from, to) -> float:
	return rand_range(from, to)
