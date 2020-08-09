require_relative 'constants'
require_relative 'code'
require_relative 'player'


module Mastermind
  class Game
    def initialize; end

    def start
      puts <<-HEREDOC
                          =======================
                                MASTERMIND
                          =======================
      HEREDOC
      @guesses_so_far = 0
      @secret_code = nil
      @code_cracked = false
      add_players
      game_rules
      player_role
      play_game
    end

    def add_players
      puts "\n"
      puts 'What is your name?'
      @player = Player.new(gets.chomp)
      puts "Hi #{@player.name}!"
      @computer_player = ComputerPlayer.new('HAL-9000')
    end

    def game_rules
      puts "\n"
      puts "You can change the game's rules if you'd like. Or you can use the default settings (4 pegs, 12 guesses).\n"
      puts '  (1) Use default rules.'
      puts '  (2) Customize.'
      loop do
        case gets.chomp.to_i
        when 1
          @num_pegs = 4
          @num_guesses = 12
          break
        when 2
          customize_rules
          break
        else
          puts 'That was awful. Try again.'
        end
      end
    end

    def customize_rules
      customize_num_pegs
      customize_guesses
    end

    def customize_num_pegs
      puts "\n"
      puts 'How many pegs are we dealing with?'
      puts '  (1) 3 pegs'
      puts '  (2) 4 pegs'
      puts '  (3) 5 pegs'
      puts '  (4) 6 pegs'
      loop do
        answer = gets.chomp.to_i
        if answer >= 1 && answer <= 4
          @num_pegs = answer + 2
          break
        else
          puts "You're really bad at this. Try again."
        end
      end
    end

    def customize_guesses
      puts "\n"
      puts 'How many guesses are allowed?'
      puts '  (1) 6 guesses'
      puts '  (2) 8 guesses'
      puts '  (3) 10 guesses'
      puts '  (4) 12 guesses'
      puts '  (5) 16 guesses'
      loop do
        case gets.chomp.to_i
        when 1
          @num_guesses = 6
          break
        when 2
          @num_guesses = 8
          break
        when 3
          @num_guesses = 10
          break
        when 4
          @num_guesses = 12
          break
        when 5
          @num_guesses = 16
          break
        else
          puts "That wasn't it chief. Try again."
        end
      end
    end

    def player_role
      puts "\n"
      puts 'Would you like to be the code breaker or the code maker?'
      puts '  (1) Code maker'
      puts '  (2) Code breaker'
      loop do
        case gets.chomp.to_i
        when 1
          @code_maker = @player
          @code_breaker = @computer_player
          break
        when 2
          @code_maker = @computer_player
          @code_breaker = @player
          break
        else
          puts 'Not quite. Try again.'
        end
      end
    end

    def play_game
      @secret_code = @code_maker.create_code(@num_pegs)
      puts @secret_code.color_sequence
      @code_breaker.display_guessing_rules(@num_pegs)
      until @guesses_so_far == @num_guesses || @code_cracked
        player_guess = @code_breaker.create_guess(@num_pegs)
        @code_breaker.receive_evaluation(evaluate_guess(player_guess), (@guesses_so_far + 1), @num_guesses)
        check_win(player_guess)
        @guesses_so_far += 1
      end
      unless @code_cracked
        @code_breaker.display_loss_message(@secret_code.color_sequence)
      end
    end

    def evaluate_guess(guess)
      feedback_array = []
      guess_sequence = guess.color_sequence.clone
      secretcode_sequence = @secret_code.color_sequence.clone
      (guess.color_sequence.length - 1).downto(0) do | i |
        if guess.color_sequence[i] == @secret_code.color_sequence[i]
          feedback_array.push('r')
          guess_sequence.delete_at(i)
          secretcode_sequence.delete_at(i)
        end
      end
      guess_sequence.each do | char |
        if secretcode_sequence.include?(char)
          feedback_array.push('c')
          secretcode_sequence.delete_at(secretcode_sequence.find_index(char))
        end
      end
      feedback_array
    end

    def check_win(guess)
      if guess.color_sequence == @secret_code.color_sequence
        @code_cracked = true
        @code_breaker.display_win_message(@secret_code.color_sequence)
      end
    end
  end
end

=begin
game.new
game.start
  get number of pegs - 4/5/6
  get number of turns
  choose play vs computer / 2 player
    choose codebreaker/ codemaker
game.player1 = Player.new()
game.player2 = Player.new()
game.set_codebreaker = player
game.set_codemaker = player
game.play
  make guess
  return feedback on guess
  check win
  increment guess counter



  [r,g,y,b]
  [g,r,y,m]
COLORS:
  red
  blue
  green
  yellow
  magenta
  cyan
=end