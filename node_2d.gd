extends Node2D

func _ready() -> void:
	$NavigationRegion2D.navigation_polygon = load("res://navi.tres")
