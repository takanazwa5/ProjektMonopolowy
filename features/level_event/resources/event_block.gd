class_name EventBlock
extends Resource

enum EventOrdering {
  SEQUENTIAL,
  RANDOM,
}

@export var ordering: EventOrdering = EventOrdering.SEQUENTIAL
@export var events: Array[EventEntry] = []