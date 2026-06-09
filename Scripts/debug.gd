class_name Debug
extends Node

const debugMode = true

static func print(text : String):
	if debugMode:
		print(text)
