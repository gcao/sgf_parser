module SGF
  module SGFStateMachine
    
    STATE_BEGIN           = :begin
    STATE_GAME_BEGIN      = :game_begin       
    STATE_NODE            = :node             
    STATE_VAR_BEGIN       = :var_begin        
    STATE_GAME_VAR_END    = :game_var_end     
    STATE_PROP_NAME_BEGIN = :prop_name_begin
    STATE_PROP_NAME       = :prop_name        
    STATE_VALUE_BEGIN     = :value_begin      
    STATE_VALUE           = :value            
    STATE_VALUE_END       = :value_end
    
    def create_state_machine context = nil
      stm = StateMachine.new(STATE_BEGIN)
      stm.context = context
      
      stm.transition STATE_BEGIN,        
                     /\(/,        
                     STATE_GAME_BEGIN,
                     lambda{ |stm| stm.context.start_game unless stm.context.nil? }
      
      stm.transition [STATE_GAME_BEGIN, STATE_VAR_BEGIN, STATE_GAME_VAR_END, STATE_VALUE_END],   
                     /;/,
                     STATE_NODE,
                     lambda{ |stm| stm.context.start_node unless stm.context.nil? }
      
      stm.transition [STATE_NODE, STATE_GAME_VAR_END, STATE_VALUE_END],
                     /\(/,        
                     STATE_VAR_BEGIN,
                     lambda{ |stm| stm.context.start_variation unless stm.context.nil? }
      
      stm.transition [STATE_NODE, STATE_VALUE_END],
                     /[a-zA-Z]/,  
                     STATE_PROP_NAME_BEGIN,
                     lambda{ |stm| stm.context.prop_name = stm.context.input unless stm.context.nil? }
      
      stm.transition STATE_PROP_NAME_BEGIN,
                     /[a-zA-Z]/,  
                     STATE_PROP_NAME,
                     lambda{ |stm| stm.context.prop_name += stm.context.input unless stm.context.nil? }
      
      stm.transition [STATE_PROP_NAME_BEGIN, STATE_PROP_NAME, STATE_VALUE_END],    
                     /\[/,        
                     STATE_VALUE_BEGIN
                     
      stm.transition STATE_VALUE_BEGIN,  
                     /[^\]]/,
                     STATE_VALUE,
                     lambda{ |stm| stm.context.prop_value = stm.context.input unless stm.context.nil? }
                       
      stm.transition STATE_VALUE,
                     /[^\]]/,
                     nil,
                     lambda{ |stm| stm.context.prop_value += stm.context.input unless stm.context.nil? }
                       
      stm.transition STATE_VALUE,        
                     /\]/,        
                     STATE_VALUE_END,
                     lambda{ |stm| stm.context.set_property(stm.context.prop_name, stm.context.prop_value) unless stm.context.nil? }
    
      stm.transition [STATE_NODE, STATE_VALUE_END],
                     /\)/,        
                     STATE_GAME_VAR_END,
                     lambda{ |stm| stm.context.end_variation unless stm.context.nil? }

      stm
    end
                       
  end
end
