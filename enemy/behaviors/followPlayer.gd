extends Node

#Definindo a velocidade
@export var speed: float = 1.0

#Armazenando o sprite de animação em uma variável
var spriteEnemy: AnimatedSprite2D
var enemy: Enemy

func _ready():
	#pegando o node raiz (no caso é o PAWN)
	enemy = get_parent()
	#acessando o AnimationSprite2D dentro do node raiz (PAWN)
	spriteEnemy = enemy.get_node("EnemyAnimation")

func _physics_process(delta):
	#obtendo a posição do player, através do nodepath e a função get_position()
	var playerPosition = GameManager.playerPosition
	
	#calculando a diferença do vetor da posição do player - a posição do inimigo
	var difference = playerPosition - enemy.position
	
	#normalizando o valor da diferênça para mover o inimigo
	var moveEnemy = difference.normalized()
	
	#calculando a velocidade de movimento.
	enemy.velocity = moveEnemy * speed * 100.0
	enemy.move_and_slide()
	
	# rotacionar o inimigo de acordo com a posição do player.
	rotateEnemy(moveEnemy.x)
	
func rotateEnemy(direction):
	if direction > 0:
		spriteEnemy.flip_h = false
	elif direction < 0:
		spriteEnemy.flip_h = true
