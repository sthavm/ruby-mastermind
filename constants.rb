module Mastermind
  COLORS = %w[red blue green yellow magenta cyan].freeze
  COLORS_ABBR = %w[r g b y m c].freeze
  RED_BLOCK = "".bg_red
  GREEN_BLOCK = "".bg_green
  BLUE_BLOCK = "".bg_blue
  YELLOW_BLOCK = "".bg_yellow
  CYAN_BLOCK = "".bg_cyan
  MAGENTA_BLOCK = "".bg_magenta



  class String
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def blue;           "\e[34m#{self}\e[0m" end
    def yellow;         "\e[33m#{self}\e[0m" end
    def magenta;        "\e[35m#{self}\e[0m" end
    def cyan;           "\e[36m#{self}\e[0m" end

    def bg_red;         "\e[41m#{self}\e[0m" end
    def bg_green;       "\e[42m#{self}\e[0m" end
    def bg_blue;        "\e[44m#{self}\e[0m" end
    def bg_yellow;      "\e[43m#{self}\e[0m" end
    def bg_magenta;     "\e[45m#{self}\e[0m" end
    def bg_cyan;        "\e[46m#{self}\e[0m" end
  end
  
end
