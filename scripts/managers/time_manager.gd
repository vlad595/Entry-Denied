extends Node

var seconds: float
var hours: int

func _physics_process(delta: float) -> void:
    seconds += delta
    if seconds >= 10:
        seconds = 0
        Global.current_time_minutes += 5
        print("Time: " + str(Global.current_time_hours) + ":" + str(Global.current_time_minutes))
    if Global.current_time_minutes >= 60:
        Global.current_time_hours += 1
        Global.current_time_minutes = 0