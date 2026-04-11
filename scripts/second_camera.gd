extends Camera3D

@export var main_camera: Camera3D

func _process(delta: float) -> void:
	self.position = main_camera.position
	self.rotation = main_camera.rotation
	self.fov = main_camera.fov
