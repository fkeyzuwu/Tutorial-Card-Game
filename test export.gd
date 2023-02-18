@tool
extends Control

@export var stringy: String:
	set(value):
		print("export called")
		stringy = value
		$Label.text = value
