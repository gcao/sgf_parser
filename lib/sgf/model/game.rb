module SGF
  module Model
    class Game
      attr_accessor :name, :rule, :board_size, :handicap, :komi, :black_player, :white_player,
                    :played_on
      
      DEFAULT_BOARD_SIZE = 19
      DEFAULT_KOMI = 7.5
      
      def board_size; @board_size ||= DEFAULT_BOARD_SIZE; end
      def handicap; @handicap ||= 0; end
      def komi; @komi ||= DEFAULT_KOMI; end
      
      def board_size=(value); @board_size = value.to_i; end
      def handicap=(value); @handicap = value.to_i; end
      def komi=(value); @komi = value.to_f; end
      
    end
  end
end