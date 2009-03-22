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
      
      stm.context            = context
      start_game             = lambda{ |stm| return if stm.context.nil?; stm.context.start_game }
      start_node             = lambda{ |stm| return if stm.context.nil?; stm.context.start_node }
      start_variation        = lambda{ |stm| return if stm.context.nil?; stm.context.start_variation }
      store_input_in_buffer  = lambda{ |stm| return if stm.context.nil?; stm.buffer = stm.input }
      append_input_to_buffer = lambda{ |stm| return if stm.context.nil?; stm.buffer += stm.input }
      set_property_name      = lambda{ |stm| return if stm.context.nil?; stm.context.property_name = stm.buffer }
      set_property_value     = lambda{ |stm| return if stm.context.nil?; stm.context.property_value = stm.buffer }
      end_variation          = lambda{ |stm| return if stm.context.nil?; stm.context.end_variation }

      stm.transition STATE_BEGIN,        
                     /\(/,        
                     STATE_GAME_BEGIN,
                     start_game
      
      stm.transition [STATE_GAME_BEGIN, STATE_GAME_VAR_END, STATE_VALUE_END],   
                     /;/,
                     STATE_NODE,
                     start_node
      
      stm.transition STATE_VAR_BEGIN,
                     /;/,
                     STATE_NODE
      
      stm.transition [STATE_NODE, STATE_GAME_VAR_END, STATE_VALUE_END],
                     /\(/,        
                     STATE_VAR_BEGIN,
                     start_variation
      
      stm.transition [STATE_NODE, STATE_VALUE_END],
                     /[a-zA-Z]/,  
                     STATE_PROP_NAME_BEGIN,
                     store_input_in_buffer
      
      stm.transition STATE_PROP_NAME_BEGIN,
                     /[a-zA-Z]/,  
                     STATE_PROP_NAME,
                     append_input_to_buffer
      
      stm.transition [STATE_PROP_NAME_BEGIN, STATE_PROP_NAME],    
                     /\[/,        
                     STATE_VALUE_BEGIN,
                     set_property_name
        
      stm.transition STATE_VALUE_END,
                     /\[/,        
                     STATE_VALUE_BEGIN
                     
      stm.transition STATE_VALUE_BEGIN,
                     /[^\]]/,
                     STATE_VALUE,
                     store_input_in_buffer
                       
      stm.transition STATE_VALUE,
                     /[^\]]/,
                     nil,
                     append_input_to_buffer
                       
      stm.transition STATE_VALUE,        
                     /\]/,        
                     STATE_VALUE_END,
                     set_property_value
    
      stm.transition [STATE_NODE, STATE_VALUE_END],
                     /\)/,        
                     STATE_GAME_VAR_END,
                     end_variation

      stm
    end
                       
  end
end
