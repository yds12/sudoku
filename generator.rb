require './board'
require './solver'
require './pattern'

class Generator
  def generate mode = :random, difficulty = :easy
    b = nil
    s = Solver.new
    count = 0

    t = with_time do
      while b.nil? or count != 1
        begin
          case mode
            when :random then b = random difficulty
            when :pattern then b = pattern difficulty
            when :board then b = board difficulty
          end

          count = s.count_solutions(b, 2)
        rescue
          b = nil
        end
      end
    end

    num = b.all_values.inject(0) { |v, i| Numbers.include?(i) ? v + 1 : v }
    puts "#{num} fixed squares"
    puts "Sudoku board generated in #{t.round(2)} seconds"
    b
  end

  def generate_by_step by_step = true
    board = Board.new
    s = Solver.new
    s.by_step = by_step
    s.solve board
  end

private

  def random difficulty
    board = get_board
    p = Pattern.random difficulty
    p.set board
  end

  def pattern difficulty
    board = get_board
    p = Pattern.from_file difficulty
    p.set board
  end

  def board difficulty
    Board.from_file difficulty
  end

  def get_board
    Solver.new.solve Board.new
  end
end
