extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var GRAVITY = Vector2(0, 900)
export var WALK_SPEED = 900.0
export var JUMP_SPEED = 800.0
export var WALL_JUMP_VEL = 1600.0
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1

const WALL_JUMP_COOLDOWN = 0.5
var wall_jump_timer = 0 # seconds

var linear_vel = Vector2()

var air_time = 0
var on_floor = false

var jumps_available = 1

func _ready():
	pass

func _input(event):
	if (on_floor or jumps_available > 0) and event.is_action_pressed("jump") and not event.is_echo():
		linear_vel.y = -JUMP_SPEED
		jumps_available -= 1

func _physics_process(delta):
	air_time += delta

	if wall_jump_timer > 0:
		wall_jump_timer -= delta
	else:
		wall_jump_timer = 0

	print("wall jump timer: ", wall_jump_timer)

	linear_vel += delta * GRAVITY
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	if is_on_floor():
		air_time = 0

	var target_speed = 0

	on_floor = air_time < MIN_ONAIR_TIME

	if Input.is_action_pressed("left"):
		target_speed += -1
	if Input.is_action_pressed("right"):
		target_speed +=  1

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	if is_on_wall() and Input.is_action_pressed("jump") and wall_jump_timer == 0:
		if linear_vel.x > 0:
			print("going right")
			linear_vel.x -= WALL_JUMP_VEL
			wall_jump_timer += WALL_JUMP_COOLDOWN
		else: if linear_vel.x < 0:
			print("going left")
			linear_vel.x += WALL_JUMP_VEL
			wall_jump_timer += WALL_JUMP_COOLDOWN
		else:
			print("not moving")
		linear_vel.y = -JUMP_SPEED * 0.5

	if on_floor and Input.is_action_pressed("jump"):
		linear_vel.y = -JUMP_SPEED
	if on_floor:
		jumps_available = 1

