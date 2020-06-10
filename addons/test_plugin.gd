tool
extends EditorPlugin

func _enter_tree():
	get_editor_interface().get_debugger_node().register_profiler_scene("test_profiler", preload("res://addons/test_plugin_gui.tscn"))
	add_autoload_singleton("remote_profiler", "res://addons/remote_profiler.gd")
	pass

func _exit_tree():
	get_editor_interface().get_debugger_node().unregister_profiler_scene("test_profiler")
	remove_autoload_singleton("remote_profiler")
	pass


