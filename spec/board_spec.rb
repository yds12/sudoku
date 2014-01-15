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

  it 'should build correct peers list' do
    9.times do |i|
      @b[0][i] = 4
      @b[i][0] = 5
      @b[i/3][i%3] = 3
    end

    @b.get_peers(0).sort.should eq([3, 4, 5])
    
    b2 = Board.new
    b2[1][5] = 9
    b2[4][8] = 8
    b2[3][3] = 1
    b2[6][3] = 2

    b2.get_peers(41).sort.should eq([1, 8, 9])
  end
end
