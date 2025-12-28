extends Node3D

signal trash_spawned(trash: Trash)

@export var spawn_height_offset: float = 0.1

var MAX_TRASH_COUNT: int = 10
var current_trash_count: int = 0

var MAX_HELD_TRASH: int = 2
var held_trash_count: int = 0

var spawn_points: PackedVector3Array = []

var trash_scenes: Array[PackedScene] = [
  preload("res://features/trash/can_rusted/can_rusted.tscn"),
  preload("res://features/trash/rubber_duck/rubber_duck.tscn"),
  preload("res://features/trash/dark_stain/dark_stain.tscn"),
]

@onready var trash_can: TrashCan = %TrashCan

func _ready() -> void:
  var navigation_region: NavigationRegion3D = self.get_node("../NavigationRegion3D")
  var navigation_mesh_instance: NavigationMesh = navigation_region.navigation_mesh
  self.spawn_points = navigation_mesh_instance.get_vertices()

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

    var trash_scene: PackedScene = self.trash_scenes[randi() % self.trash_scenes.size()]
    var trash_instance: Trash = trash_scene.instantiate() as Trash

    var random_point: Vector3 = self.spawn_points[randi() % self.spawn_points.size()]

    add_child(trash_instance)
    trash_instance.global_transform.origin = random_point + Vector3.DOWN * self.spawn_height_offset

    trash_instance.disposed.connect(_on_dispose_trash)
    emit_signal("trash_spawned", trash_instance)

func _on_child_entered_tree(node: Node) -> void:
  if node is Trash: self.current_trash_count += 1
  
func _on_child_exited_tree(node: Node) -> void:
  if node is Trash: self.current_trash_count -= 1

func _on_dispose_trash(trash: Trash) -> void:
  if trash.trash_type == Trash.TrashType.SOLID:
    if self.held_trash_count < self.MAX_HELD_TRASH:
      self.held_trash_count += 1
      trash.queue_free()
  elif trash.trash_type == Trash.TrashType.LIQUID:
    trash.queue_free()

func _empty_held_trash() -> void:
  self.held_trash_count = 0