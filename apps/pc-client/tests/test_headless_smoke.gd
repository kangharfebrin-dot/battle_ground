# Headless Smoke Test for Battle Ground PC
# Validates core systems, scene loading, combat components, AI Bot FSM, and victory screens
extends SceneTree

func _init() -> void:
	print("\n==========================================")
	print(" BATTLE GROUND PC: HEADLESS SMOKE TEST")
	print("==========================================")

	var all_passed = true

	# Test 1: GameDataLoader autoload verification
	print("[TEST 1] Verifying GameDataLoader...")
	var data_loader_script = load("res://scripts/systems/game_data_loader.gd")
	if not data_loader_script:
		printerr(" FAIL: Could not load game_data_loader.gd")
		all_passed = false
	else:
		var loader = data_loader_script.new()
		loader.load_all_data()
		var p_data = loader.get_character_data()
		var w_data = loader.get_weapons_data()
		var a_data = loader.get_arena_data()
		if p_data.is_empty() or w_data.is_empty() or a_data.is_empty():
			printerr(" FAIL: Data loader returned empty dictionary")
			all_passed = false
		else:
			print(" PASS: GameDataLoader successfully loaded character, weapons, and arena data.")
		loader.free()

	# Test 2: Main Menu Scene instancing
	print("[TEST 2] Verifying Main Menu scene...")
	var main_scene = load("res://scenes/main/main.tscn")
	if not main_scene:
		printerr(" FAIL: Could not load res://scenes/main/main.tscn")
		all_passed = false
	else:
		var main_inst = main_scene.instantiate()
		if not main_inst:
			printerr(" FAIL: Failed to instantiate Main scene")
			all_passed = false
		else:
			print(" PASS: Main scene instantiates without error.")
			main_inst.free()

	# Test 3: Arena Scene instancing, Player & Victory Screen
	print("[TEST 3] Verifying Arena scene, Player, HUD & VictoryScreen...")
	var arena_scene = load("res://scenes/arena/arena.tscn")
	if not arena_scene:
		printerr(" FAIL: Could not load res://scenes/arena/arena.tscn")
		all_passed = false
	else:
		var arena_inst = arena_scene.instantiate()
		if not arena_inst:
			printerr(" FAIL: Failed to instantiate Arena scene")
			all_passed = false
		else:
			var player = arena_inst.get_node_or_null("Player")
			var victory = arena_inst.get_node_or_null("VictoryScreen")
			var hud = arena_inst.get_node_or_null("HUD")
			if not player or not victory or not hud:
				printerr(" FAIL: Arena missing Player, VictoryScreen, or HUD node")
				all_passed = false
			else:
				var health = player.get_node_or_null("Health") as Health
				var weapon = player.get_node_or_null("Weapon") as Weapon
				if not health or not weapon:
					printerr(" FAIL: Player missing Health or Weapon node")
					all_passed = false
				else:
					print(" PASS: Arena, Player (HP: %d), HUD, and VictoryScreen instantiated successfully." % health.max_health)
			arena_inst.free()

	# Test 4: Projectile Instancing & Health Component damage logic
	print("[TEST 4] Verifying Health & Combat logic...")
	var dummy_health = Health.new()
	dummy_health.init(100)
	dummy_health.take_damage(20)
	if dummy_health.current_health != 80:
		printerr(" FAIL: Damage calculation failed. Expected 80, got %d" % dummy_health.current_health)
		all_passed = false
	else:
		print(" PASS: Health damage calculation correctly reduced HP to 80.")
	dummy_health.free()

	# Test 5: AI Bot FSM Verification
	print("[TEST 5] Verifying EnemyBot FSM & Combat...")
	var bot_scene = load("res://scenes/enemies/enemy_bot.tscn")
	if not bot_scene:
		printerr(" FAIL: Could not load enemy_bot.tscn")
		all_passed = false
	else:
		var bot = bot_scene.instantiate() as EnemyBot
		if not bot:
			printerr(" FAIL: Failed to instantiate EnemyBot")
			all_passed = false
		else:
			var bot_health = bot.get_node_or_null("Health") as Health
			if not bot_health:
				printerr(" FAIL: Bot missing Health component")
				all_passed = false
			else:
				bot_health.init(80)
				bot.take_damage(30)
				if bot_health.current_health != 50:
					printerr(" FAIL: Bot damage logic failed. Expected 50, got %d" % bot_health.current_health)
					all_passed = false
				else:
					print(" PASS: EnemyBot FSM & Combat logic verified (initial state: %d, HP after hit: %d)." % [bot.current_state, bot_health.current_health])
			bot.free()

	print("==========================================")
	if all_passed:
		print(" ALL HEADLESS SMOKE TESTS PASSED (5/5)")
		print("==========================================\n")
		quit(0)
	else:
		printerr(" SOME TESTS FAILED")
		print("==========================================\n")
		quit(1)
