extends Node2D

# Определяем переменные
var snake = []
var snake_size = 3
var direction = Vector2(1, 0)
var next_direction = direction
var food_position = Vector2()
var grid_size = 16
var timer = 0.0
var move_speed = 0.1

func _ready():
	# Устанавливаем случайную позицию для еды
	spawn_food()
	# Устанавливаем начальное положение змеи
	spawn_snake()

func _process(delta):
	timer += delta
	if timer > move_speed:
		timer = 0
		move_snake()

func _input(event):
	# Обработка нажатия клавиш
	if event.is_action_pressed("ui_up") and direction.y != 1:
		next_direction = Vector2(0, -1)
	elif event.is_action_pressed("ui_down") and direction.y != -1:
		next_direction = Vector2(0, 1)
	elif event.is_action_pressed("ui_left") and direction.x != 1:
		next_direction = Vector2(-1, 0)
	elif event.is_action_pressed("ui_right") and direction.x != -1:
		next_direction = Vector2(1, 0)

func move_snake():
	direction = next_direction
	var new_head = snake[0] + direction

	# Проверяем столкновение с границами
	if new_head.x < 0 or new_head.y < 0 or new_head.x >= get_viewport_rect().size.x / grid_size or new_head.y >= get_viewport_rect().size.y / grid_size:
		get_tree().reload_current_scene()
		return

	# Проверяем столкновение с телом змеи
	for segment in snake:
		if new_head == segment:
			get_tree().reload_current_scene()
			return

	# Проверяем столкновение с едой
	if new_head == food_position:
		spawn_food()
		snake_size += 1
	else:
		snake.pop_back()

	snake.insert(0, new_head)
	# Вызываем перерисовку
	

func spawn_food():
	food_position = Vector2(randi() % int(get_viewport_rect().size.x / grid_size), randi() % int(get_viewport_rect().size.y / grid_size)) * grid_size

func spawn_snake():
	var start_pos = Vector2(int(get_viewport_rect().size.x / grid_size) / 2, int(get_viewport_rect().size.y / grid_size) / 2) * grid_size
	for i in range(snake_size):
		snake.append(start_pos - Vector2(i * grid_size, 0))

func _draw():
	# Рисуем змею
	for segment in snake:
		draw_rect(Rect2(segment, Vector2(grid_size, grid_size)), Color(0.8, 0.8, 0.8))

	# Рисуем еду
	draw_rect(Rect2(food_position, Vector2(grid_size, grid_size)), Color(1, 0, 0))
