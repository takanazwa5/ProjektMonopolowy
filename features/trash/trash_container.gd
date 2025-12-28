extends Node3D

signal trash_spawned(trash: Trash)

@export var spawn_height_offset: float = 0.1
@export var MAX_TRASH_COUNT: int = 10
@export var MAX_HELD_TRASH: int = 2
@export_group("Floor Thresholds")
@export var ROOM_X_THRESHOLDS: Vector2 = Vector2(-1.0, 1.0)
@export var ROOM_Y_THRESHOLDS: Vector2 = Vector2(0.1, 1.0)
@export var ROOM_Z_THRESHOLDS: Vector2 = Vector2(-1.0, 1.0)

var current_trash_count: int = 0
var held_trash_count: int = 0

var spawn_points: PackedVector3Array = []
var trash_registry: Dictionary[Vector2, bool] = {}

var trash_scenes: Array[PackedScene] = [
  preload("res://features/trash/can_rusted/can_rusted.tscn"),
  preload("res://features/trash/rubber_duck/rubber_duck.tscn"),
  preload("res://features/trash/dark_stain/dark_stain.tscn"),
]

@onready var trash_can: TrashCan = %TrashCan

func _ready() -> void:
  var navigation_region: NavigationRegion3D = self.get_node("../NavigationRegion3D")
  var navigation_mesh_instance: NavigationMesh = navigation_region.navigation_mesh
  for point in navigation_mesh_instance.get_vertices():
    if not _is_point_in_bounds(point): continue # Ignore out of bounds spawn points
  
    self.spawn_points.append(point)
    var key: Vector2 = Vector2(point.x, point.z)
    self.trash_registry[key] = false

  self.child_entered_tree.connect(_on_child_entered_tree)
  self.child_exiting_tree.connect(_on_child_exited_tree)

  self.trash_can.interacted.connect(_empty_held_trash)

func _process(delta: float) -> void:
  DebugPanel.add_property(self.current_trash_count, "Current Trash Count", 100)
  DebugPanel.add_property("%d/%d" % [self.held_trash_count, self.MAX_HELD_TRASH], "Held Trash", 100)

func spawn_trash(count: int) -> void:
  for i in count:
    if self.current_trash_count >= self.MAX_TRASH_COUNT:
      return

    var trash_scene: PackedScene = self.trash_scenes.pick_random()
    var trash_instance: Trash = trash_scene.instantiate() as Trash

    var available_points: Array[Vector3] = []
    for point in self.spawn_points:
      if not trash_registry[Vector2(point.x, point.z)]:
        available_points.append(point)

    if available_points.size() == 0:
      push_warning("No available spawn points for trash!")
      return

    var random_point: Vector3 = available_points.pick_random()

    add_child(trash_instance)
    trash_instance.global_position = random_point + Vector3.DOWN * self.spawn_height_offset
    var key: Vector2 = Vector2(random_point.x, random_point.z)
    trash_registry[key] = true

    trash_instance.disposed.connect(_on_dispose_trash)
    trash_spawned.emit(trash_instance)

func _on_child_entered_tree(node: Node) -> void:
  if node is Trash: self.current_trash_count += 1
  
func _on_child_exited_tree(node: Node) -> void:
  if node is Trash:
    self.current_trash_count -= 1
    var key: Vector2 = Vector2(node.global_position.x, node.global_position.z)
    trash_registry[key] = false

func _on_dispose_trash(trash: Trash) -> void:
  if trash.trash_type == Trash.TrashType.SOLID:
    if self.held_trash_count < self.MAX_HELD_TRASH:
      self.held_trash_count += 1
      trash.queue_free()
  elif trash.trash_type == Trash.TrashType.LIQUID:
    trash.queue_free()

func _empty_held_trash() -> void:
  self.held_trash_count = 0

func _is_point_in_bounds(point: Vector3) -> bool:
  if point.x < ROOM_X_THRESHOLDS.x or point.x > ROOM_X_THRESHOLDS.y:
    return false
  if point.y < ROOM_Y_THRESHOLDS.x or point.y > ROOM_Y_THRESHOLDS.y:
    return false
  if point.z < ROOM_Z_THRESHOLDS.x or point.z > ROOM_Z_THRESHOLDS.y:
    return false
  return true