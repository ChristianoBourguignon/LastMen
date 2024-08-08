extends CharacterBody2D

@export var speed: float = 4.0
@export var swordDamage: int = 2
@onready var playerSprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var swordArea: Area2D = $SwordArea
var is_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
# Obtendo as teclas de movimento
var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")


func _physics_process(delta):
	# Obtendo as teclas de movimento
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Movimentando o player
	var playerVelocity = direction * speed *100.0
	if is_attacking:
		playerVelocity *= 0.25
	velocity = lerp(velocity, playerVelocity, 0.1)
	move_and_slide()
	
	# tocar animação
	animationPlayerPlay()
	
	# Girar player
	flipPlayer()
	
	# Animação de atacar
	if Input.is_action_just_pressed("attack"):
		attack()

func _process(delta: float):
	GameManager.playerPosition = position
	# Atualizar o temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("stand-by")


func animationPlayerPlay():
	# Tocando a animação.
	var was_running = is_running
	is_running = not direction.is_zero_approx()
	
	# Verificando se há animação tocando e não estiver atacando.
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				if not animation_player.is_playing() or animation_player.current_animation != "walk":
					animation_player.play("walk")
			else:
				if not animation_player.is_playing() or animation_player.current_animation != "stand-by":
					animation_player.play("stand-by")
					
func flipPlayer():
	
	# Virando o player
	if not is_attacking:
		if direction.x > 0:
			playerSprite.flip_h = false
		elif direction.x < 0:
			playerSprite.flip_h = true

func attack():
	if is_attacking:
		return
	
	# Tocar a animação na direção certa
	if direction.y < 0:
		animation_player.play("attack_up_1")
	elif direction.y > 0:
		animation_player.play("attack_down_1")
	else:
		animation_player.play("attack_side_1")
	
	# Cooldown attack
	attack_cooldown = 0.6
	is_attacking = true
	
func amountSwordDamage():
	# get_tree = obtem a arvore de nodes
	# get_node_in_group = obtem nodes do mesmo grupo.
	
	#var enemies = get_tree().get_nodes_in_group("enemies")
	var bodyEnemy = swordArea.get_overlapping_bodies()
	for body in bodyEnemy:
		if body.is_in_group("enemies"):
			
			# Armazenar a classe de inimigos e nomear-los como body
			var enemy: EnemyClass = body
			
			# Calcular a direção do inimigo em relação ao player
			var directionEnemy = (body.position - position).normalized()
			var directionAttack: Vector2
			
			# Pega a direção que está atacando
			if direction.y < 0:
				directionAttack = Vector2.UP
			elif direction.y > 0:
				directionAttack = Vector2.DOWN
			else:
				if playerSprite.flip_h:
					directionAttack = Vector2.LEFT
				else:
					directionAttack = Vector2.RIGHT

			# Calcular o produto escalar (dot product) entre a direção do inimigo e a direção do ataque
			var dotProduct = directionEnemy.dot(directionAttack)
			print("Dot: ", dotProduct)

			# Verificar se o ataque está na direção correta e dentro do intervalo esperado do produto escalar
			if directionAttack == Vector2.UP:
				# Para ataques para cima, dotProduct deve estar entre 0.5 e 1.0
				# Não funcional
				if dotProduct >= 0.5:
					body.damage(swordDamage)
					
			elif directionAttack == Vector2.DOWN:
				# Para ataques para baixo, dotProduct deve estar entre 0.5 e 1.0
				if dotProduct >= 0.5:
					body.damage(swordDamage)
					
			elif directionAttack == Vector2.LEFT:
				# Para ataques para a esquerda, dotProduct deve estar entre 0.5 e 1.0
				if dotProduct >= 0.5:
					body.damage(swordDamage)
					
			elif directionAttack == Vector2.RIGHT:
				# Para ataques para a direita, dotProduct deve estar entre 0.5 e 1.0
				if dotProduct >= 0.5:
					body.damage(swordDamage)
