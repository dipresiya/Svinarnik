extends Node2D

# Параметры игры
var grid_size := 16
var grid_width := 50
var grid_height := 30
var initial_snake_length := 1
var snake_speed := 0.1

# Переменные змейки
var snake_segments = [Vector2(5, 5)]
var snake_direction = Vector2.RIGHT
var should_draw_square = false
var food_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = snake_speed
	$Timer.start()
	#draw_rect(Rect2(0, 0, GRID_SIZE * 50, GRID_SIZE * 30), Color.TEAL, false, 16)
	spawn_food()  # Добавлено: вызов функции для появления еды
	pass
	
func _on_timer_timeout():
	should_draw_square = true
	
func spawn_food():
	var is_food_on_snake = true  # Флаг для проверки, находится ли еда на теле змеи
	
	# Пока еда находится на теле змеи, генерируем новые координаты
	while is_food_on_snake:
		# Генерируем случайную позицию для еды
		food_position = Vector2(randi() % (grid_width - 2) + 1, randi() % (grid_height - 2) + 1)
		
		# Проверяем, не находится ли еда на теле змеи
		is_food_on_snake = false
		for segment in snake_segments:
			if food_position == segment:
				is_food_on_snake = true
				break
func draw_food():
	draw_rect(Rect2(food_position.x * grid_size, food_position.y * grid_size, grid_size, grid_size), Color.RED)	
	
func _draw():
	update_snake()
	draw_rect(Rect2(grid_size/2, grid_size/2, grid_size * grid_width, grid_size * grid_height), Color.TEAL, false, grid_size)
	draw_food()  # Добавлено: вызов функции для отрисовки еды
	
	
func update_snake():
	for segment in snake_segments:
		draw_rect(Rect2(segment.x * grid_size, segment.y * grid_size, grid_size, grid_size), Color(0, 1, 0))
		
func move_snake():
	# Перемещаем голову змейки в новое положение
	var new_head = snake_segments[0] + snake_direction
	
	# Проверяем, не вышла ли змейка за границы экрана
	if new_head.x < 0 or new_head.y < 0 or new_head.x >= grid_width or new_head.y >= grid_height:
		get_tree().reload_current_scene()
		return
	
	# Проверяем, не пересекла ли змейка саму себя
	if new_head in snake_segments:
		get_tree().reload_current_scene()
		return
	# Проверяем, съедена ли еда
	if new_head == food_position:
		snake_segments.insert(0, new_head)
		spawn_food()  # Добавлено: вызов функции для появления новой еды
	else:
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

