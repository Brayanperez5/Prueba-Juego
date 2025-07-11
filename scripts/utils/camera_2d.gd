class_name camera_follower_player
extends Camera2D

#Este export hara que se vea en el inspector y asignaremos el objeto que queremos que siga
@export var object_to_follow:Node2D
 
#Todo lo que se va a ejecutar en func _process(delta): se procesara en frames
func _process(delta):
	position = object_to_follow.position
