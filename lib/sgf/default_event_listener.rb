module SGF
  class DefaultEventListener
    def initialize debug_mode = false
      @debug_mode = debug_mode
    end
    
    def start_game
      debug 'start_game'
    end
    
    def start_node
      debug 'start_node'
    end
    
    def set_property name, value
      debug "set_property('#{name}', '#{value}')"
    end
    
    def start_variation
      debug "start_variation"
    end
    
    def end_variation
      debug "end_variation"
    end
    
    def end_game
      debug "end_game"
    end
   
    protected
    
    def debug message
      puts message if @debug_mode
    end
    
  end
end