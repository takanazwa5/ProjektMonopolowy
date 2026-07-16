class_name LevelEventsManager
extends Node

var event_queue: Array[EventEntry] = []
var current_event: EventEntry = null
@onready var cooldown_timer: Timer = %CooldownTimer

func _ready() -> void:
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

	if LevelManager.current_level_data == null:
		push_warning("No level data found. Level events will not be executed.")
		return

	if LevelManager.current_level_data.event_plan == null:
		push_warning("No event plan found in the current level data. Level events will not be executed.")
		return

	var event_blocks: Array[EventBlock] = LevelManager.current_level_data.event_plan.event_blocks
	for block in event_blocks:
		if block.ordering == EventBlock.EventOrdering.SEQUENTIAL:
			event_queue.append_array(block.events.duplicate(true))
		elif block.ordering == EventBlock.EventOrdering.RANDOM:
			var shuffled_events: Array[EventEntry] = block.events.duplicate(true)
			shuffled_events.shuffle()
			event_queue.append_array(shuffled_events)

	if current_event == null and event_queue.size() > 0:
		proceed_to_next_event()

func proceed_to_next_event() -> void:
	if event_queue.size() == 0:
		push_warning("No more events to execute.")
		return

	current_event = event_queue.pop_front()
	cooldown_timer.start(current_event.delay)

func _on_cooldown_timer_timeout() -> void:
	if current_event == null: return 
	if current_event.event == null:
		push_warning("current_event.event is null. Skipping execution.")
		current_event = null
		proceed_to_next_event()
		return

	current_event.event.execute_event()

	current_event.number_of_repeats -= 1
	if current_event.repeatable and current_event.number_of_repeats > 0:
		cooldown_timer.start(current_event.cooldown)
	else:
		current_event = null
		proceed_to_next_event()
