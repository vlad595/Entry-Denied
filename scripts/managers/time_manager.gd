extends Node

var seconds: float
var minutes: int
var hours: int

func _physics_process(delta: float) -> void:
    seconds += delta
    if seconds >= 60:
        seconds = 0
        minutes += 1
    if minutes >= 5:
        Global.current_time_minutes += 12
        print("Time: " + str(Global.current_time_hours) + ":" + str(Global.current_time_minutes))
        minutes = 0
    if Global.current_time_minutes >= 60:
        Global.current_time_hours += 1
        Global.current_time_minutes = 0