# HUD Controller
# Displays vital in-game telemetry: HP, Ammo, Weapon, Match Timer, Score, Kill Feed, Crosshair, and Controls
class_name HUD
extends CanvasLayer

@onready var health_bar: ProgressBar = $RootMargin/VBoxTopLeft/HealthBar
@onready var health_label: Label = $RootMargin/VBoxTopLeft/HealthLabel
@onready var ammo_label: Label = $RootMargin/VBoxBottomRight/AmmoLabel
@onready var weapon_label: Label = $RootMargin/VBoxBottomRight/WeaponLabel
@onready var timer_label: Label = $RootMargin/TopCenter/TimerLabel
@onready var score_label: Label = $RootMargin/TopCenter/ScoreLabel
@onready var reload_indicator: Label = $RootMargin/VBoxBottomRight/ReloadIndicator
@onready var kill_feed_container: VBoxContainer = $RootMargin/KillFeedContainer
@onready var crosshair: Control = $Crosshair

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(_delta: float) -> void:
	if crosshair:
		crosshair.global_position = crosshair.get_global_mouse_position()

func setup(player: Player) -> void:
	if player:
		if player.health:
			player.health.health_changed.connect(_on_health_changed)
			_on_health_changed(player.health.current_health, player.health.max_health)

		if player.weapon:
			player.weapon.ammo_changed.connect(_on_ammo_changed)
			player.weapon.reload_started.connect(_on_reload_started)
			player.weapon.reload_finished.connect(_on_reload_finished)
			_on_ammo_changed(player.weapon.current_ammo, player.weapon.magazine_size)
			weapon_label.text = player.weapon.weapon_name.to_upper()

		player.weapon_switched.connect(_on_weapon_switched)

func _on_health_changed(current: int, max_hp: int) -> void:
	if health_bar:
		health_bar.max_value = max_hp
		health_bar.value = current
	if health_label:
		health_label.text = "HP: %d / %d" % [current, max_hp]

func _on_ammo_changed(current: int, max_clip: int) -> void:
	if ammo_label:
		ammo_label.text = "AMMO: %d / %d" % [current, max_clip]

func _on_reload_started(_duration: float) -> void:
	if reload_indicator:
		reload_indicator.visible = true

func _on_reload_finished() -> void:
	if reload_indicator:
		reload_indicator.visible = false

func _on_weapon_switched(weapon_id: String) -> void:
	if weapon_label:
		weapon_label.text = weapon_id.to_upper()

func update_score(score: int) -> void:
	if score_label:
		score_label.text = "SCORE: %d" % score

func update_timer(seconds_remaining: float) -> void:
	if timer_label:
		var mins = int(seconds_remaining) / 60
		var secs = int(seconds_remaining) % 60
		timer_label.text = "%02d:%02d" % [mins, secs]

func add_kill_feed(killer_name: String, victim_name: String) -> void:
	if not kill_feed_container:
		return

	var entry = Label.new()
	entry.text = "%s  [ELIMINATED]  %s" % [killer_name, victim_name]
	entry.add_theme_color_override("font_color", Color(1.0, 0.4, 0.4, 0.95))
	entry.add_theme_font_size_override("font_size", 13)
	kill_feed_container.add_child(entry)

	# Auto remove after 3.5 seconds
	var timer = get_tree().create_timer(3.5)
	timer.timeout.connect(func():
		if is_instance_valid(entry):
			entry.queue_free()
	)
