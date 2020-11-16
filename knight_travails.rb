require 'byebug'

class PolyTreeNode

    attr_reader :parent, :value, :children

    def initialize(value)
        @value = value
        @parent = nil
        @children = []
    end 

    def parent=(new_parent)
        # remove self from parents children?
        # if @parent != nil

        @parent.children.delete(self) if @parent != nil
        @parent = new_parent
        @parent.children << self if @parent != nil
        # add self to @parent.children
    
    end

    def add_child(child)
        child.parent = self
    end

    def remove_child(child)
        if !@children.include?(child)
            raise "not a child"
        else
        child.parent = nil 
        end
    end

    def inspect
        @value.inspect
    end

    def dfs(target_value)
        return nil if self == nil
        return self if self.value == target_value

        @children.each do |child|
            result = child.dfs(target_value)
            return result unless result == nil
        end

        return nil
    end

    def bfs(target_value)
        queue = []
        queue << self

        while !queue.empty?
            pficb = queue.shift
            return pficb if pficb.value == target_value
            
            pficb.children.each do |child|
                queue << child
            end
        end

    end

end


class KnightPathFinder

    # current position 0,0 
    #here is our current position
    #run 8 iterations, 
    #is it on the board?
    #have we stepped on it before? (consider positions)
    #

    attr_reader :starting_pos, :considered_positions, :root_node
    # attr_accessor :root

    def initialize(starting_pos)
        @starting_pos = starting_pos
        @root_node = PolyTreeNode.new(starting_pos)
        @considered_positions = [starting_pos]
        # @root = nil        
    end


    def self.valid_moves(pos)
        iterations = [[-2,1],[-1,2],[1,2],[2,1],[2,-1],[1,-2],[-1,-2],[-2,-1]]
        row, col = pos
      
        valid_pos = []

        iterations.each do |move|
          r, c = move
          valid = []
          if row + r <= 7 && row + r >= 0
            valid << row + r
          end
          if col + c <= 7 && col + c >= 0
            valid << col + c
          end
        
        valid_pos << valid if valid.length == 2
        end

        return valid_pos
    end
    
    def new_move_positions(pos)
        # debugger
        valid = []
        # debugger
        if !KnightPathFinder.valid_moves(pos).nil?
            # debugger
            KnightPathFinder.valid_moves(pos).select do |ele|
                # debugger
                valid << ele if !considered_positions.include?(ele)
                # debugger
                considered_positions << ele if !considered_positions.include?(ele)
            end
        end
        return valid        #return array of valid places that we haven't been to yet 
    end

    def build_move_tree
        # self.root_node = PolyTreeNode.new(starting_pos)
        queue = [root_node]

        while !queue.empty?
            first_node = queue.shift
            new_moves = new_move_positions(first_node.value)

            new_moves.each do |move|
                node = PolyTreeNode.new(move)
                first_node.add_child(node)
                queue << node
            end
        end
    
    end

    def find_path(end_pos)
        build_move_tree
        end_node = @root_node.dfs(end_pos) 
        trace_path_back(end_node)
    end

    def trace_path_back(end_node)
        path = [end_node]

        until path.include?(@root_node)
            path << path.last.parent
        end
        return path.reverse
    end
end



knight1 = KnightPathFinder.new([0,0])
p knight1.class.valid_moves([0,0])
p knight1.build_move_tree
p knight1.root_node
p kpf = KnightPathFinder.new([0, 0])
p kpf.find_path([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
p kpf.find_path([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]