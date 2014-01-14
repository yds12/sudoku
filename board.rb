require './global'
require './sudoku_row.rb'

class Board

  attr_reader :matrix, :lines, :columns, :squares

  def initialize
    @matrix = Array.new(Size) { SudokuRow.new(Size) { 0 } }
  end

  def lines
    @matrix
  end

  def [] index
    @matrix[index]
  end

  def columns
    m = []
    @matrix.transpose.each { |l| m << SudokuRow.new(l)  }
    m
  end

  def shuffle!
    @matrix.shuffle!
    self
  end

  def swap_lines a, b
    #l = SudokuRow.new(lines[a])
    #lines[a] = SudokuRow.new(lines[b])
    #lines[b] = l
    
    lines[a], lines[b] = lines[b], lines[a]
  end

  def fill_valid
    Size.times { |i| Size.times { |j| @matrix[i][j] = (i + j) % Size + 1 } }
    swap_lines 1, 3
    swap_lines 2, 6
    swap_lines 5, 7
  end

  def valid?
    lines.each { |i| return false unless i.valid? }
    columns.each { |i| return false unless i.valid? }
    squares.each { |i| return false unless i.valid? }
    return true
  end

  def squares
    m = Array.new

    Size.times do |i|
      l = i/Sqrt * Sqrt
      min = (i % Sqrt) * Sqrt
      range = min..(min + 2)
      m << SudokuRow.new(@matrix[l][range] + 
                         @matrix[l + 1][range] +
                         @matrix[l + 2][range])
    end

    m
  end

  def show
    lines.each { |s| puts s.join(" ") }
  end
  
  def show_pretty
    puts

    lines.each_with_index do |l, i|
      l.each_slice(Sqrt) do |s|
        print s.join(" ") + "   "
      end
      puts
      puts if i % Sqrt == Sqrt - 1
    end

    nil
  end
end
