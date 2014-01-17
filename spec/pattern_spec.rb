require './pattern'

describe Pattern do
  before do
    a = Array.new(Size*Size) { false }
    @p = Pattern.new a
  end

  subject { @p }

  it { should respond_to(:set) }

  it 'should corretly set the gaps in the board' do
    b = Generator.new.generate
    b2 = b.deep_copy.all_values

    @p[1] = true
    @p[49] = true
    @p.set b

    b.all_values.each_with_index do |v, i|
      if @p[i]
        (1..Size).should_not include(v)
      else
        v.should eq(b2[i])
      end
    end
  end    
end
