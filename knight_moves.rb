class Pathfinder
  def initialize
    @possible_moves = [
      [-2,1], [-2,-1], [-1,2], [-1,-2], [1,2], [1,-2], [2,1], [2,-1]  # possible vectors of knight movements
    ]
  end
  
  public
  
  def knight_moves (start, target)
    return "Invalid coordinates!" unless coords_valid?(start) && coords_valid?(target)
    # initialize the queue
    queue = []
    visited_positions = [start]
    # build graph while searching
    root = Node.new(start)
    # check if starting position is the target position
    if start == target
      puts "Initial and target positions are the same!"
      return nil
    else
      # find possible positions reachable directly from the current one
      mark_as_visited(root, visited_positions, queue)
      until queue.empty?
      # search for target position layer by layer
        current_node = queue.shift
        if current_node.value == target
          path = recreate_path(current_node)
          results = describe_movement(path)
          return path
        else
          # enqueue subsequent valid positions
          mark_as_visited(current_node, visited_positions, queue)
        end
      end
    end
  end
  
  private
  
  def coords_valid? (coords)
    return coords.none? { |n| n < 0 || n > 7 }
  end
  
  def mark_as_visited (root, visited_positions, queue)
    # build graph while searching for target position, mark valid positions as visited and enqueue new node
    @possible_moves.each do |mod|
      new_position = [mod[0] + root.value[0], mod[1] + root.value[1]]
      if coords_valid?(new_position) && !visited_positions.include?(new_position)
        new_node = Node.new(new_position, root)
        root.children << new_node
        queue << new_node
        visited_positions << new_position
      end
    end
  end
  
  def recreate_path (target_node, path=[])
    unless target_node.parent # root reached, start adding elements to path
      return path << target_node.value 
    end
    # update path and add current coordinates
    path = recreate_path(target_node.parent, path)
    path << target_node.value
    return path
  end
  
  def describe_movement (path)
    # print results
    if path.length-1 == 1
      filler = "1 move"
    else
      filler = "#{path.length-1} moves"
    end
    puts "You made it in #{filler}! Here's your path:"
    path.each do |step|
      p step
    end
  end
  
  class Node
    attr_reader :value
    attr_accessor :children, :parent
    def initialize (root, parent=nil)
      @value = root
      @parent = parent
      @children = []
    end
  end
  
end

test = Pathfinder.new
test.knight_moves([0,0],[1,2])
test.knight_moves([0,0],[3,3])
test.knight_moves([3,3],[0,0])
