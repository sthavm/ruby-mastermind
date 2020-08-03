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
      @board = GameBoard.new
      @guesses_so_far = 0
      @secret_code = nil
      @code_cracked = false
      add_players
      game_rules
      player_role
      play_game
    end


    def add_players
      puts 'What is your name?'
      @player1 = Player.new(gets.chomp)
      puts "Hi #{player1.name}!"
      @computer_player = ComputerPlayer.new("HAL-9000")
    end

    def game_rules
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
      puts 'Would you like to be the code breaker or the code maker?'
      puts '  (1) Code maker'
      puts '  (2) Code breaker'
      loop do
        case gets.chomp.to_i
        when 1
          @code_maker = @player1
          @code_breaker = @computer_player
          break
        when 2
          @code_maker = @computer_player
          @code_breaker = @player1
          break
        else
          puts 'Not quite. Try again.'
        end
      end
    end

    def play_game
      @secret_code = @code_maker.create_code(@num_pegs)
      until @guesses_so_far == @num_guesses || @code_cracked
        player_guess = @code_breaker.get_guess
        pretty_print(evaluate_guess(player_guess))
        @guesses_so_far += 1
      end
    end

    def evaluate_guess(guess)
      if guess.color_sequence == @secret_code.color_sequence
        @code_cracked = true
        return []
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



COLORS:
  red
  blue
  green
  yellow
  magenta
  cyan
=end