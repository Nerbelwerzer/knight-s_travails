require 'pry'

class Board
  attr_accessor :x, :y, :neighbours, :name, :last
  def initialize(x, y)
    @x = x
    @y = y
    @neighbours = []
    @name = "#{x}, #{y}"
    @last = nil
  end
end

class Knight
  def initialize(start, target)
    @squares = create_board
    @start = find_square(start)
    @target = find_square(target)
  end

  def sally_forth
    fair_maid = find_thy_fair_maid(@start, @target)
    find_path(fair_maid)
  end

  def create_board
    @squares = []
    (0..7).each do |i|
      (0..7).each do |j|
        @squares << Board.new(j, i)
      end
    end

    @squares.each do |square|
      add_possible_moves(square.x + 1, square.y + 2, square)
      add_possible_moves(square.x + 1, square.y - 2, square)
      add_possible_moves(square.x + 2, square.y + 1, square)
      add_possible_moves(square.x + 2, square.y - 1, square)
      add_possible_moves(square.x - 1, square.y + 2, square)
      add_possible_moves(square.x - 1, square.y - 2, square)
      add_possible_moves(square.x - 2, square.y + 1, square)
      add_possible_moves(square.x - 2, square.y - 1, square)
    end
  end

  def add_possible_moves(x, y, square)
    @squares.select do |i|
      square.neighbours << i if i.x == x && i.y == y
    end
  end

  def find_square(coord)
    for i in @squares do
      return i if i.name == coord
    end
  end

  def find_thy_fair_maid(start, target)
    visited = [start]
    queue = [start]

    until queue.empty?
      current_node = queue.shift

      return current_node if current_node == target

      current_node.neighbours.each do |square|
        next if visited.include?(square)
        square.last = current_node
        visited << square
        queue << square
      end
    end
  end

  def find_path(target)
    path = [target.name]
    node = target.last
    loop do
      path << node.name
      node = node.last
      break if node.nil?
    end

    puts "Quest completed in #{(path.length) -1} moves!\n[#{path.reverse.join('] -> [')}]"
  end
end

puts "Enter start location like so: 'x, y'."
start = gets.chomp
puts "Enter an end location in the same manner:"
target = gets.chomp

sir_rubin = Knight.new(start, target)

sir_rubin.sally_forth
