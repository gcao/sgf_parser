module SGF
  module SGFStateMachine
    
    STATE_BEGIN        = :begin
    STATE_GAME_BEGIN   = :game_begin       
    STATE_NODE         = :node             
    STATE_VAR_BEGIN    = :var_begin        
    STATE_GAME_VAR_END = :game_var_end     
    STATE_PROP_NAME    = :prop_name        
    STATE_VALUE_BEGIN  = :value_begin      
    STATE_VALUE        = :value            
    STATE_VALUE_END    = :value_end        
    
    def state_machine
      @sgf_stm = StateMachine.new(STATE_BEGIN)
      
      @sgf_stm.transition STATE_BEGIN,        /\(/,        STATE_GAME_BEGIN
      @sgf_stm.transition [STATE_GAME_BEGIN, STATE_VAR_BEGIN, STATE_GAME_VAR_END, STATE_VALUE_END],   
                                              /;/,         STATE_NODE
      @sgf_stm.transition [STATE_NODE, STATE_GAME_VAR_END, STATE_VALUE_END],
                                              /\(/,        STATE_VAR_BEGIN
      @sgf_stm.transition [STATE_NODE, STATE_VALUE_END],
                                              /[a-zA-Z]/,  STATE_PROP_NAME
      @sgf_stm.transition STATE_PROP_NAME,    /\[/,        STATE_VALUE_BEGIN
      @sgf_stm.transition STATE_VALUE_BEGIN,  /[^\]]/,     STATE_VALUE
      @sgf_stm.transition STATE_VALUE,        /\]/,        STATE_VALUE_END
      @sgf_stm.transition [STATE_NODE, STATE_VALUE_END],
                                              /\)/,        STATE_GAME_VAR_END
      
      @sgf_stm
    end
  end
end