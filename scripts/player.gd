extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var GRAVITY = Vector2(0, 900)
export var WALK_SPEED = 900.0
export var JUMP_SPEED = 400.0
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1

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

	linear_vel += delta * GRAVITY
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	if is_on_floor():
		air_time = 0

	on_floor = air_time < MIN_ONAIR_TIME

	var target_speed = 0
	if Input.is_action_pressed("left"):
		target_speed += -1
	if Input.is_action_pressed("right"):
		target_speed +=  1

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	if on_floor:
		jumps_available = 1

