extends CharacterBody2D

@export var speed := 180.0

# 점프/중력
@export var gravity := 1200.0
@export var fall_gravity := 1800.0      # 하강 시 더 강한 중력(체감 좋음)
@export var jump_velocity := 420.0      # 점프 초기 속도(위로)
@export var jump_cut_multiplier := 0.45 # 점프 중 버튼 떼면 상승 속도 컷(가변 점프)

# 2단 점프
@export var max_jump := 2
var jump_count := 0

func _physics_process(delta: float) -> void:
	var input := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	# 방향 전환(공중/지상 공통)
	if input != 0:
		$Sprite2D.flip_h = input < 0

	# 좌우 이동
	velocity.x = input * speed

	# 바닥에 닿으면 점프 횟수 리셋
	if is_on_floor():
		jump_count = 0

	# 점프(바닥/공중 공통): 최대 max_jump번
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jump:
		jump_count += 1
		velocity.y = -jump_velocity

	# 가변 점프: 상승 중 버튼을 떼면 상승 속도 줄이기
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

	# 중력 적용(상승/하강 분리)
	if not is_on_floor():
		var g := gravity if velocity.y < 0 else fall_gravity
		velocity.y += g * delta

	# 애니메이션
	if not is_on_floor():
		$anim.play("Jump" if velocity.y < 0 else "Fall")
	elif input != 0:
		$anim.play("Walk")
	else:
		$anim.play("Idle"  )

	move_and_slide() 
