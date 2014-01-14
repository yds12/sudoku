require './board'

describe Board do
  before { @b = Board.new }

  subject { @b }
  it { should respond_to(:matrix) }
  it { should respond_to(:lines) }
  it { should respond_to(:columns) }
  it { should respond_to(:squares) }

  it 'should create a matrix' do
    @b.matrix.should be_a_kind_of(Array)
    @b[0].should be_a_kind_of(Array)
  end

  it 'should build correct squares' do
    9.times { |i| @b[i/3][i%3] = i + 1 }
    @b.squares[0].should eq([1,2,3,4,5,6,7,8,9])

    9.times { |i| @b[3 + i/3][3 + i%3] = i + 10 }
    @b.squares[4].should eq([10,11,12,13,14,15,16,17,18])
  end
end
