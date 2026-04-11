class_name Passport extends Document

@onready var anim_player: AnimationPlayer = $Ukraine_passport/AnimationPlayer
@onready var colision: CollisionShape3D = $CollisionShape3D

var rng = RandomNumberGenerator.new()

var isOpened: bool = false

var yearOfirth: int
var yearOfIssue: int

func _ready() -> void:
	super._ready()

func perform_click():
	if isOpened:
		_close_passport()
	else:
		_open_passport()

#region Labels
@onready var nama_label: Label3D = $Passport_labels/Name_label/Label
@onready var surname_label: Label3D = $Passport_labels/Surname_label/Label
@onready var passportNo_label: Label3D = $Passport_labels/PassportNo_label/Label
@onready var countryCode_label: Label3D = $Passport_labels/CountryCode_label/Label
@onready var nationality_label: Label3D = $Passport_labels/Nationality_label/Label
@onready var dob_label: Label3D = $Passport_labels/DateOfBirth_label/Label
@onready var sex_label: Label3D = $Passport_labels/Sex_label/Label
@onready var issueDate_label: Label3D = $Passport_labels/DateOfIssue_label/Label
@onready var expireDate_label: Label3D = $Passport_labels/DateOfExpire_label/Label
@onready var mrzCode_label: Label3D = $Passport_labels/Code
#endregion

#region Animation

func _open_passport():
	anim_player.play("open")
	colision.shape.size.x = 3
	isOpened = true
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees:y", -90, 0.4)
func _close_passport():
	anim_player.play_backwards("open")
	colision.shape.size.x = 1.313
	isOpened = false
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees:y", 0, 0.4)

#endregion

#region Passport filling

func fill_passport(name: String, surname: String, countryCode: String, sex: String, nationality: String, isExpired: bool):
	nama_label.text = name
	surname_label.text = surname
	countryCode_label.text = countryCode
	sex_label.text = sex
	nationality_label.text = nationality
	dob_label.text = self.gen_dob()
	issueDate_label.text = gen_dateOfIssue(isExpired)
	expireDate_label.text = gen_dateOfExpire()
	mrzCode_label.text = gen_mrz_code(countryCode, name, surname, "XX000000", dob_label.text, sex, expireDate_label.text)
	

func gen_mrz_code(country_code: String, name: String, surname: String, passportNo: String, dob: String, sex: String, expire: String) -> String:
	var format_mrz_first = "P<{country_code}{surname}<<{name}"
	var foramt_mrz_second = "{passportNo}<0{country_code}{dob}2{sex}{expire}71234567890<<<<10"

	var actual_mrz_first = format_mrz_first.format({
		"country_code": country_code,
		"surname": surname,
		"name": name,
	})

	actual_mrz_first = actual_mrz_first + "<".repeat(44 - actual_mrz_first.length()) + "\n"

	var actual_mrz_second = foramt_mrz_second.format({
		"country_code": country_code,
		"passportNo": passportNo,
		"dob": dob.remove_chars(".").reverse(),
		"sex": "F" if sex.capitalize() == "Female" else "M",
		"expire": expire.remove_chars(".").reverse()
	})

	var actual_mrz = actual_mrz_first + actual_mrz_second
	return actual_mrz

func gen_dob() -> String:
	yearOfirth = rng.randi_range(1980, 2010)
	return str(rng.randi_range(0, 31)) + "." + str(rng.randi_range(1, 12)) + "." + str(yearOfirth)

func gen_dateOfIssue(isExpired: bool) -> String:
	if !isExpired:
		yearOfIssue = rng.randi_range(2023, 2026)
	else:
		yearOfIssue = rng.randi_range(yearOfirth + 6, 2023)
	return str(rng.randi_range(0, 31)) + "." + str(rng.randi_range(1, 12)) + "." + str(yearOfIssue)

func gen_dateOfExpire() -> String:
	return str(rng.randi_range(0, 31)) + "." + str(rng.randi_range(1, 12)) + "." + str(yearOfIssue + 3)

#endregion