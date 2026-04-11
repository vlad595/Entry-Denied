extends Node

var db
var sqLite
var isUpdate: bool = true

func _ready() -> void:
	db = SQLite.new()
	setup_database()

func setup_database():
	var db_path = "user://gameDB_v0_1.db"
	var origin_path = "res://data/gameDB_v0_1.db"

	if not FileAccess.file_exists(db_path) || isUpdate:
		print("DB does not exist. Manual copying...")
		
		var file_access = FileAccess.open(origin_path, FileAccess.READ)
		if file_access:
			var buffer = file_access.get_buffer(file_access.get_length())
			file_access.close()
			
			var write_access = FileAccess.open(db_path, FileAccess.WRITE)
			if write_access:
				write_access.store_buffer(buffer)
				write_access.close()
				print("DB successfully copied manually!")
			else:
				printerr("Cannot write to user://")
		else:
			printerr("Cannot find source file")
	
	db.path = db_path
	db.open_db()

func get_rand_name():
	var query = "SELECT names_library.name, names_library.gender, countries.name AS country_name, countries.code AS country_code FROM names_library INNER JOIN countries ON names_library.country_id = countries.id ORDER BY RANDOM() LIMIT 1"
	var result =  db.query_with_bindings(query, [])

	if result:
		return db.query_result[0]
	else: printerr("name does not found")

func get_rand_surname():
	var query = "SELECT surname FROM surnames_library ORDER BY RANDOM() LIMIT 1"
	var result = db.query_with_bindings(query, [])

	if result:
		return db.query_result[0]["surname"]
	else: printerr("surname does not found")

func get_rand_flight():
	var query = "SELECT city FROM cities ORDER BY RANDOM() LIMIT 1"
	var result = db.query_with_bindings(query, [])

	if !result:
		printerr("	DB: flight does not found")
		return "Unknown city"
	
	return db.query_result[0]["city"]
