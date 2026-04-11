extends Area3D
class_name Baggage

@onready var anim_player: AnimationPlayer = $baggage_1/AnimationPlayer
var is_opened: bool = false

func _ready() -> void:
    self.input_event.connect(self._on_input_event)

func animation(destination_pos: Vector3, duration: float) -> void:
    var tween = create_tween()
    tween.tween_property(self, "position", destination_pos, duration)

func _on_input_event(camera: Camera3D, event: InputEvent, click_position: Vector3, click_normal: Vector3, shape_idx: int) -> void:
    if event is InputEventScreenTouch and event.pressed:
        if is_opened:
            anim_player.play_backwards("open")
            is_opened = false
        else:
            anim_player.play("open")
            is_opened = true