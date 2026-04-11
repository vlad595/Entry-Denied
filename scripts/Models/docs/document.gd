extends Area3D
class_name Document

@onready var camera: Camera3D

var isPressed: bool = false
var isDragging: bool = false
var touchPos: Vector2
var drag_offset: Vector3

var start_drag_pos: Vector2
var end_drag_pos: Vector2

func _ready() -> void:
	self.input_event.connect(ticket_click)

	camera = get_tree().get_nodes_in_group("Camera")[0]

#region movement

func ticket_click(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	if event is InputEventScreenTouch:
		if event.is_pressed() and !Global.isPlayerBusy:
			isPressed = true
			touchPos = event.position
			drag_offset = self.global_position - event_position

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag and isPressed:
		if !isDragging:
			if touchPos.distance_to(event.position) > 10:
				isDragging = true
				start_drag_pos.x = self.global_position.x
				start_drag_pos.y = self.global_position.z
				self.global_position.y += 0.1
				Global.isPlayerBusy = true
		if isDragging:
			var dragPlane = Plane(Vector3.UP, self.global_position)
			var ray_origin = camera.project_ray_origin(event.position / 3)
			var ray_normal = camera.project_ray_normal(event.position / 3)

			var intersection = dragPlane.intersects_ray(ray_origin, ray_normal)

			if intersection:
				self.global_position.x = clamp(intersection.x + drag_offset.x, -1.5, 8)
				self.global_position.z = clamp(intersection.z + drag_offset.z, 1.318, 4.283)

	if event is InputEventScreenTouch:
		if event.is_released() and isPressed:
			if isDragging:
				end_drag_pos.x = self.global_position.x
				end_drag_pos.y = self.global_position.z
				isDragging = false
				isPressed = false
				check_apply()
				get_tree().create_timer(0.1).timeout.connect(func(): Global.isPlayerBusy = false)
				self.global_position.y -= 0.1
			elif !isDragging:
				perform_click()
				isDragging = false
				isPressed = false

#endregion

func check_apply():
	var children_list = get_children()
	var mark = children_list[children_list.size() - 1]
	var direction = start_drag_pos.direction_to(end_drag_pos)
	if mark.name == "mark" and direction.length() > 0.3 and direction.angle() > -3 * PI / 4 and direction.angle() < -PI / 4:
		docManager.despawn_documents()

func perform_click():
	print("doc " + str(self.name) + " clicked")
