module SGF
  module Model
    class Game
      DEFAULT_BOARD_SIZE = 19
      DEFAULT_KOMI = 7.5
      
      attr_reader :nodes
      attr_accessor :name, :rule, :board_size, :handicap, :komi, :black_player, :white_player,
                    :played_on, :time_rule, :application

      def initialize
        @board_size = DEFAULT_BOARD_SIZE
        @handicap = 0
        @komi = DEFAULT_KOMI
        @nodes = []
      end
      
      def board_size=(value); @board_size = value.to_i; end
      def handicap=(value); @handicap = value.to_i; end
      def komi=(value); @komi = value.to_f; end

      def root_node
        @nodes[0]
      end
      
      def sgf_setup_black position
        puts "NOT IMPLEMENTED: sgf_setup_black"
      end
      
      def sgf_setup_white position
        puts "NOT IMPLEMENTED: sgf_setup_white"
      end
      
    end
  end
end