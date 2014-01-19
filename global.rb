Size = 9
Squares = Size * Size
Sqrt = (Math.sqrt Size).to_i
Numbers = (1..Size)

def with_time
  t1 = Time.now
  yield
  Time.now - t1
end

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
