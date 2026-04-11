extends Node
class_name DocumentManager

var passport: Passport
var ticket: Ticket

var doc_spawn_markers

func _ready() -> void:
	doc_spawn_markers = get_tree().get_nodes_in_group("DocSpawn") as Array[Marker3D]

func register_docs(passport_ref: Passport, ticket_ref: Ticket):
	passport = passport_ref
	ticket = ticket_ref

func spawn_documents(npc_data: Dictionary):
	spawn_passport(npc_data, doc_spawn_markers[0].global_position, doc_spawn_markers[1].global_position)
	spawn_ticket(npc_data, doc_spawn_markers[0].global_position, doc_spawn_markers[1].global_position)


#region spawn functions

func spawn_ticket(npc_data: Dictionary, spawn_position: Vector3, slide_pos: Vector3):
	ticket.visible = true
	ticket.global_position = spawn_position
	ticket.scale = Vector3(0.4, 0.4, 0.4)
	ticket._addName(npc_data["name"] + " " + npc_data["surname"], Global.airport_city, npc_data["flight_destination"], str(Global.current_day) + ".04.2026", "AC 123", "12:00")
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(ticket, "global_position", slide_pos, 0.5)

func spawn_passport(npc_data: Dictionary, spawn_position: Vector3, slide_pos: Vector3):
	passport.global_position = spawn_position
	passport.visible = true
	passport.fill_passport(npc_data["name"], npc_data["surname"], npc_data["country_code"], npc_data["gender"], npc_data["country"], false)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(passport, "global_position", slide_pos, 0.5)

#endregion

#region despawn functions

func despawn_documents():
	despawn_passport()
	despawn_ticket()

func despawn_ticket():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(ticket, "global_position", doc_spawn_markers[0].global_position, 0.3)
	tween.finished.connect(func(): ticket.visible = false)

func despawn_passport():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(passport, "global_position", doc_spawn_markers[0].global_position, 0.3)
	tween.finished.connect(func(): passport.visible = false)

#endregion
