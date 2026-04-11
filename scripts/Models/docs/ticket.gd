class_name Ticket extends Document


@onready var name_field: Label3D = $Name
@onready var from_field: Label3D= $From
@onready var dest_field: Label3D = $Destination
@onready var date_field: Label3D = $date
@onready var flight_field: Label3D = $flight
@onready var time_field: Label3D = $time

func _addName(name: String, from: String, destination: String, date: String, flightID: String, time: String):
	name_field.text = name
	from_field.text = from
	dest_field.text = destination
	date_field.text = date
	flight_field.text = flightID
	time_field.text = time
