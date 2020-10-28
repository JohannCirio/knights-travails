require 'pry'
SET = 0..7

class Vertex
  attr_accessor :x_value, :y_value, :adjacency_list, :distance, :predecessor
  def initialize(x_coordinate, y_coordinate)
    @x_value = x_coordinate
    @y_value = y_coordinate
    @adjacency_list = []
    @distance = nil
    @predecessor = nil
  end

  def add_adjacent_vertex(vertex)
    @adjacency_list.push(vertex)
  end

  def print_vertex_adjacency_list
    puts "adjacency list length: #{@adjacency_list.length}"
    @adjacency_list.each do |vertex|
      puts "[#{vertex.x_value}, #{vertex.y_value}]"
    end
  end
   
end

class BoardGraph
  attr_accessor :tiles
  def initialize
    @tiles = []
    SET.each do |x_coordinate|
      SET.each do |y_coordinate|
        @tiles.push(Vertex.new(x_coordinate, y_coordinate))
      end
    end
    add_knight_moves
  end

  def find_tile(x_coordinate, y_coordinate)
    @tiles.find { |tile| tile.x_value == x_coordinate && tile.y_value == y_coordinate}
  end

  def add_knight_moves
    @tiles.each do |tile|
      up1_moves(tile)
      up2_moves(tile)
      down1_moves(tile)
      down2_moves(tile)
    end
  end

  def up1_moves(tile)
    up1_y_coordinate = tile.y_value + 1
    if up1_y_coordinate <= 7
      left2_x_coordinate = tile.x_value - 2
      right2_x_coordinate = tile.x_value + 2
      tile.adjacency_list.push(find_tile(left2_x_coordinate, up1_y_coordinate)) if left2_x_coordinate >= 0
      tile.adjacency_list.push(find_tile(right2_x_coordinate, up1_y_coordinate)) if right2_x_coordinate <= 7
    end
  end

  def up2_moves(tile)
    up2_y_coordinate = tile.y_value + 2
    if up2_y_coordinate <= 7
      left1_x_coordinate = tile.x_value - 1
      right1_x_coordinate = tile.x_value + 1
      tile.adjacency_list.push(find_tile(left1_x_coordinate, up2_y_coordinate)) if left1_x_coordinate >= 0
      tile.adjacency_list.push(find_tile(right1_x_coordinate, up2_y_coordinate)) if right1_x_coordinate <= 7
    end
  end

  def down1_moves(tile)
    down1_y_coordinate = tile.y_value - 1
    if down1_y_coordinate >= 0
      left2_x_coordinate = tile.x_value - 2
      right2_x_coordinate = tile.x_value + 2
      tile.adjacency_list.push(find_tile(left2_x_coordinate, down1_y_coordinate)) if left2_x_coordinate >= 0
      tile.adjacency_list.push(find_tile(right2_x_coordinate, down1_y_coordinate)) if right2_x_coordinate <= 7
    end
  end

  def down2_moves(tile)
    down2_y_coordinate = tile.y_value - 2
    if down2_y_coordinate >= 0
      left1_x_coordinate = tile.x_value - 1
      right1_x_coordinate = tile.x_value + 1
      tile.adjacency_list.push(find_tile(left1_x_coordinate, down2_y_coordinate)) if left1_x_coordinate >= 0
      tile.adjacency_list.push(find_tile(right1_x_coordinate, down2_y_coordinate)) if right1_x_coordinate <= 7
    end
  end

  def bfs(root_vertex)
    queue = []
    root_vertex.distance = 0
    root_vertex.adjacency_list.each do |adj_vertex|
      adj_vertex.predecessor = root_vertex
      queue.push(adj_vertex)
    end
    until queue.empty?
      current_element = queue.shift
      current_element.distance = current_element.predecessor.distance + 1
      current_element.adjacency_list.each do |adj_vertex|
        if adj_vertex.distance.nil?
          adj_vertex.predecessor = current_element
          queue.push(adj_vertex)
        end
      end
    end
    root_vertex
  end

  def board_reset
    @tiles.each do |vertex|
      vertex.distance = nil
      vertex.predecessor = nil
    end
  end

  def knight_travails(initial_knight_position, final_knight_position)
    start_point = find_tile(initial_knight_position[0], initial_knight_position[1])
    end_point = find_tile(final_knight_position[0], final_knight_position[1])
    board_reset
    bfs(start_point)
    movements_list = []
    current_tile = find_tile(final_knight_position[0], final_knight_position[1])
    until current_tile.distance == 0
      movements_list.prepend(current_tile)
      current_tile = current_tile.predecessor
    end
    movements_list.prepend(current_tile)
    movements_list.each do |tile|
      print "[#{tile.x_value}, #{tile.y_value}]  "
    end
    print "\n"
  end

  def print_distances
    @tiles.each do |tile|
      puts "[#{tile.x_value}, #{tile.y_value}] =====> #{tile.distance}"
    end
  end
end



board = BoardGraph.new

board.knight_travails([0,0],[1,2])
board.knight_travails([0,0],[3,3])
board.knight_travails([3,3],[0,0])




