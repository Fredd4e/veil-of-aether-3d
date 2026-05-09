extends CharacterBody3D

@export var speed = 7.0
@export var jump_velocity = 10.0

var gravity = 9.8

@onready var particles = $GPUParticles3D

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta * 1.5
    
    var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    if direction:
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.z = move_toward(velocity.z, 0, speed)
    
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = jump_velocity
    
    move_and_slide()
    
    if Input.is_action_just_pressed("cast_fireball"):
        cast_spell()
    elif Input.is_action_just_pressed("cast_iceshard"):
        cast_spell()
    elif Input.is_action_just_pressed("cast_heal"):
        cast_spell()

func cast_spell():
    print("Spell cast!")
    if particles:
        particles.emitting = true
        await get_tree().create_timer(0.5).timeout
        if particles:
            particles.emitting = false