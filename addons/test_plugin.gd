tool
extends EditorPlugin

func _enter_tree():
	# This will register the scene as profiler scene
	get_editor_interface().get_debugger_node().register_profiler_scene("test_profiler", preload("res://addons/test_plugin_gui.tscn"))
	# Registers an autoload that handles the Game side
	add_autoload_singleton("remote_profiler", "res://addons/remote_profiler.gd")
	pass

func _exit_tree():
	# This will unregister the scene
	get_editor_interface().get_debugger_node().unregister_profiler_scene("test_profiler")
	# Unregisters the autoload
	remove_autoload_singleton("remote_profiler")
	pass


