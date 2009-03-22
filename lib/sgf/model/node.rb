module SGF
  module Model
    class Node
      include Constants
      include SGF::SGFHelper
      
      attr_reader :node_type, :color, :move, :black_moves, :white_moves, :labels
      attr_reader :parent, :children
      attr_accessor :comment, :whose_turn
      
      def initialize parent = nil
        @parent     = parent
        @node_type  = NODE_SETUP
        @labels     = []
        @whose_turn = BLACK
        @trunk      = true
        if parent
          @trunk = parent.trunk?
          @parent.children << self
        end
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
      
      def children
        @children ||= []
      end
      
      def child
        @children.first
      end
      
      def root?
        @parent.nil?
      end
      
      def trunk?
        @trunk
      end
      
      def last?
        @children.nil? or @children.empty?
      end
      
      def variation_root= value
        @variation_root = value
        @trunk = false if value
      end
      
      def variation_root?
        @variation_root
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