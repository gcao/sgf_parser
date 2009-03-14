require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SGF
  describe SGFStateMachine do
    include SGFStateMachine

    describe "with no context" do
      before :each do
        @stm = create_state_machine
      end

      it "should return state machine for sgf" do
        @stm.class.should == SGF::StateMachine
      end

      it "should have start_state of #{SGFStateMachine::STATE_BEGIN}" do
        @stm.start_state.should == SGFStateMachine::STATE_BEGIN
      end
    
      [
        [SGFStateMachine::STATE_BEGIN,         '(', SGFStateMachine::STATE_GAME_BEGIN],
        [SGFStateMachine::STATE_GAME_BEGIN,    ';', SGFStateMachine::STATE_NODE],
        [SGFStateMachine::STATE_NODE,          'A', SGFStateMachine::STATE_PROP_NAME_BEGIN],
        [SGFStateMachine::STATE_NODE,          ')', SGFStateMachine::STATE_GAME_VAR_END],
        [SGFStateMachine::STATE_PROP_NAME,     '[', SGFStateMachine::STATE_VALUE_BEGIN],
        [SGFStateMachine::STATE_VALUE_BEGIN,   'A', SGFStateMachine::STATE_VALUE],
        [SGFStateMachine::STATE_VALUE,         ']', SGFStateMachine::STATE_VALUE_END],
        [SGFStateMachine::STATE_VALUE_END,     ';', SGFStateMachine::STATE_NODE],
        [SGFStateMachine::STATE_VALUE_END,     '(', SGFStateMachine::STATE_VAR_BEGIN],
        [SGFStateMachine::STATE_VALUE_END,     ')', SGFStateMachine::STATE_GAME_VAR_END],
        [SGFStateMachine::STATE_VALUE_END,     'A', SGFStateMachine::STATE_PROP_NAME_BEGIN],
        [SGFStateMachine::STATE_VAR_BEGIN,     ';', SGFStateMachine::STATE_NODE],
        [SGFStateMachine::STATE_GAME_VAR_END,  ';', SGFStateMachine::STATE_NODE],
        [SGFStateMachine::STATE_GAME_VAR_END,  '(', SGFStateMachine::STATE_VAR_BEGIN]
      ].each do |state_before, input, state_after|
        it "should have transition for '#{state_before}' + '#{input}' => '#{state_after}'" do
          @stm.state = state_before
          @stm.event input
          @stm.state.should == state_after
        end
      end
    end
  
    describe "with context" do
      before :each do
        @context = Object.new
        @stm = create_state_machine @context
      end
      
      it "Transition to game begin should call context.start_game" do
        mock(@context).start_game
        @stm.state = SGFStateMachine::STATE_BEGIN
        @stm.event "("
      end
      
      it "Transition to node should call context.start_node" do
        mock(@context).start_node
        @stm.state = SGFStateMachine::STATE_GAME_BEGIN
        @stm.event ";"
      end
      
      it "Transition to variation begin should call context.start_variation" do
        mock(@context).start_variation
        @stm.state = SGFStateMachine::STATE_NODE
        @stm.event "("
      end
      
      it "Transition to prop name begin should call context.prop_name=" do
        mock(@context).prop_name = "A"
        @stm.state = SGFStateMachine::STATE_NODE
        @stm.event "A"
      end

      it "Transition to prop name from prop name begin should append input to context.prop_name" do
        mock(@context).prop_name { "A" }
        mock(@context).prop_name = "AB"
        @stm.state = SGFStateMachine::STATE_PROP_NAME_BEGIN
        @stm.event "B"
      end
      
      it "Transition to game variation end should call context.end_variation" do
        mock(@context).end_variation
        @stm.state = SGFStateMachine::STATE_VALUE_END
        @stm.event ")"
      end
      
      it "Transition to value should call context.prop_value=" do
        mock(@context).prop_value = "A"
        @stm.state = SGFStateMachine::STATE_VALUE_BEGIN
        @stm.event "A"
      end
      
      it "Transition to value from value should append input to context.prop_value" do
        mock(@context).prop_value { "A" }
        mock(@context).prop_value = "AB"
        @stm.state = SGFStateMachine::STATE_VALUE
        @stm.event "B"
      end
      
      it "Transition to value end should call context.set_property" do
        mock(@context).prop_name { "A" }
        mock(@context).prop_value { "B" }
        mock(@context).set_property "A", "B"
        @stm.state = SGFStateMachine::STATE_VALUE
        @stm.event "]"
      end
    end
    
  end
end