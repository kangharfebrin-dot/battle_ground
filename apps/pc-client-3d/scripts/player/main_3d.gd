# Main 3D Orchestrator
# Connects player controller to HUD, manages world boundaries and gameplay session
class_name Main3D
extends Node3D

@onready var player: PlayerController3D = $SoldierCharacter
@onready var hud: HUD3D = $HUD3D

func _ready() -> void:
	if hud and player:
		hud.setup(player)

