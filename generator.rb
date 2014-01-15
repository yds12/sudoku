require './board'

class Generator
  Limit = 10_000

  def with_time
    t1 = Time.now
    yield
    Time.now - t1
  end

  def generate
    generate_by_step false
  end

  def generate_by_step by_step = true
    @board = Board.new

    @index = 0
    @option_tree = generate_options

    @by_step = by_step
    @step_count = 0
    @total_steps = 0

    t = with_time do
      step
    end

    puts "Sudoku board generated in #{t.round(2)} seconds"

    @board
  end

  def step steps = 1
    until @board.valid?
      @total_steps += 1
      break if @total_steps > Limit

      options = @option_tree[@index]
      opt = get_option(options)

      if opt.nil? # backtrack
        @board.set @index, 0
        @index -= 1
        options[@board.get(@index) - 1] = :exhausted
      elsif
        @board.set @index, opt

        if @board.possible?
          options[opt - 1] = :selected
          @index += 1
          set_options if @index < Size * Size
        else
          options[opt - 1] = :exhausted
        end
      end

      if @by_step 
        @step_count += 1

        if @step_count == steps
          @step_count = 0
          @board.show_pretty
          return
        end
      end
    end
  end

private

  def generate_options
    Array.new(Size * Size) { Array.new(Size) { :new } }
  end

  def get_option options
    valid_options = []
    
    options.each_with_index do |o, i|
      valid_options << i + 1 if o == :new
    end

    return nil if valid_options.empty?
    return valid_options.shuffle[0]
  end

  def set_options 
    options = @option_tree[@index]

    options.each_index do |i|
      options[i] = :new
      options[i] = :exhausted if @board.get_peers(@index).include? i + 1
    end
  end
  
  def print_option_state
    @option_tree.each { |o| print o.count(:exhausted) }
  end
end
