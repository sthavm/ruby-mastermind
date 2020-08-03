require_relative 'constants'

module Mastermind
  class Player
    attr_reader :name
    def initialize(name)
      @name = name
    end

    def create_code(num_pegs)
      puts "Input your secret code as a sequence of #{num_pegs} colors. Each color is represented
       by its first letter in lowercase. You can use:"
      puts 'red'.red + ' (written as ' + 'r'.red + ')'
      puts 'green'.green + ' (written as ' + 'g'.green + ')'
      puts 'blue'.blue + ' (written as ' + 'b'.blue + ')'
      puts 'yellow'.yellow + ' (written as ' + 'y'.yellow + ')'
      puts 'magenta'.magenta + ' (written as ' + 'm'.magenta + ')'
      puts 'cyan'.cyan + ' (written as ' + 'c'.cyan + ')'

      loop do
        sequence = gets.chomp
        sequence_split = sequence.chars
        if (sequence_split.length == num_pegs) && (sequence_split.all? { |char| COLORS_ABBR.include? char })
          return Code.new(sequence)
        else
          puts 'No. Unacceptable. Try again.'
        end
      end
    end

    private

  end

  class ComputerPlayer < Player
    def initialize(name)
      super
    end

    def create_code(num_pegs)

    end

  end
end