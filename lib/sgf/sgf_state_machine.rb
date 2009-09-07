module SGF
  class SGFStateMachine < StateMachine
    
    STATE_BEGIN           = :begin
    STATE_GAME_BEGIN      = :game_begin       
    STATE_GAME_END        = :game_end
    STATE_NODE            = :node             
    STATE_VAR_BEGIN       = :var_begin        
    STATE_VAR_END         = :game_var_end     
    STATE_PROP_NAME_BEGIN = :prop_name_begin
    STATE_PROP_NAME       = :prop_name        
    STATE_VALUE_BEGIN     = :value_begin      
    STATE_VALUE           = :value            
    STATE_VALUE_END       = :value_end
    STATE_INVALID         = :invalid
    
    def initialize context = nil
      super(STATE_BEGIN)
      self.context = context

      start_game             = lambda{ |stm| return if stm.context.nil?; stm.context.start_game }
      end_game               = lambda{ |stm| return if stm.context.nil?; stm.context.end_game }
      start_node             = lambda{ |stm| return if stm.context.nil?; stm.context.start_node }
      start_variation        = lambda{ |stm| return if stm.context.nil?; stm.context.start_variation }
      store_input_in_buffer  = lambda{ |stm| return if stm.context.nil?; stm.buffer = stm.input }
      append_input_to_buffer = lambda{ |stm| return if stm.context.nil?; stm.buffer += stm.input }
      set_property_name      = lambda{ |stm| return if stm.context.nil?; stm.context.property_name = stm.buffer }
      set_property_value     = lambda{ |stm| return if stm.context.nil?; stm.context.property_value = stm.buffer }
      end_variation          = lambda{ |stm| return if stm.context.nil?; stm.context.end_variation }
      inside_nested_bracket  = lambda{ |stm| stm.bracket_level > 0 }
      increase_bracket_level = lambda{ |stm| stm.increment_bracket_level }
      decrease_bracket_level = lambda{ |stm| stm.decrement_bracket_level }
      report_error           = lambda{ |stm| raise ParseError.new('SGF Error near "' + stm.input + '"') }

      transition STATE_BEGIN,        
                     /\(/,        
                     STATE_GAME_BEGIN,
                     start_game
                           
      transition [STATE_GAME_BEGIN, STATE_VAR_END, STATE_VALUE_END],   
                     /;/,
                     STATE_NODE,
                     start_node
      
      transition STATE_VAR_BEGIN,
                     /;/,
                     STATE_NODE
      
      transition [STATE_NODE, STATE_VAR_END, STATE_VALUE_END],
                     /\(/,        
                     STATE_VAR_BEGIN,
                     start_variation
      
      transition [STATE_NODE, STATE_VALUE_END],
                     /[a-zA-Z]/,  
                     STATE_PROP_NAME_BEGIN,
                     store_input_in_buffer
      
      transition STATE_PROP_NAME_BEGIN,
                     /[a-zA-Z]/,  
                     STATE_PROP_NAME,
                     append_input_to_buffer
      
      transition [STATE_PROP_NAME_BEGIN, STATE_PROP_NAME],    
                     /\[/,        
                     STATE_VALUE_BEGIN,
                     set_property_name
        
      transition STATE_VALUE_END,
                     /\[/,        
                     STATE_VALUE_BEGIN
                     
      transition STATE_VALUE_BEGIN,
                     /[^\]]/,
                     STATE_VALUE,
                     store_input_in_buffer
                       
      transition STATE_VALUE,
                     /\[/,
                     nil,
                     increase_bracket_level
                     
      transition_if inside_nested_bracket,
                     STATE_VALUE,
                     /\]/,
                     nil,
                     decrease_bracket_level
                       
      transition STATE_VALUE,
                     /[^\]]/,
                     nil,
                     append_input_to_buffer
                       
      transition STATE_VALUE,        
                     /\]/,        
                     STATE_VALUE_END,
                     set_property_value
                       
      transition STATE_VAR_END,        
                     nil,        
                     STATE_GAME_END,
                     end_game
    
      transition [STATE_NODE, STATE_VALUE_END],
                     /\)/,        
                     STATE_VAR_END,
                     end_variation

      transition [STATE_BEGIN, STATE_GAME_BEGIN],
                     /[^\s]/, 
                     STATE_INVALID,
                     report_error

    end
              
    def bracket_level
      @bracket_level ||= 0
    end
                       
    def increment_bracket_level
      @bracket_level ||= 0
      @bracket_level += 1
    end
    
    def decrement_bracket_level
      if self.bracket_level > 0
        @bracket_level -= 0
      else
        @bracket_level = 0
      end
    end
  end
end
