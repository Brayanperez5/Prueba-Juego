class_name MainCharacter
extends CharacterBody2D

@export var gravity = 350
@export var jump_speed = 200
@export var walk_speed = 100
@export var run_speed = 300

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_attacking = false
		
#Todo lo que se va a ejecutar en func _physics_process(delta) se va a procesar unas 60 veces por segundo
func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Salto
	var jump_pressed = Input.is_action_just_pressed("Jump")
	if jump_pressed and is_on_floor() and not is_attacking:
		velocity.y = -jump_speed

	# Movimiento
	var walk = Input.get_axis("Left", "Right")
	var is_running = Input.is_action_pressed("Run")
	var speed = run_speed if is_running else walk_speed
	if not is_attacking:
		velocity.x = speed * walk
	else:
		velocity.x = 0  # Opcional: inmovilizar mientras ataca

	# Flip horizontal
	if walk != 0:
		animated_sprite_2d.scale.x = sign(walk)

	# Ataque
	var attack = Input.is_action_just_pressed("Attack")
	if attack and is_on_floor() and not is_attacking:
		is_attacking = true
		animated_sprite_2d.play("Attack")

	# Animaciones
	if not is_attacking:
		if not is_on_floor():
			animated_sprite_2d.play("Jump")
		elif walk != 0:
			if is_running:
				animated_sprite_2d.play("Run")
			else:
				animated_sprite_2d.play("Walk")
		else:
			animated_sprite_2d.play("Idle")

	move_and_slide()	
	
#para resetear is_attacking cuando la animación de ataque termine:
func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "Attack":
		is_attacking = false
