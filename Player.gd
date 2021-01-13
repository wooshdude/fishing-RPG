extends KinematicBody2D

enum{
	MOVE,
	CAST_ROD,
	INTERACT,
	WAITING
}

#Player Movement Variables
const SPEED = 80
var state = MOVE
var velocity = Vector2.ZERO


onready var animate = $AnimationPlayer
onready var sprite = $player_normal
onready var castSprite = $player_cast
onready var bobber = $"../Bob/"
var can_interact = false

var dumb = 0
var direction = "right"
signal player_direction

var Bob = preload("res://Bob.tscn")
var bob 
var casting = false

func _ready():
	pass

func _process(delta):
	match state:
		MOVE:
			move()
		CAST_ROD:
			cast_rod()
		WAITING:
			waiting()
	
	if Input.is_action_just_pressed("ui_cancel"):
			done_Fishing()

func move():
		#Player Movement
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	
	velocity = velocity.normalized() * SPEED
	velocity = move_and_slide(velocity)
	
	
	
	#Player Animation
	if velocity != Vector2.ZERO:
		if Input.is_action_pressed("ui_left"):
			sprite.set_flip_h(true)
			castSprite.set_flip_h(true)
			castSprite.offset.x = -8
			direction = "left"
			dumb = -1
		elif Input.is_action_pressed("ui_right"):
			sprite.set_flip_h(false)
			castSprite.set_flip_h(false)
			castSprite.offset.x = 8
			direction = "right"
			dumb = 1
		animate.play("walk")
	else:
		animate.play("idle")
	
	#Player casts rod
	if Input.is_action_just_pressed("ui_accept") && can_interact == false:
		animate.play("cast")
		state = CAST_ROD

func cast_rod():

	if casting == false:
		if direction == "left":
			emit_signal("player_direction", "-1")
			dumb = -1
			
		elif direction == "right":
			emit_signal("player_direction", "1")
			dumb = 1
		casting = true
		bob = Bob.instance()
		get_parent().add_child(bob)
		bob.connect("floating", self, "_is_Fishing")
		bob.connect("reel", self, "_done_Fishing")

		if direction == "left":
			emit_signal("player_direction", "-1")
			dumb = -1

		elif direction == "right":
			emit_signal("player_direction", "1")
			dumb = 1
		
		
			
		bob.global_position.x = global_position.x - dumb * 25
		bob.global_position.y = global_position.y -1
	
	
func waiting():
	animate.play("cast_idle")
	
	if bob == null:
		state = MOVE
		casting = false

func _on_Area2D_area_entered(area):
	can_interact = true
	
func _on_Area2D_area_exited(area):
	can_interact = false
	
func _is_Fishing():
	state = WAITING
	
func done_Fishing():
	bob.queue_free()
	state = MOVE
#func _on_AnimationPlayer_animation_finished():
#	animate.play("cast_idle")
