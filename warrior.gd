extends CharacterBody2D

class_name warrior
@export var max_hp: int = 100
@export var current_hp: int = max_hp
@export var level: int = 1
@export var max_xp: int
@export var current_xp: int = 0
@export var sprite: AnimatedSprite2D
@export var initiative: int = 0


func generate_initiative():
	self.initiative = randi_range(1, 20)


func _physics_process(delta: float) -> void:
	pass
