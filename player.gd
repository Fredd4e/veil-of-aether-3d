extends CharacterBody3D

@export var speed = 8.0
@export var jump_velocity = 12.0

var gravity = 9.8

@onready var particles = $GPUParticles3D

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta
    
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
    
    # Magic
    if Input.is_action_just_pressed("cast_fireball"):
        cast_spell("fireball")
    elif Input.is_action_just_pressed("cast_iceshard"):
        cast_spell("iceshard")
    elif Input.is_action_just_pressed("cast_heal"):
        cast_spell("heal")

func cast_spell(spell):
    print("Casting: " + spell)
    particles.emitting = true
    await get_tree().create_timer(0.6).timeout
    particles.emitting = false