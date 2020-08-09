require_relative 'constants'

module Mastermind
  class Player
    attr_reader :name
    def initialize(name)
      @name = name
    end

    def display_guessing_rules(num_pegs)
      puts "\n"
      puts "Input your guess as a sequence of #{num_pegs} colors."
      puts 'Each color is represented by its first letter in lowercase. You can use:'
      puts 'red'.red + ' (written as ' + 'r'.red + ')'
      puts 'green'.green + ' (written as ' + 'g'.green + ')'
      puts 'blue'.blue + ' (written as ' + 'b'.blue + ')'
      puts 'yellow'.yellow + ' (written as ' + 'y'.yellow + ')'
      puts 'magenta'.magenta + ' (written as ' + 'm'.magenta + ')'
      puts 'cyan'.cyan + ' (written as ' + 'c'.cyan + ')'
      puts "\n"
    end

    def display_win_message(secret_code)
      puts "\n"
      puts "Congratulations #{@name}, you've guessed the code and won!"
      puts "The secret code was #{pretty_code(secret_code)}"
    end

    def display_loss_message(secret_code)
      puts "\n"
      puts "You've run out of guesses :("
      puts "The code was #{pretty_code(secret_code)}"
      puts "Better luck next time #{@name}"
    end

    def create_guess(num_pegs)
      print 'Type your guess: '
      loop do
        sequence = gets.chomp
        sequence_split = sequence.chars
        if (sequence_split.length == num_pegs) && (sequence_split.all? { |char| COLORS_ABBR.include? char })
          puts "\n"
          puts blockify(sequence_split)
          return Code.new(sequence_split)
        else
          puts 'No. Unacceptable. Try again.'
        end
      end
    end

    def create_code(num_pegs)
      print 'Type your secret code: '
      loop do
        sequence = gets.chomp
        sequence_split = sequence.chars
        if (sequence_split.length == num_pegs) && (sequence_split.all? { |char| COLORS_ABBR.include? char })
          return Code.new(sequence_split)
        else
          puts 'WRONG. Try again.'
        end
      end
    end

    def receive_evaluation(feedback_array, guesses_so_far, num_guesses)
      pretty_feedback = make_pretty_feedback(feedback_array)
      puts "\n"
      puts "Feedback: #{pretty_feedback.join(' ')}"
      puts "Tries: #{guesses_so_far}/#{num_guesses}"
      puts "\n"
    end

    def make_pretty_feedback(array)
      pretty_array = []
      array.each do | char |
        if char == 'r'
          pretty_array.push(RIGHT_PLACE_PEG)
        elsif char == 'c'
          pretty_array.push(CONTAINS_PEG)
        end
      end
      pretty_array
    end

    def pretty_code(array)
      pretty_array = []
      array.each do | char |
        pretty_array.push(COLORED_CHARS[char])
      end
      pretty_array.join(' ')
    end

    def blockify(color_array)
      block_array = []
      color_array.each do | char |
        block_array.push(CHAR_TO_BLOCK[char])
      end
      block_array.join(' ')
    end

  end

  class ComputerPlayer < Player
    def initialize(name)
      super
    end

    def create_code(num_pegs)
      code_sequence = []
      until code_sequence.length == num_pegs
        code_sequence.push(COLORS_ABBR.sample)
      end
      Code.new(code_sequence)
    end

    def display_guessing_rules; end

    def display_win_message(secret_code); end

    def display_loss_message(secret_code); end

  end
end
