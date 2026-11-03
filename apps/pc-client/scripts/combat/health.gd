# Health Component
# Reusable node for handling HP, damage calculation, and death events
class_name Health
extends Node

signal health_changed(current_health: int, max_health: int)
signal damaged(amount: int, source: Node)
signal healed(amount: int)
signal died()

@export var max_health: int = 100
var current_health: int = 100

func _ready() -> void:
	current_health = max_health

func init(new_max_health: int) -> void:
	max_health = new_max_health
	current_health = max_health
	health_changed.emit(current_health, max_health)

func take_damage(amount: int, source: Node = null) -> void:
	if current_health <= 0:
		return

	var actual_damage = mini(amount, current_health)
	current_health -= actual_damage
	damaged.emit(actual_damage, source)
	health_changed.emit(current_health, max_health)

	if current_health <= 0:
		died.emit()

func heal(amount: int) -> void:
	if current_health <= 0:
		return
	current_health = mini(current_health + amount, max_health)
	healed.emit(amount)
	health_changed.emit(current_health, max_health)

func reset() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)

func is_alive() -> bool:
	return current_health > 0

