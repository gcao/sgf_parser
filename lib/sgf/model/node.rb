module SGF
  module Model
    class Node
      include Constants
      include SGF::SGFHelper
      
      attr_reader :type, :color, :move, :black_moves, :white_moves, :labels
      attr_accessor :comment
      
      def initialize
        @type = NODE_SETUP
        @labels = []
      end
      
      def black_moves
        @black_moves ||= []
      end
      
      def white_moves
        @white_moves ||= []
      end
      
      def sgf_setup_black position
        black_moves << position_to_array(position)
      end
      
      def sgf_setup_white position
        white_moves << position_to_array(position)
      end
      
      def sgf_play_black position
        @type = NODE_MOVE
        @color = BLACK
        @move = position_to_array(position)
      end
      
      def sgf_play_white position
        @type = NODE_MOVE
        @color = WHITE
        @move = position_to_array(position)
      end
      
      def sgf_label input
        @labels << string_to_label(input)
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