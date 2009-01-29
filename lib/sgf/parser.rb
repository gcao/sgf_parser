module SGF
  class Parser
    attr_reader :event_listener
    
    STATE_BEGIN        = 0
    STATE_GAME_BEGIN   = 10   # (
    STATE_NODE         = 20   # ;
    STATE_VAR_BEGIN    = 30   # (
    STATE_VAR_END      = 40   # )
    STATE_PROP_NAME    = 50   # A-Z
    STATE_VALUE_BEGIN  = 60   # [
    STATE_VALUE_END    = 70   # ]
    STATE_GAME_END     = 100  # )
    
    def initialize event_listener
      @event_listener = event_listener
    end
    
    def parse input
      raise ArgumentError.new if input.nil? or input.strip.empty?
      
      input.strip!
      
      state = STATE_BEGIN
      0.upto(input.size - 1) do |i|
        char = input[i]
        
        case state
        when STATE_BEGIN
          if char == ?(
            state = STATE_GAME_BEGIN
            @event_listener.start_game
          else
            raise ArgumentError.new(input)
          end
        when STATE_GAME_BEGIN
          if char == ?;
            state = STATE_NODE
          else
          end
        end
      end
    end
  end
end