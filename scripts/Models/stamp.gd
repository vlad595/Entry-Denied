class_name Stamp
extends StaticBody3D

@export var camera: Camera3D
@export var colisionShape: CollisionShape3D
@onready var timer = $Timer
@onready var stamp_head: MeshInstance3D = $Stamp
@onready var stampArea: Area3D = $Area3D

var isDragging: bool = false
var mouseOnTheStamp = false
var isPressed = false

var stampOnTheDoc: bool = false
var doc: Node3D

var touch_pos: Vector2

func _ready() -> void:
	self.mouse_entered.connect(_on_stamp_area_mouse_entered)
	self.mouse_exited.connect(_on_stamp_area_mouse_exited)
	self.input_event.connect(_stamp_clicked)

	timer.wait_time = 0.1
	timer.timeout.connect(func(): stamp_head.position.y = 0.11)

	stampArea.area_entered.connect(_stamp_on_paper)
	stampArea.area_exited.connect(_stamp_exited_doc)

func _on_stamp_area_mouse_entered():
	mouseOnTheStamp = true

func _on_stamp_area_mouse_exited():
	mouseOnTheStamp = false

func _stamp_clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	if event is InputEventScreenTouch:
		if event.is_pressed() and !Global.isPlayerBusy:
			touch_pos = event.position
			isPressed = true
			print("-----------------------------------")

func _input(event: InputEvent) -> void:	
	if event is InputEventScreenDrag and isPressed:
		if not isDragging:
			if touch_pos.distance_to(event.position) > 10:
				isDragging = true
				start_dragging()

		if isDragging:

			var draggaing_plane = Plane(Vector3.UP, self.global_position.y)
			
			var ray_origin = camera.project_ray_origin(event.position / 3)
			var ray_normal = camera.project_ray_normal(event.position / 3)

			var intersection = draggaing_plane.intersects_ray(ray_origin, ray_normal)

			if intersection:
				self.global_position.x = clamp(intersection.x, -3.5, 9.0)
				self.global_position.z = clamp(intersection.z, 0.5, 5.0)

	if event is InputEventScreenTouch:
		if event.is_released() and isPressed:
			if !isDragging:
				perform_click()
			else:
				end_dragging()
			isDragging = false
			isPressed = false


func start_dragging():
	self.position.y += 0.2
	self.rotation_degrees.x -= 20
	self.rotation_degrees.z += 10
	Global.isPlayerBusy = true

func end_dragging():
	self.position.y -= 0.2
	self.rotation_degrees.x += 20
	self.rotation_degrees.z -= 10
	get_tree().create_timer(0.1).timeout.connect(func(): Global.isPlayerBusy = false)

func perform_click():
	print(self.name + " was clicked")
	stamp_head.position.y = -0.122
	var mark: Sprite3D = Sprite3D.new()
	mark.texture = preload("res://assets/textures/Approved_Denied.png")
	mark.hframes = 1
	mark.vframes = 2
	if (self.name == "Green_stamp"):
		mark.frame = 0
	else: mark.frame = 1
	mark.name = "mark"
	if stampOnTheDoc:
		doc.add_child(mark)
		mark.layers = 2
		mark.scale = Vector3(1.3, 1.3, 1.3)
		mark.rotation_degrees = Vector3(0, 0, 180)
		mark.global_position = Vector3(self.global_position.x, doc.global_position.y, self.global_position.z)
		mark.render_priority = 1
	else: 
		get_tree().current_scene.add_child(mark)
		mark.rotation_degrees = Vector3(-90, 0, 0)
		mark.scale = Vector3(0.5, 0.5, 0.5)
		mark.global_position = Vector3(self.global_position.x, 5.035, self.global_position.z)
	timer.start()

func _stamp_on_paper(area: Area3D):
	if area is Document or area is Passport:
		stampOnTheDoc = true
		doc = area
		print("Stamp above the doc " + str(area.name))

func _stamp_exited_doc(area: Area3D):
	if area == doc:
		stampOnTheDoc = false
		doc = null
