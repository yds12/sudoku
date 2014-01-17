class Pattern < Array
  def set board
    self.each_with_index { |v, i| board.set(i, 0) if v }
    board
  end
end
