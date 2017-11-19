extends "res://scripts/Projectile.gd"

export var SMOKE_TIME = 0.3
export(PackedScene) var smoke
export(PackedScene) var explosion

var lastSmoke = 0

func _ready():
	speed = 750

func _process(delta):
	lastSmoke += delta * (randf() * 7 - 0.5)
	if (lastSmoke > SMOKE_TIME):
			lastSmoke -= SMOKE_TIME
			var smokeParticle = smoke.instance()
	
			get_tree().get_root().add_child(smokeParticle)
			smokeParticle.set_position(get_global_position())

func on_collide(partner):
	if partner.get_name().begins_with("Player"):
		partner.get_hit(1)
	
	var new_explosion = explosion.instance()
	new_explosion.set_position(get_global_position())
	get_node("/root").add_child(new_explosion)

	queue_free()