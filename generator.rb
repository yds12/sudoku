require './board'
require './solver'

class Generator
  def generate
    board = Board.new
    Solver.new.solve board
  end

  def generate_by_step by_step = true
    board = Board.new
    s = Solver.new
    s.by_step = by_step
    s.solve board
  end
end
