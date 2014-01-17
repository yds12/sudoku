require './generator'
require './pattern'

class Match
  attr_reader :board

  def initialize
    @board = Generator.new.generate
    @solution = @board.deep_copy
    
    pattern = Pattern.new(Array.new(81){ |i| i % 2 == 0 })
    pattern.set @board
    @board.show_pretty
    @solution.show_pretty
  end
end
