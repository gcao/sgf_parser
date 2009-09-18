module SGF
  module More
    class StmDotConverter
      def process stm
        s = "digraph SGF_STATE_MACHINE {\n"
        s << SGF::SGFStateMachine::STATE_BEGIN.to_s << "[];\n"

        @processed_states = []
        stm.transitions.each do |start_state, transitions|
          transitions.each do |transition|
            unless @processed_states.include?(start_state)
              @processed_states << start_state
              s << start_state.to_s << "[];\n"
            end
            end_state = transition.after_state || start_state
            unless @processed_states.include?(end_state)
              @processed_states << end_state
              s << end_state.to_s << "[];\n"
            end
            
            s << start_state.to_s << " -> " << end_state.to_s << "[];\n"
          end
        end

        s << "}\n"
        s
      end
    end
  end
end