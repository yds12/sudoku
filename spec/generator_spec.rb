require './generator'

describe Generator do
  before { @gen = Generator.new }
  
  subject { @gen }
  it { should respond_to(:generate) }

  it 'should generate valid boards' do
    b1 = @gen.generate
    b2 = @gen.generate
    b3 = @gen.generate

    b1.should be_valid
    b2.should be_valid
    b3.should be_valid
  end

  it 'should generate different boards' do
    boards = []
    boards << @gen.generate << @gen.generate << @gen.generate

    boards.each do |b|
      boards.each do |b2|
        next if b.object_id == b2.object_id
        different = false

        b.all_values.each_with_index do |el, i|
          if el != b2.all_values[i]
            different = true
            break
          end
        end

        different.should be_true
      end
    end
  end
end
