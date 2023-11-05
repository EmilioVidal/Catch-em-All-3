extends Area2D

var velocity = Vector2.ZERO
var speed = 350

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(100, 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1
	if Input.is_action_pressed("ui_down"):
		velocity.y = 1
	
	if velocity.lenght() > 0:
		velocity = velocity.normalized() * speed *delta
	position += velocity
