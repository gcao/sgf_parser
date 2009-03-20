module SGF
  module Model
    class Node
      include Constants
      include SGF::SGFHelper
      
      attr_reader :node_type, :color, :move, :black_moves, :white_moves, :labels
      attr_accessor :comment, :whose_turn
      
      def initialize
        @node_type  = NODE_SETUP
        @labels     = []
        @whose_turn = BLACK
      end
      
      def whose_turn= input
        @whose_turn = input.to_i
      end
      
      def black_moves
        @black_moves ||= []
      end
      
      def white_moves
        @white_moves ||= []
      end
      
      def sgf_setup_black input
        black_moves << to_position_array(input)
      end
      
      def sgf_setup_white input
        white_moves << to_position_array(input)
      end
      
      def sgf_play_black input
        @node_type = NODE_MOVE
        @color     = BLACK
        @move      = to_position_array(input)
      end
      
      def sgf_play_white input
        @node_type = NODE_MOVE
        @color     = WHITE
        @move      = to_position_array(input)
      end
      
      def sgf_label input
        @labels << to_label(input)
      end
    end
  end
end