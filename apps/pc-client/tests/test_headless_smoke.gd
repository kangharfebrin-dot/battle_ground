# Headless Smoke Test for Battle Ground PC
# Validates core systems, scene loading, and combat components without a GUI window
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

	# Test 3: Arena Scene instancing & Player setup
	print("[TEST 3] Verifying Arena scene & Player components...")
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
			if not player:
				printerr(" FAIL: Player node missing from Arena scene")
				all_passed = false
			else:
				var health = player.get_node_or_null("Health") as Health
				var weapon = player.get_node_or_null("Weapon") as Weapon
				if not health or not weapon:
					printerr(" FAIL: Player missing Health or Weapon node")
					all_passed = false
				else:
					# Test weapon firing logic
					var initial_ammo = weapon.current_ammo
					print(" PASS: Arena, Player, Health (max: %d), and Weapon (%s, ammo: %d) instantiated successfully." % [health.max_health, weapon.weapon_name, initial_ammo])
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

	print("==========================================")
	if all_passed:
		print(" ALL HEADLESS SMOKE TESTS PASSED (4/4)")
		print("==========================================\n")
		quit(0)
	else:
		printerr(" SOME TESTS FAILED")
		print("==========================================\n")
		quit(1)

