extends Node2D

# class member variables go here, for example:
var respawnTime
var elapsedTime
var spawned
var textureRocket
var texturePistol
var textureSword
var sceneRocket
var scenePistol
var sceneSword
var texture
var currentWeapon
var weaponType
func _ready():
	
	textureSword = preload("res://sprites/pistol dude/sword.png")
	textureRocket = preload("res://sprites/pistol dude/rocket.png")
	texturePistol = preload("res://sprites/pistol dude/pistol.png")
	sceneSword = preload("res://scenes/weapons/sword/sword.tscn")
	scenePistol = preload("res://scenes/weapons/pistol/pistol.tscn")
	sceneRocket = preload("res://scenes/weapons/rocket/rcoket.tscn")
	
	
	respawnTime = 10
	spawned = false
	elapsedTime = 0
	get_node("Area2D").connect("body_entered",self,"area2DBodyEnter")
	texture = get_node("WeaponSprite")
	set_process(true)
	pass

func _process(delta):
	if (!spawned):
		elapsedTime += delta
		if elapsedTime >= respawnTime:
			spawned = true
			elapsedTime = 0
			spawnRandomWeapon()
	
	
	pass

func spawnRandomWeapon():
	weaponType = randi()%3+1 #returns random int between 1 and 3
	print(weaponType)
	match weaponType:
		1: 
			texture.set_texture(texturePistol)
			currentWeapon = "Pistol"
		2: 
			texture.set_texture(textureSword)
			currentWeapon = "Sword"
		3: 
			print("rocket")
			
			texture.set_texture(textureRocket)
			currentWeapon = "Rocket"


func area2DBodyEnter(body):
	if(spawned):
		if(body.get_name().begins_with("Player")):
			print(body.get_name())
			spawned = false
			texture.set_texture(null)
			match weaponType:
				1: body.set_weapon(scenePistol)
				2: body.set_weapon(sceneSword)
				3: body.set_weapon(sceneRocket)
