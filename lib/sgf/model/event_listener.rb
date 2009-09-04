module SGF
  module Model
    class EventListener < SGF::DefaultEventListener
      include SGF::SGFHelper
      
      attr_reader :node
      
      GAME_PROPERTY_MAPPINGS = {
        'GM' => :game_type=, 'GN' => :name=, 'RU' => :rule=, 'SZ' => :board_size=, 'HA' => :handicap=, 'KM' => :komi=,
        'PW' => :white_player=, 'PB' => :black_player=, 'DT' => :played_on=, 'TM' => :time_rule=,
        'SY' => :application=
      }
      
      NODE_PROPERTY_MAPPINGS = {
        "B" => :sgf_play_black, "W" => :sgf_play_white, "C" => :comment=,
        "AB" => :sgf_setup_black, "AW" => :sgf_setup_white, "LB" => :sgf_label,
        "PL" => :whose_turn=
      }
      
      def initialize debug_mode = false
        super(debug_mode)
      end
      
      def game
        @game ||= Game.new
      end
      
      def start_game
        super
        
        @game = Game.new
      end
      
      def start_variation
        super
        
        @node = Node.new(@node)
        @node.variation_root = true
      end
      
      def end_variation
        super
        
        @node = find_variation_root(@node).parent
      end
      
      def start_node
        super
        
        @node = @node.nil? ? game.root_node : Node.new(@node)
      end
      
      def property_name= name
        super name
        
        @property_name = name
      end
      
      def property_value= value
        super value
        
        set_property @property_name, value
      end
      
      private
      
      def find_variation_root node
        while not node.variation_root?
          return node if node.parent.nil?
          
          node = node.parent
        end
        node
      end
      
      def set_property name, value
        return unless name
        name = name.strip.upcase
        value.strip! unless value.nil?

        return if set_game_property(name, value)
        return if set_node_property(name, value)
        
        puts "WARNING: SGF property is not recognized(name=#{name}, value=#{value})"
      end
      
      def set_game_property name, value
        game_method = GAME_PROPERTY_MAPPINGS[name]
        
        if game_method
          game.send(game_method, value)
          true
        end
      end

      def set_node_property name, value
        node_method = NODE_PROPERTY_MAPPINGS[name]
        
        if node_method
          node.send(node_method, value)
          true
        end
      end
    end
  end
end