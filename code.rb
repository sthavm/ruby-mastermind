require_relative 'constants'
module Mastermind
  class Code
    attr_reader :color_sequence
    def initialize(color_sequence)
      @color_sequence = color_sequence
    end

    def compare(other_guess)
      if @color_sequence == other_guess.color_sequence

      end
    end

    def random

    end
  end
end