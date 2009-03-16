module SGF
  class Parser
    include SGFStateMachine
    
    attr_reader :event_listener
    
    def initialize event_listener
      @stm = create_state_machine
      @event_listener = event_listener
    end
    
    def parse input
      raise ArgumentError.new if input.nil? or input.strip.empty?
      
      @stm.context = @event_listener
      input.strip!
        
      0.upto(input.size - 1) do |i|
        @stm.event(input[i,1])
      end
    end
  end
end