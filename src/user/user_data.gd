extends Node

const PRIVACY_POLICY_LINK = ""
const COPYRIGHT_TEXT = """v0.0.0.0 -- March 12, 2023
Copyright © 2023 Jack Anderson"""
const SETTINGS_FILE = "user://settings.res"
# GAME STATE
var current_game_mode = 0
# SETTINGS
var mute_music = false
var mute_sound = false
# RECORDS
var current_year_loaded = 0
var current_month_loaded = 0
var current_record_loaded = {}
# INVENTORY
var au = 0
var max_au = 999999
var inventory = {}
var loadout = {}
var loadout_p2 = {}

func _ready() -> void:
	pass


func save_settings() -> void:
	print("attempting to save settings")
	var settings_dict = {
		"mute_music": mute_music,
		"mute_sound": mute_sound,
	}
	ResourceSaver.save(settings_dict, SETTINGS_FILE)

func load_settings() -> void:
	print("attempting to load settings")
	if not FileAccess.file_exists(SETTINGS_FILE):
		print("no settings file found")
		return
	var settings = ResourceLoader.load(SETTINGS_FILE)
	if settings.has("mute_music"):
		mute_music = settings.mute_music
	if settings.has("mute_sound"):
		mute_sound = settings.mute_sound
