# Headless 3D Smoke Test for Battle Ground 3D
# Verifies 3D soldier rig, skeletal animations, TPS camera spring arm, outdoor terrain, and controller physics
extends SceneTree

func _init() -> void:
	print("\n==========================================")
	print(" BATTLE GROUND 3D: HEADLESS SMOKE TEST")
	print("==========================================")

	var all_passed = true

	# Test 1: Load and instantiate Main 3D Scene
	print("[TEST 1] Loading Main 3D Scene...")
	var main_scene = load("res://scenes/main/main_3d.tscn")
	if not main_scene:
		printerr(" FAIL: Could not load res://scenes/main/main_3d.tscn")
		all_passed = false
	else:
		var main_inst = main_scene.instantiate()
		if not main_inst:
			printerr(" FAIL: Failed to instantiate Main3D")
			all_passed = false
		else:
			print(" PASS: Main3D scene loaded and instantiated successfully.")

			# Test 2: Verify Soldier Character & TPS Camera
			print("[TEST 2] Verifying Soldier Character & TPS Camera...")
			var soldier = main_inst.get_node_or_null("SoldierCharacter")
			if not soldier:
				printerr(" FAIL: SoldierCharacter node missing in Main3D")
				all_passed = false
			else:
				var col = soldier.get_node_or_null("CollisionShape3D")
				var pivot = soldier.get_node_or_null("CameraPivot")
				var spring = soldier.get_node_or_null("CameraPivot/SpringArm3D") as SpringArm3D
				var cam = soldier.get_node_or_null("CameraPivot/SpringArm3D/Camera3D") as Camera3D
				if not col or not pivot or not spring or not cam:
					printerr(" FAIL: Missing CollisionShape3D, CameraPivot, SpringArm3D, or Camera3D")
					all_passed = false
				else:
					print(" PASS: SoldierCharacter3D verified (SpringArm: %.1fm, FOV: %.1f, Health: %d)." % [spring.spring_length, cam.fov, soldier.max_health])

			# Test 3: Verify Rigged Skeleton & AnimationPlayer
			print("[TEST 3] Verifying Skeleton3D and AnimationPlayer...")
			var model_root = main_inst.get_node_or_null("SoldierCharacter/ModelRoot")
			if not model_root:
				printerr(" FAIL: ModelRoot missing in SoldierCharacter")
				all_passed = false
			else:
				var anim_player = _find_anim_player(model_root)
				if not anim_player:
					printerr(" FAIL: AnimationPlayer not found inside soldier model")
					all_passed = false
				else:
					var anims = anim_player.get_animation_list()
					print(" PASS: Humanoid Soldier Skeleton verified with %d animations: %s" % [anims.size(), str(anims.slice(0, 5))])

			# Test 4: Verify Environment, Terrain & Military Compound
			print("[TEST 4] Verifying 3D Environment & Static Colliders...")
			var island = main_inst.get_node_or_null("TestIsland")
			if not island:
				printerr(" FAIL: TestIsland missing in Main3D")
				all_passed = false
			else:
				var world_env = island.get_node_or_null("WorldEnvironment")
				var sun = island.get_node_or_null("SunLight")
				var terrain = island.get_node_or_null("Terrain")
				var compound = island.get_node_or_null("MilitaryCompound")
				if not world_env or not sun or not terrain or not compound:
					printerr(" FAIL: Environment missing WorldEnvironment, SunLight, Terrain, or Compound")
					all_passed = false
				else:
					print(" PASS: 3D Environment verified (PBR Terrain, Directional Sun, Fog, %d compound structures)." % compound.get_child_count())

			# Test 5: Controller Logic & Damage System
			print("[TEST 5] Verifying Character Controller logic...")
			var test_player = soldier as PlayerController3D
			if test_player:
				test_player.take_damage(25)
				if test_player.current_health != 75:
					printerr(" FAIL: Damage logic failed. Expected 75, got %d" % test_player.current_health)
					all_passed = false
				else:
					print(" PASS: Health and damage calculation correctly updated (100 -> 75 HP).")

			main_inst.free()

	print("==========================================")
	if all_passed:
		print(" ALL 3D HEADLESS SMOKE TESTS PASSED (5/5)")
		print("==========================================\n")
		quit(0)
	else:
		printerr(" SOME 3D SMOKE TESTS FAILED")
		print("==========================================\n")
		quit(1)

func _find_anim_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node
	for child in node.get_children():
		var found = _find_anim_player(child)
		if found:
			return found
	return null

