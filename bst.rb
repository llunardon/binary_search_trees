require_relative 'node.rb'

class Tree
  attr_reader :root

  def initialize(array)
    array = array.sort.uniq
    @root = build_tree(array, 0, array.length - 1)
  end

  def find(value)
    curr = @root

    until curr == nil do
      if curr.value == value
        return curr
      elsif curr.value < value
        curr = curr.right
      else
        curr = curr.left
      end
    end

    return nil
  end

  def insert(value)
    curr = @root

    until curr == nil do
      if curr.value == value
        puts 'Tried inserting a value that was already present'
        return 
      elsif curr.value < value
        prev = curr
        curr = curr.right
      else
        prev = curr
        curr = curr.left
      end
    end

    if prev.value < value
      prev.right = Node.new(value)
    else
      prev.left = Node.new(value)
    end
  end

  def remove(value)
    curr = @root

    until curr.value == value do
      if is_leaf?(curr)
        puts 'Tried to remove an element that does not exist'
        return nil
      elsif curr.value < value
        parent = curr #keep track of the parent in case we have to delete the node
        parent_link = 'right' #keep track of the direction in which we are going
        curr = curr.right #move along the right direction
      else
        parent = curr #same as above, but in the left direction
        parent_link = 'left'
        curr = curr.left
      end
    end

    unless is_leaf?(curr)
      if curr.left != nil #if the node is't a leaf and it has a left subtree
        substitute = max_n(curr.left) #substitute[0] = maximum node in the left subtree
        curr.value = substitute[0].value #substitute[1] = parent of substitute[0]
        substitute[1].right = nil #delete reference to the node
      else #if the node isn't a leaf but it doesn't have a left subtree
        substitute = curr.right #same as above, but in the right direction
        curr.value = substitute.value
        curr.right = substitute.right
      end
    else #if the node is a leaf
      if parent_link == 'left'
        parent.left = nil
      elsif parent_link == 'right'
        parent.right = nil
      end
    end
  end

  def level_order()
    curr = @root
    queue = []
    visited_nodes = []

    queue.push(curr) #initialize the queue array

    until queue.length == 0 do
      visited_nodes.push(curr.value) #visit the current node
      queue.push(curr.left) if curr.left != nil #enque children if they exist
      queue.push(curr.right) if curr.right != nil
      queue.shift #deque the visited node
      curr = queue[0] #visit the next node in line
    end

    visited_nodes
  end

  def inorder(node, visited_nodes)
    if is_leaf?(node) #base case
      visited_nodes.push(node.value)
      return
    end

    inorder(node.left, visited_nodes) #recursive call on left subtree

    visited_nodes.push(node.value) #visit current node

    inorder(node.right, visited_nodes) #recursive call on right subtree

    visited_nodes
  end

  def preorder(node, visited_nodes)
    visited_nodes.push(node.value)

    unless is_leaf?(node)
      preorder(node.left, visited_nodes) #recursive call on left subtree
      preorder(node.right, visited_nodes) #recursive call on right subtree
    end

    visited_nodes
  end

  def postorder(node, visited_nodes)
    unless is_leaf?(node)
      postorder(node.left, visited_nodes) #recursive call on left subtree
      postorder(node.right, visited_nodes) #recursive call on right subtree
    end

    visited_nodes.push(node.value)

    visited_nodes
  end

  def height(node)
    return 0 if is_leaf?(node) #base case

    if node.left != nil
      height_left =  1 + height(node.left) 
    else
      height_left = 0
    end

    if node.right != nil
      height_right =  1 + height(node.right) 
    else
      height_right = 0
    end

    return [height_left, height_right].max
  end

  def is_leaf?(node)
    if node.left == nil && node.right == nil
      return true
    else
      return false
    end
  end
end

def build_tree(array, first, last)
  if first > last
    return
  end

  mid = (first + last) / 2
  root = Node.new(array[mid])

  root.left = build_tree(array, first, mid - 1)
  root.right = build_tree(array, mid + 1, last)

  root
end

def max_n(node)
  curr = node

  until curr.right == nil
    parent = curr
    curr = curr.right
  end

  [curr, parent]
end

def min_n(node)
  curr = node

  until curr.left == nil
    parent = curr
    curr = curr.left
  end

  [curr, parent]
end

def pretty_print(node = @root, prefix = '', is_left = true)
  pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
  puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
  pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
end

arr = [4.5, 1, 69, 34, 88, 1000, 808, 2, 3, 3, 4, 5, 6, 7, 8, 11, 9]
tree = Tree.new(arr)
pretty_print(tree.root)

#p tree.inorder(tree.root, [])
#p tree.preorder(tree.root, [])
#p tree.postorder(tree.root, [])
#p tree.height(tree.find(5))
