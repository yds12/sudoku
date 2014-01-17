class Pattern < Array
  def initialize arr = nil
    if arr.nil?
      r = Random.new
      blocks = []

      blocks << Proc.new { |i| i % 2 == 0 }
      blocks << Proc.new { r.rand(3) == 0 }
      blocks << Proc.new { r.rand(2) == 1 }
      blocks << Proc.new { |i| i % 3 == 0 && (i / 9) % 3 != 1 || i % 5 + 1 == 1 }
      
      blk = blocks.shuffle[0]
      arr = Array.new(Size * Size, &blk)
    end

    super arr 
  end

  def set board
    self.each_with_index { |v, i| board.set(i, 0) unless v }
    board
  end
end
