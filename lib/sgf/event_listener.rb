module SGF
  class EventListener < DefaultEventListener    
    def start_game
      super
    end
    
    def start_node
      super
    end
    
    def property_name= name
      super
    end
    
    def property_value= value
      super
    end
    
    def end_node
      super
    end

    def start_variation
      super
    end
    
    def end_variation
      super
    end
    
    def end_game
      super
    end
  end
end
