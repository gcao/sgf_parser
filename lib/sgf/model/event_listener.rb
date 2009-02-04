module SGF
  module Model
    class EventListener
      def game
        @game ||= Game.new
      end
      
      def start_game
        @game = Game.new
      end
      
      def set_property name, value
        if name and name.strip.upcase == 'GN'
          game.name = value
        end
      end
    end
  end
end