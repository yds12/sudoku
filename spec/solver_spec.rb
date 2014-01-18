require './solver'
require './generator'

describe Solver do
  before { @s = Solver.new }
  subject { @s }

  it { should respond_to(:solve) }
  it { should respond_to(:count_solutions) }

  it 'should find correct solutions' do
    b = Generator.new.generate

    b00 = b[0][0]
    b33 = b[3][3]
    b66 = b[6][6]

    b[0][0] = 0
    b[3][3] = 0
    b[6][6] = 0

    @s.solve b
    
    b[0][0].should eq(b00)
    b[3][3].should eq(b33)
    b[6][6].should eq(b66)

    b = Generator.new.generate

    b44 = b[4][4]
    b[4][4] = 0
    @s.solve b
    b[4][4].should eq(b44)
  end

  it 'should find out when there is no solution' do
    b = Generator.new.generate
    b[0][0] = 1
    b[0][1] = 1
    b[0][2] = 0
    @s.solve(b).should be_false

    b = Board.new
    b[3][3] = 1
    b[3][5] = 1
    b[0][0] = 0
    @s.solve(b).should be_false

    b = Board.new
    b[1][0] = 2
    b[1][1] = 1
    b[2][3] = 2
    b[2][4] = 1
    b[3][6] = 2
    b[4][6] = 1
    b[6][7] = 2
    b[7][7] = 1
    @s.solve(b).should be_false
  end

  it 'should correctly count the solutions' do
    b = Generator.new.generate
    b[0][0] = 1
    b[0][1] = 1
    b[0][2] = 0
    @s.count_solutions(b).should eq(0)

    b = Generator.new.generate
    b[0][2] = 0
    @s.count_solutions(b).should eq(1)

    b = Generator.new.generate
    b[4][4] = 0
    @s.count_solutions(b).should eq(1)

    arr = [
      [5, 9, 1,   8, 4, 7,   6, 2, 3],   
      [4, 2, 3,   6, 9, 1,   7, 5, 8],
      [8, 6, 7,   2, 3, 5,   1, 4, 9],   

      [1, 8, 4,   3, 5, 9,   2, 7, 6],  
      [2, 3, 9,   0, 7, 6,   5, 8, 0],  
      [6, 7, 5,   0, 2, 8,   3, 9, 0], 

      [9, 5, 8,   7, 6, 3,   4, 1, 2],  
      [3, 1, 2,   5, 8, 4,   9, 6, 7], 
      [7, 4, 6,   9, 1, 2,   8, 3, 5]]

    b = Board.new arr
    @s.count_solutions(b).should eq(2)

    arr = [
      [5, 9, 1,   8, 4, 7,   6, 2, 3],   
      [4, 2, 3,   6, 9, 0,   7, 5, 8],
      [8, 6, 7,   0, 3, 5,   1, 4, 9],   

      [1, 8, 4,   3, 5, 0,   2, 7, 6],  
      [2, 3, 9,   0, 7, 6,   5, 8, 0],  
      [6, 7, 5,   0, 2, 8,   3, 9, 0], 

      [9, 5, 8,   7, 6, 3,   4, 1, 2],  
      [3, 1, 2,   5, 8, 4,   9, 6, 7], 
      [7, 0, 6,   9, 1, 2,   8, 3, 5]]

    b = Board.new arr
    @s.count_solutions(b).should eq(2)

    arr = [
      [5, 9, 1,   8, 4, 7,   6, 2, 3],   
      [4, 2, 3,   6, 9, 1,   7, 5, 8],
      [8, 6, 7,   2, 3, 5,   1, 4, 9],   

      [1, 8, 4,   3, 5, 9,   2, 7, 6],  
      [2, 3, 9,   0, 7, 6,   5, 8, 0],  
      [6, 7, 5,   1, 2, 8,   3, 9, 0], 

      [9, 5, 8,   7, 6, 3,   4, 1, 2],  
      [3, 1, 2,   5, 8, 4,   9, 6, 7], 
      [7, 4, 6,   9, 1, 2,   8, 3, 5]]

    b = Board.new arr
    @s.count_solutions(b).should eq(1)
  end
end
