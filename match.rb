require './generator'
require './pattern'

class Match
  attr_reader :board, :win, :ellapsed

  def initialize
    @difficulty = :easy
    @mode = :random
    @board = Generator.new.generate(@mode, @difficulty)
    @pattern = Pattern.from_board @board
    @pattern.set @board

    # @solution = @board.deep_copy
    @win = false
    @t0 = Time.now
    puts @t0
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
