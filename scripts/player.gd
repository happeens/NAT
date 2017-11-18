extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var GRAVITY = Vector2(0, 900)
export var WALK_SPEED = 600.0
export var JUMP_SPEED = 800.0
export var WALL_JUMP_VEL = 1600.0
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1

var linear_vel = Vector2()

var air_time = 0
var on_floor = false

var jumps_available = 1

var network_id = -1
func get_target_speed():
	return target_speed

func get_air_time():
	return air_time

func _ready():
	pass

func _input(event):
	if network_id != get_tree().get_network_unique_id():
		return

	if (on_floor or jumps_available > 0) and event.is_action_pressed("jump") and not event.is_echo() and not is_on_wall():
		linear_vel.y = -JUMP_SPEED
		jumps_available -= 1

	if is_on_wall() and !is_on_floor() and Input.is_action_pressed("jump") and not event.is_echo():
		var collision = get_slide_collision(0)
		var collision_direction = collision.get_normal()
		linear_vel.x += collision_direction.x * WALL_JUMP_VEL
		linear_vel.y = -JUMP_SPEED
		jumps_available += 1

func _process(delta):
	var is_local = network_id == get_tree().get_network_unique_id()

	if is_local:
		rpc_unreliable("process_position_update", get_tree().get_network_unique_id(), get_position(), linear_vel)

remote func process_position_update(id, pos, vel):
	var is_local = network_id == get_tree().get_network_unique_id()
	if is_local:
		return

	var character = get_node("/root/Node2D/" + str(id))
	character.set_position(pos)
	character.linear_vel = vel

func _physics_process(delta):
	var is_local = network_id == get_tree().get_network_unique_id()

	air_time += delta

	linear_vel += delta * GRAVITY
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	if is_on_floor():
		air_time = 0

	var target_speed = 0

	on_floor = air_time < MIN_ONAIR_TIME

	if Input.is_action_pressed("left") and is_local:
		target_speed += -1
	if Input.is_action_pressed("right") and is_local:
		target_speed +=  1

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	if on_floor and Input.is_action_pressed("jump") and is_local:
		linear_vel.y = -JUMP_SPEED
	if on_floor:
		jumps_available = 1
