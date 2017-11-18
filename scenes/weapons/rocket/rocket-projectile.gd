extends "res://scripts/Projectile.gd"

export var SMOKE_TIME = 0.3;
export(PackedScene) var smoke;

func _ready():
	speed = 750
	
var lastSmoke = 0
func _process(delta):
	lastSmoke += delta * (randf() * 7 - 0.5)
	if (lastSmoke > SMOKE_TIME):
			lastSmoke -= SMOKE_TIME
			var smokeParticle = smoke.instance()
	
			get_tree().get_root().add_child(smokeParticle)
			smokeParticle.set_position(get_global_position())
	