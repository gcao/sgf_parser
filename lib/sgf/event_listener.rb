module SGF
  class EventListener < DefaultEventListener

    attr :game
    attr :variation

    def start_game
      super

      @game = @variation = Game.new
    end

    def end_game
      super

      @game.cleanup
    end

    def start_node
      super

      @node = Node.new @variation
    end

    def end_node
      super

      return if @node.empty?

      @variation.children << @node
    end

    def property_name= name
      super

      @property_name = name
    end

    def property_value= value
      super

      @node.add_property @property_name, value
    end

    def start_variation
      super

      @variation = Variation.new(@node)
    end

    def end_variation
      super

      @node = @variation.parent
      @variation = @node.nil? ? @game : @node.parent
    end

  end
end
