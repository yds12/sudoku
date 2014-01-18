require './global'

class Pattern < Array
  def initialize arr = nil
    arr = Array.new(Size * Size) { false } if arr.nil?
    super arr 
  end

  def set board
    self.each_with_index { |v, i| board.set(i, 0) unless v }
    board
  end

  def self.random difficulty
    r = Random.new
    blocks = []

    blocks << Proc.new { |i| i % 2 == 0 }
    blocks << Proc.new { r.rand(3) == 0 }
    blocks << Proc.new { r.rand(2) == 1 }
    blocks << Proc.new { |i| i % 3 == 0 && (i / 9) % 3 != 1 || i % 5 + 1 == 1 }
  
    blk = blocks.shuffle[0]
    arr = Array.new(Size * Size, &blk)
    Pattern.new arr
  end

  def self.from_file difficulty, index = nil
    r = Random.new
    filename = "data/pattern/#{difficulty.to_s}.txt"

    f = File.open(filename)
    n_patterns = f.readline.chomp.to_i
    selected = index.nil? ? r.rand(n_patterns) : index

    # read until the selected pattern
    ((Size + 1) * selected).times { f.readline }

    s = ''
    f.readline
    Size.times { s << f.readline.chomp }
    f.close

    arr = s.chars.map { |i| i != '.' }
    Pattern.new arr
  end

  def self.from_board board
    arr = Array.new(Size * Size) { false }
    board.all_values.each_with_index { |v, i| arr[i] = ((1..Size).include? v) }
    Pattern.new arr
  end
end
