require 'pry'

module Mastermind
  class GameBoard
    attr_accessor :player1, :player2, :secret_code
    attr_writer :num_pegs, :num_turns
    def initialize
      @num_guesses = 0
    end

    def start
      puts "RUBY MASTERMIND\n"
      game_type
      add_players
      game_rules
      player_roles
      play_game
    end



    private
    def game_type
      puts "Would you like to play against the computer or a friend?\n"
      puts '  (1) Play vs Computer'
      puts '  (2) Play vs Human'
      loop do
        case gets.chomp.to_i
        when 1
          @game_type = 1
          break
        when 2
          @game_type = 2
          break
        else
          puts "That didn't make sense, try again."
        end
      end
    end

    def add_players
      if @game_type == 1
        puts "What is your name?"
        @player1 = Player.new(gets.chomp)
        puts "Hi #{player1.name}!"
        @player2 = ComputerPlayer.new("HAL-9000")
      else
        puts "What is player 1's name?"
        @player1 = Player.new(gets.chomp)
        puts "Hi #{player1.name}!"
        puts "What is player 2's name?"
        @player2 = Player.new(gets.chomp)
        puts "Good luck #{player2.name}!"
      end
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

    def player_roles
      if @game_type == 1
        puts 'Would you like to be the code breaker or the code maker?'
        puts '  (1) Code maker'
        puts '  (2) Code breaker'
        loop do
          case gets.chomp.to_i
          when 1
            @code_maker = player1
            @code_breaker = player2
            break
          when 2
            @code_maker = player2
            @code_breaker = player1
            break
          else
            puts 'Not quite. Try again.'
          end
        end
      else
        puts 'Who wants to be the code maker? The other person will try to break it. Obviously.'
        puts "  (1) #{player1.name}"
        puts "  (2) #{player2.name}"
        loop do
          case gets.chomp.to_i
          when 1
            @code_maker = player1
            @code_breaker = player2
            break
          when 2
            @code_maker = player2
            @code_breaker = player1
            break
          else
            puts 'Failure. You failed. Try again.'
          end
        end
      end
    end

  end

  class Player
    attr_reader :name
    def initialize (name)
      @name = name
    end
  end

  class ComputerPlayer < Player

  end

  class Guess
    def initialize (num_pegs)
      @num_pegs = num_pegs
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
=end