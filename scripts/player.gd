extends Camera3D
var startDraggingPos: Vector2
var endDraggingPos: Vector2
var direction: Vector2
var startAnimationToStandart: bool = true
var isSwipeLongerThan5: bool = false
var isSwipeLong: bool = false
var minimumSwipeDistance

signal startAnimationToDesk
signal startAnimationToDefault
signal startAnimationToConveyor

var timer: Timer

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:

		if event.is_pressed():
			timer.start()
			startDraggingPos = event.position
		
		elif event.is_released():
			if Global.isPlayerBusy:
				return
			endDraggingPos = event.position
			direction = startDraggingPos.direction_to(endDraggingPos)
			print("start: " + str(startDraggingPos) + " end: " + str(endDraggingPos))
			if startDraggingPos.distance_to(endDraggingPos) > minimumSwipeDistance:
				isSwipeLong = true
			print("Swipe is " + str(startDraggingPos.distance_to(endDraggingPos)))
			print("Swipe angle is: " + str(direction.angle()))

			timer.stop()
			if isSwipeLongerThan5 and isSwipeLong:
				determine_swipe_direction()
				isSwipeLongerThan5 = false
				isSwipeLong = false

func determine_swipe_direction():
	if direction.angle() > -PI / 4 and direction.angle() < PI / 4:
		startAnimationToConveyor.emit()
	elif direction.angle() > PI / 4 and direction.angle() < 3 * PI / 4:
		startAnimationToDesk.emit()
	elif direction.angle() > -3 * PI / 4 and direction.angle() < -PI / 4:
		startAnimationToDefault.emit()
	elif direction.angle() > 3 * PI / 4 or direction.angle() < -3 * PI / 4:
		startAnimationToDefault.emit()

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 0.1
	timer.one_shot = true
	add_child(timer)

	minimumSwipeDistance = DisplayServer.window_get_size().y / 6
	print("Minimum swipe distance: " + str(minimumSwipeDistance))
	print("Screen size: " + str(DisplayServer.window_get_size()))

	startAnimationToDesk.connect(_animationToDesk)
	startAnimationToDefault.connect(_animationToDefault)
	startAnimationToConveyor.connect(_animationToConveyor)

	timer.timeout.connect(func(): isSwipeLongerThan5 = true)

func _process(delta: float) -> void:
	pass

func _animationToDesk():
	Global.isPlayerBusy = true
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:z", 2.102, 0.5)
	tween.tween_property(self, "position:x", 3.262, 0.5)
	tween.tween_property(self, "position:y", 11.402, 0.5)
	tween.tween_property(self, "rotation_degrees:x", -90, 0.5)
	tween.tween_property(self, "rotation_degrees:y", 0.0, 0.5)
	direction = Vector2.ZERO
	tween.finished.connect(_free_player)

func _free_player():
	Global.isPlayerBusy = false

func _animationToDefault():
	Global.isPlayerBusy = true
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:z", 9.62, 0.5)
	tween.tween_property(self, "position:x", 2.547, 0.5)
	tween.tween_property(self, "position:y", 10, 0.5)
	tween.tween_property(self, "rotation_degrees:x", -22.3, 0.5)
	tween.tween_property(self, "rotation_degrees:y", 0.0, 0.5)
	direction = Vector2.ZERO
	tween.finished.connect(_free_player)

func _animationToConveyor():
	Global.isPlayerBusy = true
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:z", 11.78, 0.5)
	tween.tween_property(self, "position:x", -2.455, 0.5)
	tween.tween_property(self, "position:y", 11.671, 0.5)
	tween.tween_property(self, "rotation_degrees:x", -45.9, 0.5)
	tween.tween_property(self, "rotation_degrees:y", 90.0, 0.5)
	direction = Vector2.ZERO
	tween.finished.connect(_free_player)
