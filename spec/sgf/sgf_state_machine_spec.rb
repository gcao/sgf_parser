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
    end
    
  end
end