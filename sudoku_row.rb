class SudokuRow < Array
  def repeated?
    Size.times { |i| return true if self.count(i + 1) > 1  }
    return false
  end

  def valid?
    return false if repeated?
    self.each { |i| return false unless (1..Size).include? i }
    return true
  end
end
