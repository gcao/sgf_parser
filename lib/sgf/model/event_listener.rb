module SGF
  module Model
    class EventListener < SGF::DefaultEventListener
      
      GAME_PROPERTY_MAPPINGS = {
        'GN' => :name=, 'RU' => :rule=, 'SZ' => :board_size=, 'HA' => :handicap=, 'KM' => :komi=,
        'PW' => :white_player=, 'PB' => :black_player=, 'DT' => :played_on=, 'TM' => :time_rule=,
        'SY' => :application=
      }
      
      NODE_PROPERTY_MAPPINGS = {
        "B" => :sgf_play_black, "W" => :sgf_play_white, "C" => :comment=,
        "AB" => :sgf_setup_black, "AW" => :sgf_setup_white
      }
      
      def initialize debug_mode = false
        super(debug_mode)
      end
      
      def game
        @game ||= Game.new
      end
      
      def node
        @node ||= game.root_node
      end
      
      def start_game
        super
        
        @game = Game.new
      end
      
      def start_node
        super
        
        @node = Node.new
        game.nodes << @node
      end
      
      def property_name= name
        super name
        
        @property_name = name
      end
      
      def property_value= value
        super value
        
        set_property @property_name, value
      end
      
      def set_property name, value
        return unless name
        name = name.strip.upcase
        value.strip! unless value.nil?

        unless set_game_property(name, value)
          unless set_node_property(name, value)
            puts "WARNING: SGF property is not recognized(name=#{name}, value=#{value})"
          end
        end
      end
      
      private
      
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