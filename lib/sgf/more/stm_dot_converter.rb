module SGF
  module More
    class StmDotConverter
      
      STATE_PROPERTIES = {
        SGF::SGFStateMachine::STATE_BEGIN => {
        },
        SGF::SGFStateMachine::STATE_GAME_BEGIN => {
        },
        SGF::SGFStateMachine::STATE_VAR_BEGIN => {
        },
        SGF::SGFStateMachine::STATE_GAME_END => {
        },
        SGF::SGFStateMachine::STATE_INVALID => {
        },
      }
      
      def process stm
        s = "digraph SGF_STATE_MACHINE {\n"
        s << create_node_for_state(stm.start_state)

        stm.transitions.each do |start_state, transitions|
          transitions.each do |transition|
            s << create_edge_for_transition(start_state, transition)
          end
        end

        s << "}\n"
        s
      end
      
      private
      
      def create_node_for_state state
        @processed_states ||= []
        return "" if @processed_states.include?(state)
        
        @processed_states << state

        s = state.to_s + "["
        properties = STATE_PROPERTIES[state]
        if properties
          prop_arr = []
          properties.each do |key, value|
            prop_arr << "#{key} = #{value.inspect}"
          end
          s << prop_arr.join(',')
        end
        s << "];\n"
      end
      
      def create_edge_for_transition start_state, transition
        s = ""
        s << create_node_for_state(start_state)

        end_state = transition.after_state || start_state
        s << create_node_for_state(end_state)

        s << start_state.to_s << " -> " << end_state.to_s << "["
        s << "label=\"" << (transition.description || transition.event_pattern.inspect) << "\""
        s << "];\n"
      end
    end
  end
end