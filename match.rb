require './generator'
require './pattern'

class Match
  attr_reader :board, :win, :ellapsed

  def initialize
    @board = Generator.new.generate
    @solution = @board.deep_copy
    @win = false
    @t0 = Time.now
    puts @t0
    
    @difficulty = :easy
    @pattern = Pattern.new @difficulty
    @pattern.set @board
  end

  def set_number line, col, value
    @board[line][col] = value
    if @board.valid?
      @win = true
      @ellapsed = Time.now - @t0
    end
  end

  def erase line, col
    @board[line][col] = 0
  end

  def fixed_cell? line, col
    @pattern[line * Size + col]
  end
end
