module SGF
  module Model
    class EventListener < SGF::DefaultEventListener
      
      GAME_PROPERTY_MAPPINGS = {
        'GN' => :name=, 'RU' => :rule=, 'SZ' => :board_size=, 'HA' => :handicap=, 'KM' => :komi=,
        'PW' => :white_player=, 'PB' => :black_player=, 'DT' => :played_on=, 'TM' => :time_rule=,
        'SY' => :application=, "AB" => :sgf_setup_black, "AW" => :sgf_setup_white
      }
      
      NODE_PROPERTY_MAPPINGS = {
        "C" => :comment=, "B" => :sgf_play_black, "W" => :sgf_play_white
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
      
      def start_node
        super
        
        game.nodes << (@node = Node.new)
      end
      
      def set_property name, value
        super
        
        return unless name
        name = name.strip.upcase
        
        unless set_game_property(name, value)
          unless set_node_property(name, value)
            puts "WARNING: SGF property is not recognized(name=#{name}, value=#{value})"
          end
        end
      end
      
      private
      
      def set_game_property name, value
        GAME_PROPERTY_MAPPINGS.each do |sgf_prop_name, game_method|
          if name == sgf_prop_name
            game.send(game_method, value.strip)
            return true
          end
        end
      end

      def set_node_property name, value
        GAME_PROPERTY_MAPPINGS.each do |sgf_prop_name, node_method|
          if name == sgf_prop_name
            game.root_node.send(node_method, value.strip)
            return true
          end
        end
      end
    end
  end
end