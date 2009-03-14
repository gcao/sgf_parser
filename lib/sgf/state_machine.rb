module SGF
  class StateMachine
    attr_reader :start_state, :transitions
    attr_reader :before_state, :input
    attr_accessor :state, :context
    
    def initialize start_state
      @start_state = @state = start_state
      @transitions = {}
    end
    
    def transition before_state, event_pattern, after_state, callback = nil
      if before_state.class == Array
        before_state.each do |s|
          transition(s, event_pattern, after_state, callback)
        end
        return
      end
      
      transition = @transitions[before_state]
      transitions[before_state] = transition = [] unless transition
      transition << [event_pattern, after_state, callback]
    end
    
    def event input
      @before_state = @state
      @input = input
      transition = transitions[@state]
      return false unless transition
      
      found = transition.find do |item|
        input =~ item[0]
      end
      
      if found
        @state = found[1] unless found[1].nil?
        found[2].call self unless found[2].nil?
        true
      else
        false
      end
    end
  end
end