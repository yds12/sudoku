require './generator'

# Generate statistics of solutions per fixed square
task :sol_stat do
  repetitions = 1000
  max_sol = 10_000
  limit = 1_000_000
  csv = "fixed squares,solutions\n"

  [:easy, :medium].each do |difficulty|
    repetitions.times do 
      b = Board.new
      p = Pattern.from_file difficulty
      fixed = p.count(true)
      p.set b
      s = Solver.new
      s.limit = limit

      begin
        solutions = s.count_solutions(b, max_sol)
        puts "#{solutions} solutions with #{fixed} fixed squares"
        csv << "#{fixed},#{solutions}\n"
      rescue
        puts "Exception ocurred"
        csv << "#{fixed},error\n"
      end
    end
  end

  File.open('task/sol_stat.csv', 'w') { |f| f.write csv }
end
