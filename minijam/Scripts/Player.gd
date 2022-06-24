extends KinematicBody2D

const speed = 60
const jump_power = -115
const gravity = 5
const FLOOR = Vector2(0, -1)
var velocity = Vector2()

var on_ground = false
var attacking = false


func _physics_process(delta):

	var up_pressed = Input.is_action_pressed("up")
	var right_pressed = Input.is_action_pressed("right")
	var left_pressed = Input.is_action_pressed("left")
	if !attacking && (up_pressed || right_pressed || left_pressed):
		if right_pressed || left_pressed:
			# This formula basically assures that if both right and left are pressed
			# at the same time the sprite direction will remain the same as it was
			# before the press
			$AnimatedSprite.flip_h = \
				!left_pressed && (right_pressed || $AnimatedSprite.flip_h) || \
				left_pressed && right_pressed && $AnimatedSprite.flip_h
			velocity.x = speed * int(right_pressed) - speed * int(left_pressed)
			$AnimatedSprite.play("idle" if right_pressed && left_pressed else "run")
		if on_ground && up_pressed:
			velocity.y = jump_power
			on_ground = false
	elif Input.is_action_just_pressed("attack"):
		attacking = true;
		print_debug("space was pressed")
	elif attacking == true:
		$AnimatedSprite.play("attack")
	else:
		velocity.x = 0
		if on_ground && !attacking:
			$AnimatedSprite.play("idle")

	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()

	velocity.y += gravity
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
		if velocity.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("land")

	velocity = move_and_slide(velocity, FLOOR)
 
func _on_AnimatedSprite_animation_finished():
	attacking=false
	print_debug("end of attack")
