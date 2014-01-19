require './board'

class Solver
  Limit = 40_000

  attr_accessor :by_step

  def initialize
    @by_step = false
  end

  def solve board
    return board if board.valid?

    initialize_vars board
    @goal = Proc.new { @exhausted or @board.valid? }

    t = with_time do
      @exhausted = true unless board.possible?
      step
    end

    puts "Sudoku board solved in #{t.round(2)} seconds"

    if @exhausted
      board_impossible
    else
      board
    end
  end

  def count_solutions board, maximum = 100
    return 1 if board.valid?

    initialize_vars board
    @goal = Proc.new { @exhausted or @solutions >= maximum }

    t = with_time do
      @exhausted = true unless board.possible?
      step
    end

    puts "Sudoku board solved in #{t.round(2)} seconds (#{@solutions} solutions)"

    clean_board
    @solutions
  end

  def step steps = 1
    until reached_goal?
      @total_steps += 1
      break if reached_limit?

      decide_square

      return if done_steps? steps
    end
  end

private

  def initialize_vars board
    @board = board
    @index = -1
    @exhausted = false
    @option_tree = generate_options
    @step_count = 0
    @total_steps = 0
    @solutions = 0

    next_empty_square
  end

  def reached_goal?
    @goal.call
  end

  def decide_square
    option = get_option

    if option.nil?
      backtrack
    elsif
      set_square option
      check_solution

      if @board.possible?
        next_square
      else
        exhaust_option @index
      end
    end
  end

  def backtrack
    last_index = @index

    if previous_editable_square
      exhaust_option last_index
      empty_square last_index
    else
      no_more_options
    end
  end

  def next_square
    set_options if next_empty_square
  end

  def set_square value
    return if @option_tree[@index] == :fixed
    @board.set @index, value
    @option_tree[@index][value - 1] = :selected
  end

  def empty_square i
    return if @option_tree[i] == :fixed
    @board.set i, 0
  end

  def exhaust_option index
    return if @option_tree[index] == :fixed
    @option_tree[index][@board.get(index) - 1] = :exhausted
  end

  def board_impossible
    puts "This Sudoku has no solution"
    false
  end

  def generate_options
    Array.new(Squares) do |i| 
      if Numbers.include? @board.get(i)
        :fixed
      else
        Array.new(Size) { :new }
      end
    end
  end

  def get_option
    options = @option_tree[@index]
    return nil unless Array.try_convert(options)

    valid_options = []
    
    options.each_with_index do |o, i|
      valid_options << i + 1 if o == :new
    end

    return nil if valid_options.empty?
    return valid_options.shuffle[0]
  rescue
    p @index
    @board.show_pretty
    p @option_tree
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

  def check_solution
    if @board.valid?
      @solutions += 1
      exhaust_solution
    end
  end

  def reached_limit?
    if @total_steps > Limit
      @exhausted = true
      raise 'Number of tries reached the limit!'
      return true
    end

    false
  end

  def exhaust_solution
    @option_tree.each do |opts|
      opts.map! do |opt|
        if opt == :selected
          :exhausted
        else
          opt
        end
      end if Array.try_convert(opts)
    end
  end

  def fixed? i
    @option_tree[i] == :fixed
  end

  def done_steps? steps
    if @by_step
      @step_count += 1

      if @step_count == steps
        @step_count = 0
        @board.show_pretty
        return true
      end
    end

    return false
  end

  def next_empty_square
    @index += 1
    @index += 1 while fixed?(@index) and @index < Squares - 1
    
    found = (@index < Squares and !fixed?(@index))

    @index = Squares - 1 if @index > Squares - 1
    found
  end

  def previous_editable_square
    @index -= 1
    @index -= 1 while fixed?(@index)

    return (@index >= 0 and !fixed?(@index))
  end

  def no_more_options
    @exhausted = true
    puts "exhausted in #{@total_steps} tries"
  end

  def clean_board
    Squares.times { |i| @board.set(i, 0) unless fixed? i }
  end
end
