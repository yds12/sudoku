Size = 9
Sqrt = (Math.sqrt Size).to_i

class Object
  def deep_copy
    Marshal.load(Marshal.dump self)
  end
end

class Array
  def replace a, b
    self.map do |i|
      if i == a
        b
      else
        i
      end
    end
  end
end
