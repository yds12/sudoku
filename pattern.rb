require './global'

class Pattern < Array
  def initialize difficulty, arr = nil
    if arr.nil?
      arr = from_file difficulty
    end

    super arr 
  end

  def set board
    self.each_with_index { |v, i| board.set(i, 0) unless v }
    board
  end

private

  def random difficulty
    r = Random.new
    blocks = []

    blocks << Proc.new { |i| i % 2 == 0 }
    blocks << Proc.new { r.rand(3) == 0 }
    blocks << Proc.new { r.rand(2) == 1 }
    blocks << Proc.new { |i| i % 3 == 0 && (i / 9) % 3 != 1 || i % 5 + 1 == 1 }
  
    blk = blocks.shuffle[0]
    arr = Array.new(Size * Size, &blk)
  end

  def from_file difficulty
    r = Random.new
    filename = "data/pattern/#{difficulty.to_s}.txt"

    f = File.open(filename)
    n_patterns = f.readline.chomp.to_i
    selected = r.rand n_patterns

    # read until the selected pattern
    ((Size + 1) * selected).times { f.readline }

    s = ''
    f.readline
    Size.times { s << f.readline.chomp }
    f.close

    s.chars.map { |i| i != '.' }
  end
end
