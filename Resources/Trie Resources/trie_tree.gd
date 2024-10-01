class_name TrieTree
extends Resource

# The root of the trie
@export var root := TrieNode.new()


# Insert a combo into the Trie
func insert(combo: Array[InputAction], animation: Animation) -> void:
	
	
	# Get the root of the tree
	var curr_node: TrieNode = root;
	
	# Now we need to traverse the tree, only adding new Nodes when there is no more traversing possible
	for action: InputAction in combo:
		# No more traversing possible, start adding new TreiNodes
		if action not in curr_node.children.keys():
			# Create new Trie Node and add it to children of current node
			var new_node: TrieNode = TrieNode.new();
			curr_node.children[action] = new_node;
			curr_node.leaf_node = false;
			
		# Traverse to next node in Trie Tree
		curr_node = curr_node.children[action]
		
	# Once we reach the end, mark it as lead node and save animation
	curr_node.leaf_node = true;
	curr_node.animation = animation;
	
func remove(combo: Array[InputAction]) -> void:
	pass


# Search if the given sequence is a valid combo
func search(combo: Array[InputAction]) -> Animation:
	# Get the root of the tree
	var curr_node: TrieNode = root;
	
	# Traverse and see if valid
	for action: InputAction in combo:
		if action not in curr_node.children.keys():
			return null;
		curr_node = curr_node.children[action]
		
	# Finally, we check if leaf node and return Animation
	if curr_node.leaf_node:
		return curr_node.animation
	else:
		return null;

