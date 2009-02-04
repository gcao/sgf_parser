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
      
      def set_property name, value
        return unless name
        name = name.strip.upcase
        
        unless set_game_property(name, value)
          # set property on current node
        end
      end
      
      private
      
      def set_game_property name, value
        GAME_PROPERTY_MAPPINGS.each do |sgf_prop_name, game_attr_name|
          if name == sgf_prop_name
            game.send(:"#{game_attr_name}=", value)
            return true
          end
        end
      end
    end
  end
end