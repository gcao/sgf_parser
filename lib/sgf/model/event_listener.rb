module SGF
  module Model
    class EventListener < SGF::DefaultEventListener
      GAME_PROPERTY_MAPPINGS = {
        'GN' => :name, 'RU' => :rule, 'SZ' => :board_size, 'HA' => :handicap, 'KM' => :komi,
        'PW' => :white_player, 'PB' => :black_player, 'DT' => :played_on
      }
      
      def game
        @game ||= Game.new
      end
      
      def start_game
        @game = Game.new
      end
      
      def start_node
        game.nodes << (@node = Node.new)
      end
      
      def set_property name, value
        return unless name
        name = name.strip.upcase
        
        unless set_game_property(name, value)
          set_node_property(name, value)
        end
      end
      
      private
      
      def set_game_property name, value
        GAME_PROPERTY_MAPPINGS.each do |sgf_prop_name, game_attr_name|
          if name == sgf_prop_name
            game.send(:"#{game_attr_name}=", value.strip)
            return true
          end
        end
      end
      
      def set_node_property name, value
        case name
        when 'C'
          @node.comment = value
        end
      end
    end
  end
end