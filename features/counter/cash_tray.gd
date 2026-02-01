class_name CashTray extends StaticBody3D

signal total_in_tray_changed(total: float)

@export var tray_offset: Vector2 = Vector2.ZERO
@export_group("Note Settings")
@export var NOTE_FAN_RADIUS: float = 0.0
@export var NOTE_SIZE: Vector2 = Vector2(0.0, 0.0)
@export var NOTE_HEIGHT: float = 0.0
@export_group("Coin Settings")
@export var COIN_ROW_CAPACITY: int = 0
@export var COIN_STACK_SPACING: float = 0.0
@export var COIN_RADIUS: float = 0.0
@export var COIN_HEIGHT: float = 0.0

var total_in_tray: float = 0.0

var coin_scene: PackedScene = preload("./coins/coin.tscn")
var note_scene: PackedScene = preload("./notes/note.tscn")

@onready var notes: Node3D = %Notes
@onready var coins: Node3D = %Coins

func _ready() -> void:
	COIN_ROW_CAPACITY = max(COIN_ROW_CAPACITY, 1)

	var cash_register: CashRegister = get_tree().get_first_node_in_group(&"cash_register")
	cash_register.add_money_to_tray.connect(_on_add_money_to_tray)
	cash_register.remove_money_from_tray.connect(_on_remove_money_from_tray)
	cash_register.transaction_finished.connect(_clean_tray)

	notes.child_entered_tree.connect(_note_entered_tree)
	notes.child_exiting_tree.connect(_note_exiting_tree)
	coins.child_entered_tree.connect(_coin_entered_tree)
	coins.child_exiting_tree.connect(_coin_exiting_tree)

func interact(event: InputEvent, _item_in_hand: Item) -> void:
	if event.is_action_pressed(&"interact"):
		_clean_tray()

func _on_add_money_to_tray(money: Money) -> void:
	match money.bill_type:
		Money.BILL_TYPE.COIN:
			var coin: Coin = coin_scene.instantiate() as Coin
			coin.value = money.value
			
			var coin_mesh: MeshInstance3D = coin.get_node("./MeshInstance3D") as MeshInstance3D
			coin_mesh.mesh.top_radius = COIN_RADIUS
			coin_mesh.mesh.bottom_radius = COIN_RADIUS
			coin_mesh.mesh.height = COIN_HEIGHT

			coins.add_child(coin)
		Money.BILL_TYPE.NOTE:
			var note: Note = note_scene.instantiate() as Note
			note.value = money.value

			var note_mesh: MeshInstance3D = note.get_node("./MeshInstance3D") as MeshInstance3D
			note_mesh.mesh.size = Vector3(NOTE_SIZE.x, NOTE_HEIGHT, NOTE_SIZE.y)

			notes.add_child(note)
	
	total_in_tray += money.value
	total_in_tray_changed.emit(total_in_tray)

func _on_remove_money_from_tray(money: Money) -> void:
	var target_node: Node3D
	match money.bill_type:
		Money.BILL_TYPE.COIN:
			target_node = coins
		Money.BILL_TYPE.NOTE:
			target_node = notes

	for child in target_node.get_children():
		if child.value == money.value:
			total_in_tray -= money.value
			total_in_tray_changed.emit(total_in_tray)
			child.queue_free()
			break

func _update_note_positions() -> void:
	var note_count: int = notes.get_child_count()
	var angle_step: float = PI / 2 / max(note_count, 1)

	for i in range(note_count):
		var note: Note = notes.get_child(i)
		if note is Note:
			var angle: float = (i + 1. / 2.) * angle_step
			if i == 0:
				angle = PI / 2
			note.position = Vector3(
				0, i * NOTE_HEIGHT, 0
			)
			note.rotation = Vector3.ZERO

			note.transform.origin = note.position

			note.rotate(Vector3.UP, -angle)
			note.translate(Vector3(
			  NOTE_FAN_RADIUS,
				0,
				0
			))

func _update_coin_positions() -> void:
	var coin_stacks: Dictionary[float, Array] = {}

	for coin in coins.get_children():
		if coin is Coin:
			if not coin_stacks.has(coin.value):
				coin_stacks[coin.value] = [] as Array[Coin]
			coin_stacks[coin.value].append(coin)

	var stack_index: int = 0
	for value: float in coin_stacks.keys():
		var stack: Array[Coin] = coin_stacks[value]
		var row: int = int(stack_index / COIN_ROW_CAPACITY)
		var column: int = stack_index % COIN_ROW_CAPACITY
		for i in range(len(stack)):
			stack[i].position = Vector3(
				- tray_offset.x / 2 + column * COIN_STACK_SPACING,
				i * COIN_HEIGHT + NOTE_HEIGHT * notes.get_child_count(),
				- tray_offset.y / 2 + row * COIN_STACK_SPACING)
		stack_index += 1

func _coin_entered_tree(_node: Node) -> void:
	_update_coin_positions()

func _note_entered_tree(_node: Node) -> void:
	_update_note_positions()
	_update_coin_positions()

func _coin_exiting_tree(_node: Node) -> void:
	_update_coin_positions()

func _note_exiting_tree(_node: Node) -> void:
	_update_note_positions()
	_update_coin_positions()

func _clean_tray() -> void:
	var _notes: Array[Node] = notes.get_children()
	var _coins: Array[Node] = coins.get_children()

	for note in _notes:
		total_in_tray -= note.value
		note.queue_free()

	for coin in _coins:
		total_in_tray -= coin.value
		coin.queue_free()
