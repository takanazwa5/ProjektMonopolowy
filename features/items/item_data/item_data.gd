class_name ItemData extends Resource


enum Type {SZLUGI, PIWO, MISC}


@export var name: StringName
@export var type: Type
@export_range(-1.0, -0.15, 0.01) var preview_zoom: float = -0.15


static var _names: PackedStringArray = []


func _init() -> void:

	if not name.is_empty():

		assert(name not in _names, "Duplicate item names: %s" % name)
		_names.append(name)
