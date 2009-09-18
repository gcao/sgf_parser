module SGF
  module More
    class StmDotConverter
      
      STATE_PROPERTIES = {
        SGF::SGFStateMachine::STATE_BEGIN => {
          :pos => 0
        },
        SGF::SGFStateMachine::STATE_GAME_BEGIN => {
          :pos => 1
        },
        SGF::SGFStateMachine::STATE_VAR_BEGIN => {
          :pos => 2
        },
        SGF::SGFStateMachine::STATE_VAR_END => {
          :pos => 99
        },
        SGF::SGFStateMachine::STATE_GAME_END => {
          :pos => 100
        },
        SGF::SGFStateMachine::STATE_INVALID => {
          :pos => 100
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
        s << "label=\"" << (transition.description || pattern_to_label(transition.event_pattern)) << "\""
        s << "];\n"
      end
      
      def pattern_to_label pattern
        if pattern.nil?
          "EOS"
        else
          pattern.inspect[1..-2].gsub("\\", "\\\\")
        end
      end
    end
  end
end