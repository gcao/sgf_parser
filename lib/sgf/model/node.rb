module SGF
  module Model
    class Node
      include Constants
      include SGF::SGFHelper
      
      attr_reader :type, :color, :move, :black_moves, :white_moves, :labels
      attr_accessor :comment, :whose_turn
      
      def initialize
        @type       = NODE_SETUP
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
        @type  = NODE_MOVE
        @color = BLACK
        @move  = to_position_array(input)
      end
      
      def sgf_play_white input
        @type  = NODE_MOVE
        @color = WHITE
        @move  = to_position_array(input)
      end
      
      def sgf_label input
        @labels << to_label(input)
      end
      
      def to_s
        to_sgf
      end
      
      def to_sgf
        raise 'INCOMPLETE'
        result = ""
        
        if type == NODE_SETUP
          unless black_moves.empty?
          end
          
          unless white_moves.empty?
          end
          
        else
          result << (color == BLACK ? "B" : "W")
          result << "[" << "" << "]"
        end
        
        result << "C[" << comment << "]" unless comment.nil?
        result
      end
    end
  end
end