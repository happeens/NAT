extends "./character.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var GRAVITY = Vector2(0, 900)
export var WALK_SPEED = 600.0
export var JUMP_SPEED = 800.0
export var WALL_JUMP_VEL = 1600.0
export(PackedScene) var default_weapon

const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0

const MIN_ONAIR_TIME = 0.1


var air_time = 0
var on_floor = false

var on_wall_left = false
var on_wall_right = false

var jumps_available = 1

var weapon

func _ready():
	var wall_left = get_node("wall_left")
	var wall_right = get_node("wall_right")

	wall_left.connect("body_entered", self, "enter_wall_left")
	wall_left.connect("body_exited", self, "exit_wall_left")

	wall_right.connect("body_entered", self, "enter_wall_right")
	wall_right.connect("body_exited", self, "exit_wall_right")

	set_weapon(default_weapon)

func set_weapon(new_weapon):
	if weapon:
		weapon.queue_free()

	weapon = new_weapon.instance()
	weapon.set_player(get_node("."))
	add_child(weapon)


func is_touching_wall():
	return on_wall_left or on_wall_right

func _input(event):
	if !is_single_player():
		if !is_local():
			return

	if (on_floor or jumps_available > 0) and event.is_action_pressed("jump") and not event.is_echo() and not is_on_wall():
		linear_vel.y = -JUMP_SPEED
		jumps_available -= 1

	if is_touching_wall() and !is_on_floor() and Input.is_action_pressed("jump") and not event.is_echo():
		var direction = 1
		if on_wall_right:
			direction = direction * -1

		linear_vel.x += direction * WALL_JUMP_VEL
		linear_vel.y = -JUMP_SPEED
		jumps_available += 1

func _process(delta):
	if is_local():
		rpc_unreliable("process_position_update", get_tree().get_network_unique_id(), get_position(), linear_vel)

func switchAnimation(animation):
	if !is_single_player():
		var id = get_tree().get_network_unique_id()
		rpc_unreliable("process_animation_update", id, animation)
		process_animation_update(id, animation)
	else:
		process_animation_update(-1, animation)

var old_anim_type = "idle"
var old_anim_direction = "right"

func _physics_process(delta):
	air_time += delta

	linear_vel += delta * GRAVITY
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)

	var animation_type = old_anim_type # walk, fly, idle
	var animation_direction = old_anim_direction # left, right

	if is_on_floor():
		animation_type = "idle"
		air_time = 0

	var target_speed = 0

	on_floor = air_time < MIN_ONAIR_TIME

	if Input.is_action_pressed("left") and (is_local() or is_single_player()):
		target_speed += -1
		animation_direction = "left"
		animation_type = "walk"
	if Input.is_action_pressed("right") and (is_local() or is_single_player()):
		target_speed += 1
		animation_direction = "right"
		animation_type = "walk"

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	if on_floor and Input.is_action_pressed("jump") and (is_local() or is_single_player()):
		linear_vel.y = -JUMP_SPEED


	if on_floor:
		jumps_available = 1
	else:
		animation_type = "fly"

	if on_wall_left:
		animation_type = "wall"
		animation_direction = "left"

	if on_wall_right:
		animation_type = "wall"
		animation_direction = "right"

	if(old_anim_type != animation_type or old_anim_direction != animation_direction):
		if is_local() or is_single_player():
			switchAnimation(animation_type + "_" + animation_direction)
			old_anim_direction = animation_direction
			old_anim_type = animation_type


func enter_wall_left(body):
	on_wall_left = true

func exit_wall_left(body):
	on_wall_left = false

func enter_wall_right(body):
	on_wall_right = true

func exit_wall_right(body):
	on_wall_right = false
