class_name NPC extends CharacterBody3D

@onready var mesh: Node3D = $mesh
@onready var animPlayer: AnimationPlayer = $mesh/AnimationPlayer
@export var baggage_scene: PackedScene

var targets_array: Array[Marker3D] = []
var current_target: int = 1

var npc_data: Dictionary

signal provide_docs(npc_data: Dictionary)
signal change_target

func _ready() -> void:
	Global.start_npc.connect(npc_start_walking)
	change_target.connect(walk)
	var result = DB.get_rand_name()
	npc_data["name"] = result["name"]
	npc_data["surname"] = DB.get_rand_surname()
	npc_data["country"] = result["country_name"]
	npc_data["country_code"] = result["country_code"]
	npc_data["gender"] = result["gender"]
	npc_data["flight_destination"] = DB.get_rand_flight()

func npc_start_walking():
	change_target.emit()

func walk():
	var distance_between = targets_array[current_target - 1].position.distance_to(targets_array[current_target].position)
	var tween = create_tween()
	tween.tween_property(self, "position", targets_array[current_target].position, distance_between / 8)
	animPlayer.play("Walk")
	tween.finished.connect(finished_target)

func finished_target():
	print("current npc pos: " + str(self.global_position))
	if current_target == targets_array.size() - 1:
		animPlayer.play("Idle")
		provide_docs.emit(npc_data)
		provide_all_documents() # to be deleted after testing
		return
	else:
		current_target += 1
		change_target.emit()

func provide_all_documents():
	var baggage_spawn_markers = get_tree().get_nodes_in_group("baggage_spawn") as Array[Marker3D]
	var baggage = baggage_scene.instantiate()
	get_tree().current_scene.add_child(baggage)
	baggage.position = baggage_spawn_markers[0].global_position
	baggage.animation(baggage_spawn_markers[1].global_position, 1.0)
