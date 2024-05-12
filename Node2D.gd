extends Node2D

const GRID_SIZE = 16
var snake_segments = [Vector2(5, 5)]
var snake_direction = Vector2.RIGHT
var should_draw_square = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = 0.1
	$Timer.start()
	draw_rect(Rect2(0, 0, GRID_SIZE * 50, GRID_SIZE * 30), Color.TEAL, false, 16)
	pass
	
func _on_timer_timeout():
	should_draw_square = true
	
func _draw():
	
	draw_rect(Rect2(0, 0, GRID_SIZE * 50, GRID_SIZE * 30), Color.TEAL, false, 16)
	update_snake()
	
	
func update_snake():
	for segment in snake_segments:
		draw_rect(Rect2(segment.x * GRID_SIZE, segment.y * GRID_SIZE, GRID_SIZE, GRID_SIZE), Color(0, 1, 0))
		
func move_snake():
	# Перемещаем голову змейки в новое положение
	var new_head = snake_segments[0] + snake_direction
	snake_segments.insert(0, new_head)
	# Удаляем хвост змейки
	snake_segments.pop_back()
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_D and snake_direction != Vector2.LEFT:
			snake_direction = Vector2.RIGHT
		if event.keycode == KEY_S and snake_direction != Vector2.UP:
			snake_direction = Vector2.DOWN
		if event.keycode == KEY_A and snake_direction != Vector2.RIGHT:
			snake_direction = Vector2.LEFT
		if event.keycode == KEY_W and snake_direction != Vector2.DOWN:
			snake_direction = Vector2.UP
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if should_draw_square:
		move_snake()
		should_draw_square = false
	queue_redraw()
	pass
