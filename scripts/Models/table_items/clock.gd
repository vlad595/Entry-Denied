extends Node3D

@onready var label: Label3D = $table_clock/Label3D

var time_accumulator: float = 0.0



func _process(delta: float) -> void:
    time_accumulator += delta
    if time_accumulator >= 1.0:
        label.visible = false
    if time_accumulator >= 2.0:
        time_accumulator = 0.0
        label.visible = true
        label.text = get_time()

func get_time() -> String:
    var minutes = Global.current_time_minutes
    var hours = Global.current_time_hours

    var result: String = ""

    if minutes < 10:
        result = "0" + str(minutes)
    else:
        result = str(minutes)
    
    if hours < 10:
        result = "0" + str(hours) + ":" + result
    else:
        result = str(hours) + ":" + result
    return result