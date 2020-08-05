@tool
extends EditorPlugin

var plugin_script = load("res://addons/debugger_plugin.gd")

func _enter_tree():
	# Add the debugger plugin that handles the Editor side
	add_debugger_plugin(plugin_script)
	add_autoload_singleton("remote_profiler", "res://addons/remote_profiler.gd")
	pass

func _exit_tree():
	# Remove the debugger plugin
	remove_debugger_plugin(plugin_script)
	remove_autoload_singleton("remote_profiler")
	pass
