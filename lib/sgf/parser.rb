module SGF
  class Parser
    include SGFStateMachine
    
    attr_reader :event_listener
    
    def initialize event_listener
      @stm = state_machine
      @event_listener = event_listener
    end
    
    def parse input
      raise ArgumentError.new if input.nil? or input.strip.empty?
      
      input.strip!
        
      prop_name = ""
      prop_value = ""
      
      0.upto(input.size - 1) do |i|
        char = input[i].chr
        @stm.event(char)

        case @stm.state
        when STATE_GAME_BEGIN
          @event_listener.start_game
        when STATE_NODE
          @event_listener.start_node
          prop_name = ""
        when STATE_PROP_NAME_BEGIN
          prop_name = char
        when STATE_PROP_NAME
          prop_name << char
        when STATE_VALUE
          prop_value << char
        when STATE_VALUE_END
          prop_name.strip!
          @event_listener.set_property(prop_name, prop_value) if prop_name.size > 0 and prop_value.size > 0
          prop_value = ""
        when STATE_VAR_BEGIN
          @event_listener.start_variation
          prop_name = ""
        when STATE_GAME_VAR_END
          if i == input.size - 1
            @event_listener.end_game
          else
            @event_listener.end_variation
          end
        end
      end
    end
  end
end