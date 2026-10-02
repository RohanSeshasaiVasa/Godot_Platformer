extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -500.0
const FALL_LIMIT = 600.0

@onready var death_label: Label = $DeathUI/DeathLabel
@onready var win_label: Label = $DeathUI/WinLabel
@onready var message_label: Label = get_node_or_null("DeathUI/MessageLabel")
@onready var home_label: Label = get_node_or_null("DeathUI/HomeLabel")

var dead := false
var won := false

func _ready() -> void:
	death_label.hide()
	win_label.hide()
	if home_label:
		home_label.hide()
	if message_label:
		message_label.show()
		await get_tree().create_timer(5.0).timeout
		if not dead and not won:
			message_label.hide()

func reach_home() -> void:
	if won or dead:
		return
	won = true
	velocity = Vector2.ZERO
	if message_label:
		message_label.hide()
	if home_label:
		home_label.show()

func _physics_process(delta: float) -> void:
	if dead or won:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if global_position.y > FALL_LIMIT:
		die()
		
func die() -> void:
	if dead or won:
		return
	dead = true
	velocity = Vector2.ZERO
	if message_label:
		message_label.hide()
	death_label.show()
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()

func win() -> void:
	if won or dead:
		return
	won = true
	velocity = Vector2.ZERO
	win_label.show()


func _on_door_body_entered(body: Node2D) -> void:
	if body == self:
		get_tree().change_scene_to_file("res://overworld.tscn")
		
func _on_home_body_entered(body:Node2D) -> void:
	if body == self:
		reach_home()
