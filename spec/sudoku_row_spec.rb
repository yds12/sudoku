require './sudoku_row'

describe SudokuRow do
  before { @r = SudokuRow.new(9) { |i| i + 1 } }
  subject { @r }

  it { should respond_to(:valid?) }
  it { should respond_to(:repeat?) }

  it { should be_valid }

  it 'should not allow elements other than 0-9' do
    @r[0] = nil
    @r.should_not be_valid

    @r[0] = 0
    @r.should_not be_valid

    @r[0] = 10
    @r.should_not be_valid
  end

  it 'should not allow repeated elements' do
    @r[0] = 1
    @r[1] = 1
    @r.should_not be_valid
  end
end
