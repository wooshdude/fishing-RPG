extends KinematicBody2D

const SPEED = 200 
const GRAVITY = -1

var velocity = Vector2.ZERO
var player
var direction = 0

onready var timer = $Timer
onready var collision = $Area2D/CollisionShape2D2
var in_water = false
var floating = true

signal floating()
signal reel()

func _ready():
	player = get_tree().get_root().find_node("Player", true, false)
	player.connect("player_direction", self, "make_direction")
	velocity.y = -70
	collision.disabled = true
	timer.paused = true
	
# Called when the node enters the scene tree for the first time.
func make_direction(player_direction):
	if player_direction == "1":
		direction = 1
	else:
		direction = -1
	velocity.x = direction * SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = lerp(velocity.x, 0, delta)
	if position.y > player.position.y + 12:
		velocity = Vector2.ZERO
		collision.disabled = false
		emit_signal("floating")
		if in_water == false && timer.is_stopped():
			destroy_evil()
		
	else:
		velocity.y =  velocity.y - GRAVITY
	velocity = move_and_slide(velocity)

	
	if collision.disabled == false:
		timer.paused = false
	
	
	
func _on_Area2D_area_entered(area):
	in_water = true
	
func destroy_evil():
	queue_free()

