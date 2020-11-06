extends ItemList

var ItemListContent = ["We shall go this way","We shall go that way","which way shall we go?","I think we're lost"]

func _ready():
	#Load the ItemList by stepping through it and adding each item.
	for ItemID in range(4):
		add_item(ItemListContent[ItemID],null,true)

	select(0,true)
