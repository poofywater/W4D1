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

    def initialize(starting_pos)
        @root_node = PolyTreeNode.new(starting_pos)
        @consider_positions = [starting_pos]
        
    end


    def valid_moves(pos)
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
        valid = []
        valid_moves(pos).select do |ele|
            valid << ele if !@considered_positions.include?(ele)
            @considered_positions << ele if !@considered_positions.include?(ele)
        end
        return valid        #return array of valid places that we haven't been to yet 
    end

    def build_move_tree
        queue = new_move_positions(KnightPathFinder.starting_pos)
        enqueue = queue.last    #back of line
        dequeue = queue.first   #front of line

        new_possible = new_move_positions(dequeue)
        queue << new_possible


    end


end

# SUCK IT


knight1 = KnightPathFinder.new([0,0])
knight2 = KnightPathFinder.new([8,8])
p knight1.class.valid_moves([0,0])
p knight2.class.valid_moves([8,8])
p knight2.valid_moves([4,4])