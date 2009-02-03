module SGF
  class Parser
    attr_reader :event_listener
    
    STATE_BEGIN        = :begin
    STATE_GAME_BEGIN   = :game_begin       # (
    STATE_NODE         = :node             # ;
    STATE_VAR_BEGIN    = :var_begin        # (
    STATE_VAR_END      = :var_end          # )
    STATE_PROP_NAME    = :prop_name        # A-Z
    STATE_VALUE_BEGIN  = :value_begin      # [
    STATE_VALUE        = :value            # ^[
    STATE_VALUE_END    = :value_end        # ]
    STATE_GAME_END     = :game_end         # )
    
    SGF_STATE_MACHINE = StateMachine.new STATE_BEGIN
    SGF_STATE_MACHINE.transition STATE_BEGIN, /\(/, STATE_GAME_BEGIN
    SGF_STATE_MACHINE.transition STATE_GAME_BEGIN, /;/, STATE_NODE
    SGF_STATE_MACHINE.transition STATE_NODE, /\(/, STATE_VAR_BEGIN
    SGF_STATE_MACHINE.transition STATE_VAR_BEGIN, /[a-zA-Z]/, STATE_PROP_NAME
    SGF_STATE_MACHINE.transition STATE_PROP_NAME, /\[/, STATE_VALUE_BEGIN
    SGF_STATE_MACHINE.transition STATE_VALUE_BEGIN, /[^\[]/, STATE_VALUE
    SGF_STATE_MACHINE.transition STATE_VALUE, /\]/, STATE_VALUE_END
    SGF_STATE_MACHINE.transition STATE_VALUE_END, /\)/, STATE_VAR_END
    
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