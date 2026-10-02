extends Node

var escaped := false
var seen_escape_message := false

func reset() -> void:
	escaped = false
	seen_escape_message = false
