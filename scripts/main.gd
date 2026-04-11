extends Node3D

@export var npc_scene: PackedScene

@export var passport_scene: PackedScene
@export var ticket_scene: PackedScene

var arr: Array = []
var npc_targ_arr: Array[Marker3D] = []

func new_day():
	Global.current_time_hours = 7
	Global.current_time_minutes = 0
	var npc = npc_scene.instantiate()
	if npc != null:
		npc.provide_docs.connect(docManager.spawn_documents)
		npc.targets_array = npc_targ_arr
		arr.push_front(npc)
	else: print("Zalupa")

func _ready() -> void:
	
	var npc_targ_buff = get_tree().get_nodes_in_group("npc_targets")
	for target in npc_targ_buff:
		npc_targ_arr.append(target)
	
	if npc_targ_arr:
		print("target array filled with targets" + str(npc_targ_arr.size()))
	else: print("target array is null")

	new_day()
	for i in range(arr.size()):
		arr[i].global_position = npc_targ_arr.front().position
		$SubViewportContainer/SubViewport.add_child(arr[i])
		Global.start_npc.emit()
	spawn_docs()
	
func spawn_docs():
	var passport = passport_scene.instantiate()
	get_tree().current_scene.add_child(passport)
	passport.visible = false

	var ticket = ticket_scene.instantiate()
	get_tree().current_scene.add_child(ticket)
	ticket.visible = false

	docManager.register_docs(passport, ticket)
	
