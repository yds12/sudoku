require './pattern'

describe Pattern do
  before do
    a = Array.new(Size*Size) { true }
    @p = Pattern.new a
  end

  subject { @p }

  it { should respond_to(:set) }

  it 'should corretly set the gaps in the board' do
    b = Generator.new.generate
    b2 = b.deep_copy.all_values

    @p[1] = false
    @p[49] = false
    @p.set b

    b.all_values.each_with_index do |v, i|
      if @p[i]
        v.should eq(b2[i])
      else
        (1..Size).should_not include(v)
      end
    end
  end    
end
