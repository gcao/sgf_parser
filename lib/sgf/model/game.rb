module SGF
  module Model
    class Game
      include Constants
      include SGF::SGFHelper
      
      attr_accessor :game_type, :name, :rule, :board_size, :handicap, :komi, :black_player, :white_player,
                    :played_on, :time_rule, :program, :result

      def initialize
        @game_type   = WEIQI
        @board_size  = DEFAULT_BOARD_SIZE
        @handicap    = 0
        @komi        = DEFAULT_KOMI
      end
      
      def game_type=(value);  @game_type  = value.to_i; end
      def board_size=(value); @board_size = value.to_i; end
      def handicap=(value);   @handicap   = value.to_i; end
      def komi=(value);       @komi       = value.to_f; end

      def root_node
        @root_node ||= Node.new(nil)
      end
      
    end
  end
end