extends Node2D

var playerParty:Array[PartyMember]
var warrior = preload("res://Scenes/WarriorMock.tscn")
func _ready() -> void:
	# RETIRAR DEPOIS DE TESTAR
	var warrior1 = warrior.instantiate()
	var warrior2 = warrior.instantiate()
	var warrior3 = warrior.instantiate()
	var warrior4 = warrior.instantiate()
	playerParty.append(warrior1)
	playerParty.append(warrior2)
	playerParty.append(warrior3)
	playerParty.append(warrior4)
	print(playerParty)
	# RETIRAR DEPOIS DE TESTAR
	set_up_battle_interface(playerParty)

func set_up_battle_interface(party:Array[PartyMember])->void:
	var battleInterface = get_node("Control/Panel/ItemList")
	battleInterface.fill_party(party)
	print("BattleInterface has been setup.")
