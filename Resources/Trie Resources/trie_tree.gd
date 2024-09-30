class_name TrieTree
extends Node



# The root of the trie
var root := TrieNode.new()


# Insert a combo into the Trie
func insert(combo: Array[StringName]) -> bool:
	
	# Get the root of the tree
	var curr_node: TrieNode = root;
	
	# Now we need to traverse the tree, only adding new Nodes when there is no more traversing possible
	for action: StringName in combo:
		# No more traversing possible, start adding new TreiNodes
		if action not in curr_node.children.keys():
			var new_node: TrieNode = TrieNode.new();
			
			curr_node.children[action]
			

# Search if the given sequence is a valid combo
func search(combo: Array) -> bool:
	var node = root
	for key in combo:
		if key not in node.children:
			return false
		node = node.children[key]
	return node.is_end_of_combo

