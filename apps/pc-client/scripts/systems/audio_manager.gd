# AudioManager (Autoload Singleton)
# Audio playback management with procedural fallbacks
extends Node

var _sfx_players: Array[AudioStreamPlayer] = []
var _music_player: AudioStreamPlayer

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.name = "MusicPlayer"
	_music_player.bus = "Master"
	add_child(_music_player)

	for i in range(8):
		var p = AudioStreamPlayer.new()
		p.name = "SFXPlayer_" + str(i)
		p.bus = "Master"
		add_child(p)
		_sfx_players.append(p)

func play_sfx(sound_name: String, pitch_scale: float = 1.0) -> void:
	var path = "res://assets/audio/" + sound_name + ".wav"
	if ResourceLoader.exists(path):
		var stream = load(path)
		_play_stream(stream, pitch_scale)
	else:
		# Fallback procedural blip or silent safe return
		_play_procedural_beep(sound_name, pitch_scale)

func _play_stream(stream: AudioStream, pitch: float) -> void:
	for p in _sfx_players:
		if not p.playing:
			p.stream = stream
			p.pitch_scale = pitch
			p.play()
			return
	# All busy, steal first player
	if _sfx_players.size() > 0:
		_sfx_players[0].stream = stream
		_sfx_players[0].pitch_scale = pitch
		_sfx_players[0].play()

func _play_procedural_beep(sound_name: String, pitch: float) -> void:
	# Generates a quick procedural tone so gameplay sounds exist even before custom audio assets
	var sample_hz = 22050.0
	var duration = 0.08
	var freq = 440.0
	if sound_name == "shoot":
		freq = 880.0
		duration = 0.06
	elif sound_name == "hit":
		freq = 320.0
		duration = 0.05
	elif sound_name == "reload":
		freq = 550.0
		duration = 0.1
	elif sound_name == "dash":
		freq = 660.0
		duration = 0.08

	var generator = AudioStreamGenerator.new()
	generator.mix_rate = sample_hz
	generator.buffer_length = duration + 0.05

	for p in _sfx_players:
		if not p.playing:
			p.stream = generator
			p.pitch_scale = pitch
			p.play()
			var playback = p.get_stream_playback() as AudioStreamGeneratorPlayback
			if playback:
				var total_frames = int(duration * sample_hz)
				var phase = 0.0
				var increment = (freq * TAU) / sample_hz
				for i in range(total_frames):
					var sample = sin(phase) * (1.0 - float(i) / total_frames) * 0.15
					playback.push_frame(Vector2(sample, sample))
					phase += increment
			return

