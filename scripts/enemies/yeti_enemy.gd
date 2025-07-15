extends CharacterBody2D

@export var patrol_speed = 50
@export var chase_speed = 100
@export var gravity = 300
@export var direction := 1  # Comienza yendo a la izquierda

var is_chasing = false
var player: MainCharacter = null  # Usamos tu clase personalizada

@onready var sprite = $AnimatedSprite2D
@onready var ground_check = $GroundCheck  # RayCast2D
@onready var vision_area = $Area2D

func _ready():
	ground_check.enabled = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_chasing and player:
		if vision_area.overlaps_body(player):
			var move_dir = sign(player.global_position.x - global_position.x)
			velocity.x = chase_speed * move_dir
			update_direction_visuals(move_dir)

			# Animación de persecución
			if sprite.animation != "Run":
				sprite.play("Run")
		else:
			is_chasing = false
			player = null
	else:
		# Patrullaje
		if not ground_check.is_colliding():
			direction *= -1
			update_direction_visuals(direction)

		velocity.x = patrol_speed * direction

		# Animación de patrulla
		if patrol_speed != 0 and sprite.animation != "Walk":
			sprite.play("Walk")

	move_and_slide()

func update_direction_visuals(dir: float) -> void:
	sprite.scale.x = dir
	vision_area.position.x = abs(vision_area.position.x) * dir
	ground_check.position.x = abs(ground_check.position.x) * dir

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		is_chasing = true
		player = body
		print("👀 Jugador detectado")




func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		is_chasing = false
		player = null
		print("🚪 Jugador salió del área")
