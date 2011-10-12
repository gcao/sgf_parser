module SGF
  class DefaultEventListener
    include Debugger

    def initialize debug_mode = false
      @debug_mode = debug_mode
    end

    def start_game
      debug do
        @indent = []
        "#{@indent.join}start_game"
      end
    end

    def start_node
      debug do
        "#{@indent.join}  start_node"
      end
    end

    def property_name= name
      debug do
        "#{@indent.join}    property_name = '#{name}'"
      end
    end

    def property_value= value
      debug do
        "#{@indent.join}      property_value = '#{value}'"
      end
    end

    def end_node
      debug do
        "#{@indent.join}  end_node"
      end
    end

    def start_variation
      debug do
        @indent << "  "
        "#{@indent.join}start_variation"
      end
    end

    def end_variation
      debug do
        s = "#{@indent.join}end_variation"
        @indent.pop
        s
      end
    end

    def end_game
      debug do
        "#{@indent.join}end_game"
      end
    end
  end
end
