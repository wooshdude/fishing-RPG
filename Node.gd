extends Node


func move(velocity, SPEED):
		#Player Movement
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	
	velocity = velocity.normalized() * SPEED
	velocity = move_and_slide(velocity)
	

func cast_rod():
	pass

func _on_Area2D_area_entered(area):
	can_interact = true
