extends ItemList

@export var party_size: int = 10;
@export var black_icon: Texture2D;

var characters : Array[PartyMember];

func _ready() -> void:
	for i in party_size:
		add_item(" ",black_icon);
		characters.append(null);
	item_clicked.connect(on_character_click);

func fill_party(party: Array[PartyMember])->void:
	for num in party.size():
		characters[num] = party[num];
		set_item_icon(num,party[num].Icon)
		print("Filling party!")
		print(num)


func remove_character(index : int) -> void:
	if index < 0 || index >= party_size:
		return;
	characters[index] = null;
	set_item_icon(index, black_icon);
	set_item_text(index, " ");


func get_character(index : int) -> PartyMember:
	if index < 0 || index >= party_size:
		return;
	return characters[index];


func on_character_click(index:int, pos:Vector2, mouse_button_index:int)->void:
	if mouse_button_index == 1:
		var character = get_character(index);
		if character == null:
			print("No character selected!");
			return;
		print("Character selected");
