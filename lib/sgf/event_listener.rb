module SGF
  class EventListener < DefaultEventListener
    attr :game
    
    def start_game
      super
      
      @game = Game.new
      @variations = [@game]
    end
    
    def end_game
      super
    end
    
    def start_node
      super
      
      @node = Node.new
    end

    def end_node
      super

      @variations.last.nodes << @node unless @node.empty?
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
      
      @variations << Variation.new(@node)
    end

    def end_variation
      super
      
      variation = @variations.pop
      @node = variation.parent
    end
  end
end
