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
      puts "Right color in the right place: #{RIGHT_PLACE_PEG}"
      puts "Right color in the wrong place: #{CONTAINS_PEG}"
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
      puts "Input your secret code as a sequence of #{num_pegs} colors."
      puts 'Each color is represented by its first letter in lowercase. You can use:'
      puts 'red'.red + ' (written as ' + 'r'.red + ')'
      puts 'green'.green + ' (written as ' + 'g'.green + ')'
      puts 'blue'.blue + ' (written as ' + 'b'.blue + ')'
      puts 'yellow'.yellow + ' (written as ' + 'y'.yellow + ')'
      puts 'magenta'.magenta + ' (written as ' + 'm'.magenta + ')'
      puts 'cyan'.cyan + ' (written as ' + 'c'.cyan + ')'
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

    def receive_evaluation(feedback, guesses_so_far, num_guesses)
      pretty_feedback = make_pretty_feedback(feedback)
      puts "\n"
      puts "Feedback: #{pretty_feedback.join(' ')}"
      puts "Tries: #{guesses_so_far}/#{num_guesses}"
      puts "\n"
    end

    def make_pretty_feedback(dict)
      pretty_array = []
      dict.each do | char, number |
        if char == 'r'
          pretty_array.fill(RIGHT_PLACE_PEG, pretty_array.size, number)
        elsif char == 'c'
          pretty_array.fill(CONTAINS_PEG, pretty_array.size, number)
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
    attr_writer :human
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

    def create_guess(num_pegs)
      guess = Code.new(@possible_solutions.sample)
      @last_guess = guess
      puts "\n"
      puts "Thinking..."
      sleep 2
      puts "\n"
      puts "#{@name} guessed: #{blockify(guess.color_sequence)}"
      puts "\n"
      guess
    end

    def receive_evaluation(feedback, guesses_so_far, num_guesses)
      pretty_feedback = make_pretty_feedback(feedback)
      puts "\n"
      puts "Feedback: #{pretty_feedback.join(' ')}"
      puts "Tries: #{guesses_so_far}/#{num_guesses}"
      puts "\n"
      @possible_solutions.delete_if do | code |
        would_give_different_feedback(code, feedback)
      end
    end

    def would_give_different_feedback(code, feedback)
      evaluate(code) != feedback
    end

    def evaluate(code)
      feedback = {'r' => 0, 'c' => 0}
      guess_sequence = @last_guess.color_sequence.clone
      secretcode_sequence = code.clone
      (@last_guess.color_sequence.length - 1).downto(0) do | i |
        if @last_guess.color_sequence[i] == code[i]
          feedback['r'] += 1
          guess_sequence.delete_at(i)
          secretcode_sequence.delete_at(i)
        end
      end
      guess_sequence.each do | char |
        if secretcode_sequence.include?(char)
          feedback['c'] += 1
          secretcode_sequence.delete_at(secretcode_sequence.find_index(char))
        end
      end
      feedback
    end

    def display_guessing_rules(num_pegs)
      @possible_solutions = generate_all_possible_codes(num_pegs)
    end

    def display_win_message(secret_code)
      puts "#{@name} has cracked the code!"
    end

    def display_loss_message(secret_code)
      puts "#{@name} has failed to crack the code in enough tries! Guess the machines won't be taking over that soon..."
    end

    def generate_all_possible_codes(num_pegs)
      COLORS_ABBR.repeated_permutation(num_pegs).to_a
    end

  end
end


# generate all subsets
# [r,g,b,y,c,m], num_pegs = 4
# r,r,r,r ; r,r,r,g; r,r,r,
# 