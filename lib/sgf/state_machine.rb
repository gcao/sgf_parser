module SGF
  class StateMachine
    attr_reader :start_state, :state, :transitions
    
    def initialize start_state
      @start_state = @state = start_state
      @transitions = {}
    end
    
    def transition start_state, event_pattern, end_state
      transition = @transitions[start_state]
      transitions[start_state] = transition = [] unless transition
      transition << [event_pattern, end_state]
    end
    
    def event input
      transition = transitions[@state]
      found = transition.find do |item|
        input =~ item[0]
      end
      if found
        @state = found[1]
        true
      else
        false
      end
    end
  end
end