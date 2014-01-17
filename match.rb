require './generator'
require './pattern'

class Match
  attr_reader :board

  def initialize
    @board = Generator.new.generate
    @solution = @board.deep_copy
    
    @pattern = Pattern.new
    p @pattern
    @pattern.set @board
    @board.show_pretty
    @solution.show_pretty
  end

  def set_number line, col, value
    @board[line][col] = value
  end

  def erase line, col
    @board[line][col] = 0
  end

  def fixed_cell? line, col
    @pattern[line * Size + col]
  end
end
