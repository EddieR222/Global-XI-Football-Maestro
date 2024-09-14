extends Area3D

# Force applied to the ball when colliding
var kick_force = 100.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body) -> void:
	if body is RigidBody3D:
		# Calculate the direction from the character to the ball
		var direction: Vector3 = (body.global_transform.origin - global_transform.origin).normalized()

		# Apply an impulse to the soccer ball in that direction
		body.apply_impulse(Vector3.ZERO, direction * kick_force)
