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
        puts 'Value is already in the tree. Insertion stopped'
        return curr
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

def pretty_print(node = @root, prefix = '', is_left = true)
  pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
  puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
  pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
end

arr = [1, 2, 3, 3, 4, 5, 6, 7]
tree = Tree.new(arr)
pretty_print(tree.root)
