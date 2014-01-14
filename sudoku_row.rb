class SudokuRow < Array
  def repeat?
    self.size != self.uniq.size
  end

  def valid?
    return false if repeat?
    self.each { |i| return false unless (1..Size).include? i }
    return true
  end
end
