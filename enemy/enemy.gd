class_name EnemyClass
extends Node2D

@export var health: int = 10

func damage(amount: int):
	health -= amount
	print("Amount: ", amount ," Health: ", health)
