require_relative 'constants'
module Mastermind
  class Code
    attr_reader :color_sequence
    def initialize(color_sequence = nil)
      @color_sequence = color_sequence
    end
  end
end

