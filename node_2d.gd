extends Node2D

func _ready() -> void:
	$NavigationRegion2D.navigation_polygon = load("res://navi.tres")
	$NavigationRegion2D.bake_navigation_polygon()
